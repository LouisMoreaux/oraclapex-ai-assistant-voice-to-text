/* Voice Input Plug-in runtime. Public contract: orclapexVoiceInput.execute(context) attaches the Mic Button. */
(function (window) {
  "use strict";

  var DEFAULTS = {
    actionsSelector: ".a-ChatInput-actions",
    cssClasses: "",
    engine: "web-speech",
    resultMode: "append",
    interimResults: false,
    typewriter: false,
    autoSubmit: false,
    libraryUrl: "https://cdn.jsdelivr.net/npm/@huggingface/transformers@3.7.2/dist/",
    modelId: "onnx-community/whisper-base",
    shortcut: "Ctrl+Shift+S",
    segmentPause: 0.5,
    minSegmentLength: 3,
    maxSegmentLength: 15,
    stopSilence: 1.5,
  };

  // Seconds; a missing, zero or invalid value falls back to the default.
  var SECONDS = ["segmentPause", "minSegmentLength", "maxSegmentLength", "stopSilence"];

  var FLAGS = ["interimResults", "typewriter", "autoSubmit"];

  var TARGET_SELECTOR = ".a-ChatInput-text";

  var SEND_SELECTOR = ".a-ChatInput-button--send";

  var MIC_ATTRIBUTE = "data-voice-input-mic";

  var RECORDING_CLASSES = ["fa-anim-flash", "fam-blank", "fam-is-danger"];

  var RECORDING_FLASH_DELAY_MS = 1000;

  var PROCESSING_ICON = "fa fa-spinner fa-lg fa-anim-spin";

  var IDLE_ICON = "fa fa-microphone";

  var INACTIVE_ICON = "fa fa-microphone-slash";

  var NO_MICROPHONE_KEY = "VOICE_INPUT.ERROR.no-microphone";

  var TYPEWRITER_DELAY_MS = 30;

  function message(key) {
    return window.apex.lang.getMessage(key);
  }

  function settingsFrom(raw) {
    var settings = {};
    Object.keys(DEFAULTS).forEach(function (key) {
      settings[key] = raw && raw[key] ? raw[key] : DEFAULTS[key];
    });
    // A blank shortcut is deliberate: it disables the keyboard shortcut.
    if (raw && "shortcut" in raw) {
      settings.shortcut = String(raw.shortcut || "").trim();
    }
    SECONDS.forEach(function (key) {
      var seconds = Number(settings[key]);
      settings[key] = seconds > 0 && isFinite(seconds) ? seconds : DEFAULTS[key];
    });
    FLAGS.forEach(function (key) {
      settings[key] = settings[key] === true || settings[key] === "Y" || settings[key] === "true";
    });
    return settings;
  }

  function defaultTooltip(settings) {
    var label = message("VOICE_INPUT.MIC_LABEL");
    return settings.shortcut ? label + " (" + settings.shortcut + ")" : label;
  }

  function createMicButton(settings) {
    var button = document.createElement("button");
    button.type = "button";
    button.className = ["a-ChatInput-button", "voice-input-mic"]
      .concat(settings.cssClasses.split(/\s+/).filter(Boolean))
      .join(" ");
    button.setAttribute(MIC_ATTRIBUTE, "");
    button.setAttribute("data-state", "idle");
    button.setAttribute("aria-label", message("VOICE_INPUT.MIC_LABEL"));
    button.setAttribute("aria-pressed", "false");
    button.setAttribute("aria-disabled", "false");
    button.title = defaultTooltip(settings);

    var icon = document.createElement("span");
    icon.className = IDLE_ICON;
    icon.setAttribute("aria-hidden", "true");
    button.appendChild(icon);
    return button;
  }

  var instances = new WeakMap();

  // The one instance on the page that is currently listening, if any.
  var active = null;

  function sessionLanguage() {
    var locale = window.apex.locale;
    return (locale && locale.getLanguage && locale.getLanguage()) || document.documentElement.lang || "en";
  }

  function fire(instance, name, detail) {
    detail.engine = instance.settings.engine;
    instance.region.dispatchEvent(new CustomEvent(name, { detail: detail }));
    window.apex.event.trigger(instance.region, name, detail);
  }

  function announce(instance, key) {
    instance.liveRegion.textContent = message(key);
  }

  function setState(instance, state) {
    var previous = instance.state;
    instance.state = state;
    if (state === "blocked") {
      announce(instance, "VOICE_INPUT.BLOCKED");
    } else if (state === "unavailable") {
      announce(instance, instance.noMicrophone ? NO_MICROPHONE_KEY : "VOICE_INPUT.ERROR.unsupported");
    } else if (state === "listening") {
      announce(instance, "VOICE_INPUT.LISTENING");
    } else if (previous === "listening") {
      announce(instance, "VOICE_INPUT.STOPPED");
    }
    var inactive = state === "blocked" || state === "unavailable";
    instance.button.setAttribute("data-state", state);
    instance.button.setAttribute("aria-disabled", String(inactive));
    if (state !== previous) {
      window.clearTimeout(instance.flashTimer);
      instance.icon.className = state === "processing" ? PROCESSING_ICON : inactive ? INACTIVE_ICON : IDLE_ICON;
      if (state === "listening") {
        // The microphone takes a moment to start capturing; only flash once it is.
        instance.flashTimer = window.setTimeout(function () {
          if (instance.state === "listening") {
            instance.icon.className = IDLE_ICON + " " + RECORDING_CLASSES.join(" ");
          }
        }, RECORDING_FLASH_DELAY_MS);
      }
    }
    instance.button.setAttribute("aria-pressed", String(state === "listening"));
  }

  function commonPrefixLength(a, b) {
    var n = Math.min(a.length, b.length);
    var i = 0;
    while (i < n && a.charCodeAt(i) === b.charCodeAt(i)) {
      i++;
    }
    return i;
  }

  // Changes only the tail of the Target that differs, keeping the caret and scroll position.
  function setTargetValue(instance, target, value) {
    var current = target.value;
    if (value === current) {
      return;
    }
    var start = target.selectionStart;
    var end = target.selectionEnd;
    var atEnd = start === current.length && end === current.length;
    var scroll = target.scrollTop;
    var prefix = commonPrefixLength(current, value);
    if (typeof target.setRangeText === "function") {
      target.setRangeText(value.slice(prefix), prefix, current.length, "end");
      if (!atEnd) {
        target.setSelectionRange(Math.min(start, value.length), Math.min(end, value.length));
      }
    } else {
      target.value = value;
    }
    target.scrollTop = scroll;
    instance.writing = true;
    try {
      target.dispatchEvent(new Event("input", { bubbles: true }));
    } finally {
      instance.writing = false;
    }
  }

  // Writes the utterance in progress into the Target. The base text is fixed when the
  // utterance begins: empty for the first utterance of a replace-mode session.
  function writeToTarget(instance, text) {
    var target = instance.region.querySelector(TARGET_SELECTOR);
    if (!target) {
      return;
    }
    if (instance.base === null) {
      var current = target.value;
      instance.base = instance.settings.resultMode === "replace" && !instance.dictated ? "" : current;
    }
    var base = instance.base;
    var separator = text && base && !/\s$/.test(base) ? " " : "";
    setTargetValue(instance, target, base + separator + text);
  }

  // Typewriter Effect: `goal` is the latest transcript of the utterance, `shown` what is in the Target.
  function typewriterTick(instance) {
    instance.typingTimer = null;
    var goal = instance.goal;
    var keep = commonPrefixLength(instance.shown, goal);
    if (instance.shown.length > keep) {
      instance.shown = goal.slice(0, keep);
    } else if (instance.shown.length < goal.length) {
      instance.shown = goal.slice(0, instance.shown.length + 1);
    }
    writeToTarget(instance, instance.shown);
    if (instance.shown === goal) {
      finishTyping(instance);
    } else {
      instance.typingTimer = window.setTimeout(function () { typewriterTick(instance); }, TYPEWRITER_DELAY_MS);
    }
  }

  function finishTyping(instance) {
    window.clearTimeout(instance.typingTimer);
    instance.typingTimer = null;
    if (instance.committed) {
      instance.committed = false;
      instance.base = null;
      instance.goal = "";
      instance.shown = "";
    }
    if (instance.submitWhenTyped) {
      instance.submitWhenTyped = false;
      submit(instance);
    }
  }

  // Puts whatever has not been typed yet into the Target at once.
  function flushTyping(instance) {
    if (instance.shown !== instance.goal) {
      instance.shown = instance.goal;
      writeToTarget(instance, instance.goal);
    }
    finishTyping(instance);
  }

  // `correction` is the Local Model Engine's final pass: it replaces the interim text at once, never typed.
  function present(instance, text, isFinal, correction) {
    // The user edited the Target while the Local Model Engine was dictating: their edit wins.
    if (instance.edited) {
      return;
    }
    // An interim result that revises what is already shown waits for the final result,
    // so text on screen is never taken back.
    if (!isFinal && instance.interimShown && text.indexOf(instance.interimShown) !== 0) {
      return;
    }
    instance.interimShown = isFinal ? "" : text;
    if (correction && instance.settings.typewriter) {
      window.clearTimeout(instance.typingTimer);
      instance.typingTimer = null;
      instance.goal = instance.shown = text;
      writeToTarget(instance, text);
      return;
    }
    if (!instance.settings.typewriter) {
      writeToTarget(instance, text);
      return;
    }
    if (instance.committed) {
      flushTyping(instance);
    }
    instance.goal = text;
    if (!instance.typingTimer) {
      instance.typingTimer = window.setTimeout(function () { typewriterTick(instance); }, TYPEWRITER_DELAY_MS);
    }
  }

  // The user edited the Target while text was being typed: add the rest after their edit and stop.
  function cancelTyping(instance) {
    var target = instance.region.querySelector(TARGET_SELECTOR);
    var rest = instance.goal.slice(commonPrefixLength(instance.shown, instance.goal));
    if (target && rest) {
      var current = target.value;
      setTargetValue(instance, target, (current && !/\s$/.test(current) ? current + " " : current) + rest);
    }
    instance.shown = instance.goal = "";
    instance.committed = true;
    finishTyping(instance);
    instance.base = null;
  }

  var ERROR_CODES = {
    "not-allowed": "permission-denied",
    "service-not-allowed": "permission-denied",
    "network": "network",
    "no-speech": "no-speech",
    "audio-capture": "no-microphone",
    "language-not-supported": "unsupported",
  };

  function reportError(instance, code) {
    fire(instance, "voice-error", { code: code, message: message("VOICE_INPUT.ERROR." + code) });
  }

  function showErrorMessage(key) {
    var apexMessage = window.apex.message;
    if (apexMessage && apexMessage.showErrors) {
      if (apexMessage.clearErrors) {
        apexMessage.clearErrors();
      }
      apexMessage.showErrors([{
        type: "error",
        location: "page",
        message: message(key),
        unsafe: false,
      }]);
    }
  }

  function setTooltip(instance, key) {
    instance.button.title = key ? message(key) : defaultTooltip(instance.settings);
  }

  function webSpeechConstructor() {
    return window.SpeechRecognition || window.webkitSpeechRecognition;
  }

  // Web Speech Engine: audio-to-text only; the runtime owns state, events and Target.
  function createWebSpeechEngine(settings, handlers) {
    var Recognition = webSpeechConstructor();
    var recognition = new Recognition();
    recognition.lang = sessionLanguage();
    recognition.continuous = true;
    recognition.interimResults = settings.interimResults;
    recognition.onstart = handlers.onStart;
    recognition.onend = handlers.onEnd;
    recognition.onerror = function (event) {
      var code = ERROR_CODES[event.error];
      if (code) {
        handlers.onError(code);
      }
    };
    recognition.onresult = function (event) {
      for (var i = event.resultIndex; i < event.results.length; i++) {
        var result = event.results[i];
        if (result.isFinal || settings.interimResults) {
          handlers.onText(result[0].transcript.trim(), result.isFinal);
        }
      }
    };
    return {
      start: function () { recognition.start(); },
      stop: function () { recognition.stop(); },
    };
  }

  // Local Model Engine: records the microphone, then transcribes with Whisper in a Web Worker.
  var TARGET_RATE = 16000;
  var SPEECH_LEVEL = 0.02;
  var NO_SPEECH_SECONDS = 5;
  var MAX_SECONDS = 60;

  // Interim Results: a segment that reaches its maximum length is cut at the quietest point of this many last seconds.
  var FORCED_CUT_WINDOW_SECONDS = 3;

  // Runs inside the Worker: loads Transformers.js, reports download progress, transcribes.
  var WORKER_SOURCE = [
    "let transcriber;",
    "self.onmessage = async (event) => {",
    "  const m = event.data;",
    "  try {",
    "    if (m.type === 'load') {",
    "      const lib = await import(m.libraryUrl + 'transformers.min.js');",
    "      const files = {};",
    "      transcriber = await lib.pipeline('automatic-speech-recognition', m.modelId, {",
    "        device: m.device,",
    "        dtype: m.device === 'webgpu' ? { encoder_model: 'fp32', decoder_model_merged: 'q4' } : 'q8',",
    "        progress_callback: (p) => {",
    "          if (p.status !== 'progress' || !p.total) return;",
    "          files[p.file] = { loaded: p.loaded, total: p.total };",
    "          let loaded = 0, total = 0;",
    "          for (const f of Object.values(files)) { loaded += f.loaded; total += f.total; }",
    "          self.postMessage({ type: 'progress', percent: Math.min(100, Math.round(100 * loaded / total)) });",
    "        },",
    "      });",
    "      self.postMessage({ type: 'ready' });",
    "    } else if (m.type === 'transcribe') {",
    "      const options = { chunk_length_s: 30, stride_length_s: 5, no_repeat_ngram_size: 3 };",
    "      if (m.language) { options.language = m.language; options.task = 'transcribe'; }",
    "      const out = await transcriber(m.audio, options);",
    "      self.postMessage({ type: 'result', text: out.text });",
    "    }",
    "  } catch (e) {",
    "    self.postMessage({ type: 'error', message: String(e) });",
    "  }",
    "};",
  ].join("\n");

  // Loaded models, shared by every instance that asks for the same library and model.
  var models = {};

  function loadModel(settings, onProgress) {
    var key = settings.libraryUrl + "|" + settings.modelId;
    var entry = models[key];
    if (!entry) {
      var url = URL.createObjectURL(new Blob([WORKER_SOURCE], { type: "text/javascript" }));
      var worker = new window.Worker(url, { type: "module" });
      entry = models[key] = { worker: worker, listeners: [] };
      var current = entry;
      var device = window.navigator.gpu ? "webgpu" : "wasm";
      var load = function () {
        worker.postMessage({ type: "load", libraryUrl: settings.libraryUrl, modelId: settings.modelId, device: device });
      };
      entry.ready = new Promise(function (resolve, reject) {
        worker.onmessage = function (event) {
          var m = event.data;
          if (m.type === "progress") {
            current.listeners.forEach(function (listener) { listener(m.percent); });
          } else if (m.type === "ready") {
            resolve();
          } else if (m.type === "error" && device === "webgpu") {
            // WebGPU can be present yet fail to load the model: try once more on the CPU.
            window.console.warn("Voice Input: WebGPU failed (" + m.message + "), falling back to WASM");
            device = "wasm";
            load();
          } else if (m.type === "error") {
            reject(new Error(m.message));
          }
        };
        worker.onerror = reject;
      }).catch(function (error) {
        delete models[key];
        worker.terminate();
        throw error;
      });
      load();
    }
    entry.listeners.push(onProgress);
    return entry.ready.then(function () { return entry; });
  }

  function localModelAvailable() {
    return !!(window.Worker && window.AudioContext && window.navigator.mediaDevices &&
      window.navigator.mediaDevices.getUserMedia);
  }

  function resample(samples, from, to) {
    if (from === to) {
      return samples;
    }
    var out = new Float32Array(Math.floor(samples.length * to / from));
    for (var i = 0; i < out.length; i++) {
      var position = i * from / to;
      var index = Math.floor(position);
      var next = Math.min(index + 1, samples.length - 1);
      var fraction = position - index;
      out[i] = samples[index] * (1 - fraction) + samples[next] * fraction;
    }
    return out;
  }

  function concat(frames, from, to) {
    var length = 0;
    for (var i = from; i < to; i++) {
      length += frames[i].data.length;
    }
    var all = new Float32Array(length);
    var offset = 0;
    for (var j = from; j < to; j++) {
      all.set(frames[j].data, offset);
      offset += frames[j].data.length;
    }
    return all;
  }

  function createLocalModelEngine(settings, handlers) {
    var stream = null;
    var context = null;
    var rate = 0;
    var frames = [];
    var total = 0;
    var quiet = 0;
    var heard = false;
    var recording = false;
    var finished = false;
    var model = null;

    // The current segment is frames[segmentFrom..]; segments are only cut when Interim Results is on.
    var segmentFrom = 0;
    var segmentSamples = 0;
    var segmentQuiet = 0;
    var segmentHeard = false;

    // Segments are transcribed one at a time, in order, then the whole recording once.
    var queue = [];
    var inFlight = null;
    var cutCount = 0;
    var texts = [];
    var stopped = false;
    var finalQueued = false;

    function releaseAudio() {
      if (stream) {
        stream.getTracks().forEach(function (track) { track.stop(); });
        stream = null;
      }
      if (context) {
        context.close();
        context = null;
      }
    }

    function end(afterResult) {
      if (finished) {
        return;
      }
      finished = true;
      recording = false;
      releaseAudio();
      handlers.onEnd(afterResult);
    }

    function fail(code) {
      if (!finished) {
        handlers.onError(code);
        end();
      }
    }

    function send() {
      if (inFlight || !queue.length || finished) {
        return;
      }
      inFlight = queue.shift();
      model.worker.postMessage(
        { type: "transcribe", audio: inFlight.samples, language: /\.en$/i.test(settings.modelId) ? undefined : sessionLanguage().split("-")[0] },
        [inFlight.samples.buffer]
      );
    }

    // After the last segment: the one segment is the result, or the whole recording is transcribed once more.
    function complete() {
      if (!stopped || inFlight || queue.length || finalQueued || finished) {
        return;
      }
      if (!texts.length) {
        fail("no-speech");
      } else if (cutCount === 1) {
        handlers.onText(texts[0], true);
        end(true);
      } else {
        finalQueued = true;
        queue.push({ samples: resample(concat(frames, 0, frames.length), rate, TARGET_RATE), isFinal: true });
        send();
      }
    }

    function received(event) {
      var m = event.data;
      if (finished || !inFlight) {
        return;
      }
      if (m.type === "error") {
        fail("model-unavailable");
        return;
      }
      if (m.type !== "result") {
        return;
      }
      var request = inFlight;
      inFlight = null;
      var text = (m.text || "").trim();
      if (request.isFinal) {
        handlers.onText(text || texts.join(" "), true, true);
        end(true);
        return;
      }
      if (text) {
        texts.push(text);
        if (!stopped || cutCount > 1) {
          handlers.onText(texts.join(" "), false);
        }
      }
      send();
      complete();
    }

    function cut(to) {
      // A segment in which no speech was heard is never sent: Whisper invents text for silence.
      if (segmentHeard) {
        queue.push({ samples: resample(concat(frames, segmentFrom, to), rate, TARGET_RATE) });
        cutCount++;
      }
      segmentFrom = to;
      segmentSamples = 0;
      segmentQuiet = 0;
      segmentHeard = false;
      for (var i = to; i < frames.length; i++) {
        measure(frames[i]);
      }
      send();
    }

    function measure(frame) {
      segmentSamples += frame.data.length;
      if (frame.level > SPEECH_LEVEL) {
        segmentHeard = true;
        segmentQuiet = 0;
      } else {
        segmentQuiet += frame.data.length;
      }
    }

    // The quietest frame of the last few seconds of the segment: the best place to cut mid-speech.
    function quietestFrame() {
      var best = frames.length - 1;
      var covered = 0;
      for (var i = frames.length - 1; i >= segmentFrom && covered < FORCED_CUT_WINDOW_SECONDS * rate; i--) {
        covered += frames[i].data.length;
        if (frames[i].level < frames[best].level) {
          best = i;
        }
      }
      return best;
    }

    function segmentIfDue() {
      if (segmentHeard && segmentQuiet >= settings.segmentPause * rate && segmentSamples >= settings.minSegmentLength * rate) {
        cut(frames.length);
      } else if (segmentSamples >= settings.maxSegmentLength * rate) {
        cut(quietestFrame() + 1);
      }
    }

    function finishRecording() {
      if (!recording) {
        return;
      }
      recording = false;
      releaseAudio();
      if (!heard) {
        fail("no-speech");
        return;
      }
      handlers.onProcessing();
      stopped = true;
      if (segmentHeard) {
        cut(frames.length);
      }
      complete();
    }

    function record() {
      // Firefox cannot connect the microphone to a context at another rate, so record at the
      // device rate and resample to TARGET_RATE afterwards.
      context = new window.AudioContext();
      rate = context.sampleRate;
      var source = context.createMediaStreamSource(stream);
      var processor = context.createScriptProcessor(4096, 1, 1);
      model.worker.onmessage = received;
      processor.onaudioprocess = function (event) {
        if (!recording) {
          return;
        }
        var data = new Float32Array(event.inputBuffer.getChannelData(0));
        var sum = 0;
        for (var i = 0; i < data.length; i++) {
          sum += data[i] * data[i];
        }
        var frame = { data: data, level: Math.sqrt(sum / data.length) };
        frames.push(frame);
        total += data.length;
        measure(frame);
        if (frame.level > SPEECH_LEVEL) {
          heard = true;
          quiet = 0;
        } else {
          quiet += data.length;
        }
        if (settings.interimResults) {
          segmentIfDue();
        }
        if (total >= MAX_SECONDS * rate ||
            (heard && quiet >= settings.stopSilence * rate) ||
            (!heard && total >= NO_SPEECH_SECONDS * rate)) {
          finishRecording();
        }
      };
      source.connect(processor);
      processor.connect(context.destination);
      recording = true;
      handlers.onStart();
    }

    return {
      start: function () {
        handlers.onLoading(0);
        var loading = loadModel(settings, function (percent) {
          // The download outlives a session that failed or was stopped; ignore its progress.
          if (!finished) {
            handlers.onLoading(percent);
          }
        }).catch(function () {
          throw "model-unavailable";
        });
        var microphone = window.navigator.mediaDevices.getUserMedia({ audio: true }).then(function (granted) {
          stream = granted;
          if (finished) {
            releaseAudio();
          }
        }, function (error) {
          var name = error && error.name;
          throw name === "NotAllowedError" || name === "SecurityError" ? "permission-denied" :
            name === "NotFoundError" ? "no-microphone" : "unsupported";
        });
        Promise.all([loading, microphone]).then(function (results) {
          if (finished) {
            return;
          }
          model = results[0];
          try {
            record();
          } catch (error) {
            fail("unsupported");
          }
        }, fail);
      },
      stop: function () {
        if (recording) {
          finishRecording();
        } else if (!model) {
          end();
        }
      },
    };
  }

  var ENGINES = {
    "web-speech": { available: function () { return !!webSpeechConstructor(); }, create: createWebSpeechEngine },
    "local-model": { available: localModelAvailable, create: createLocalModelEngine },
  };

  function engineAvailable(instance) {
    var engine = ENGINES[instance.settings.engine];
    return !!engine && engine.available();
  }

  function submit(instance) {
    var send = instance.region.querySelector(SEND_SELECTOR);
    if (send) {
      send.click();
    }
  }

  function commit(instance, text) {
    instance.pending = null;
    instance.dictated = true;
    if (instance.settings.typewriter) {
      instance.committed = true;
      if (!instance.typingTimer) {
        finishTyping(instance);
      }
    } else {
      instance.base = null;
    }
    fire(instance, "voice-result", { text: text, isFinal: true });
  }

  function markUnavailable(instance) {
    setState(instance, "unavailable");
    setTooltip(instance, instance.noMicrophone ? NO_MICROPHONE_KEY : "VOICE_INPUT.ERROR.unsupported");
  }

  // The user has denied (or restored) microphone access. Takes effect immediately when
  // idle; otherwise when the running dictation ends.
  function setBlocked(instance, blocked) {
    instance.blocked = blocked;
    if (instance.state === "idle" || instance.state === "blocked") {
      setState(instance, blocked ? "blocked" : "idle");
      setTooltip(instance, blocked ? "VOICE_INPUT.BLOCKED" : null);
    }
  }

  function trackPermission(instance) {
    var permissions = window.navigator.permissions;
    if (!permissions || !permissions.query) {
      return;
    }
    var query;
    try {
      query = permissions.query({ name: "microphone" });
    } catch (error) {
      return;
    }
    Promise.resolve(query).then(function (status) {
      instance.permissionTracked = true;
      var apply = function () { setBlocked(instance, status.state === "denied"); };
      status.onchange = apply;
      apply();
    }, function () {});
  }

  function start(instance) {
    // Without the Permissions API the only way to learn that access came back is to try again.
    var retry = instance.state === "blocked" && !instance.permissionTracked;
    if (instance.state !== "idle" && !retry) {
      return;
    }
    if (!engineAvailable(instance)) {
      markUnavailable(instance);
      reportError(instance, "unsupported");
      return;
    }
    if (active && active !== instance) {
      stop(active);
    }
    active = instance;
    flushTyping(instance);
    instance.base = null;
    instance.interimShown = "";
    instance.pending = null;
    instance.dictated = false;
    instance.edited = false;
    instance.engine = ENGINES[instance.settings.engine].create(instance.settings, {
      onLoading: function (percent) {
        setState(instance, "loading");
        instance.button.setAttribute("data-progress", String(percent));
        instance.button.title = message("VOICE_INPUT.LOADING") + " " + percent + "%";
      },
      onProcessing: function () {
        setState(instance, "processing");
        setTooltip(instance, "VOICE_INPUT.PROCESSING");
      },
      onStart: function () {
        instance.blocked = false;
        instance.button.removeAttribute("data-progress");
        setTooltip(instance, null);
        setState(instance, "listening");
        fire(instance, "voice-start", {});
      },
      onText: function (text, isFinal, correction) {
        if (!text) {
          return;
        }
        present(instance, text, isFinal, correction);
        if (isFinal) {
          commit(instance, text);
        } else {
          instance.pending = text;
          fire(instance, "voice-result", { text: text, isFinal: false });
        }
      },
      onError: function (code) {
        reportError(instance, code);
        if (code === "permission-denied") {
          instance.blocked = true;
          setTooltip(instance, "VOICE_INPUT.BLOCKED");
          showErrorMessage("VOICE_INPUT.ERROR.permission-denied");
        } else if (code === "no-microphone") {
          instance.noMicrophone = true;
          showErrorMessage(NO_MICROPHONE_KEY);
        }
      },
      onEnd: function (afterResult) {
        if (instance.pending) {
          commit(instance, instance.pending);
        }
        if (!afterResult) {
          flushTyping(instance);
        }
        instance.engine = null;
        if (active === instance) {
          active = null;
        }
        instance.button.removeAttribute("data-progress");
        if (instance.noMicrophone) {
          markUnavailable(instance);
        } else {
          setState(instance, instance.blocked ? "blocked" : "idle");
          setTooltip(instance, instance.blocked ? "VOICE_INPUT.BLOCKED" : null);
        }
        fire(instance, "voice-end", {});
        if (instance.dictated && instance.settings.autoSubmit) {
          if (instance.typingTimer) {
            instance.submitWhenTyped = true;
          } else {
            submit(instance);
          }
        }
      },
    });
    instance.engine.start();
  }

  function stop(instance) {
    if (instance.engine) {
      instance.engine.stop();
    }
  }

  function toggle(instance) {
    if (instance.state === "listening" || instance.state === "loading") {
      stop(instance);
    } else {
      start(instance);
    }
  }

  var all = [];
  var registeredShortcuts = {};

  // One APEX action per distinct shortcut; it only fires while focus is inside a chat region.
  function registerShortcut(shortcut) {
    if (!shortcut || registeredShortcuts[shortcut]) {
      return;
    }
    registeredShortcuts[shortcut] = true;
    window.apex.actions.add({
      name: "orclapex-voice-input-toggle-" + shortcut.replace(/[^A-Za-z0-9]+/g, "-"),
      label: message("VOICE_INPUT.MIC_LABEL"),
      shortcut: shortcut,
      action: function () {
        var focused = document.activeElement;
        for (var i = 0; i < all.length; i++) {
          var instance = all[i];
          if (instance.settings.shortcut === shortcut && instance.region.isConnected && instance.region.contains(focused)) {
            toggle(instance);
            return;
          }
        }
      },
    });
  }

  function attach(region, rawSettings) {
    var settings = settingsFrom(rawSettings);
    var container = region.querySelector(settings.actionsSelector);
    if (!container || container.querySelector("[" + MIC_ATTRIBUTE + "]")) {
      return;
    }
    var button = createMicButton(settings);
    var liveRegion = document.createElement("span");
    liveRegion.className = "voice-input-live";
    liveRegion.setAttribute("role", "status");
    liveRegion.setAttribute("aria-live", "polite");
    var instance = {
      liveRegion: liveRegion, region: region, settings: settings, button: button, icon: button.querySelector("span"),
      state: "idle", engine: null, base: null, pending: null, dictated: false, blocked: false, edited: false, noMicrophone: false, permissionTracked: false,
      goal: "", shown: "", committed: false, typingTimer: null, submitWhenTyped: false, writing: false,
    };
    instances.set(region, instance);
    button.addEventListener("click", function () { toggle(instance); });
    region.addEventListener("input", function (event) {
      var typed = !instance.writing && event.target.matches && event.target.matches(TARGET_SELECTOR);
      // With interim segments in the Target, a user edit stops further writes for this session.
      if (typed && instance.engine && settings.engine === "local-model" && settings.interimResults &&
          (instance.base !== null || instance.typingTimer)) {
        instance.edited = true;
      }
      if (!instance.writing && instance.typingTimer && event.target.matches && event.target.matches(TARGET_SELECTOR)) {
        cancelTyping(instance);
      }
    });
    container.appendChild(liveRegion);
    container.appendChild(button);
    all = all.filter(function (other) { return other.region.isConnected; });
    all.push(instance);
    registerShortcut(settings.shortcut);
    if (!engineAvailable(instance)) {
      markUnavailable(instance);
      reportError(instance, "unsupported");
    } else {
      trackPermission(instance);
    }
  }

  // The plug-in only attaches; dictation is driven by the Mic Button and the keyboard shortcut.
  // The plug-in's render code may already have added per-action functions to this object.
  window.orclapexVoiceInput = Object.assign(window.orclapexVoiceInput || {}, {
    execute: function (context) {
      attach(context.affectedElement, context.settings);
    },
  });
})(window);
