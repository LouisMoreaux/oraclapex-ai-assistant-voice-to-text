# Voice to Text for AI Assistant

Adds a Mic Button to an APEX AI Assistant region (APEX 26.1 or later). Choose exactly one Engine per Dynamic Action; the plug-in never switches Engine on its own.

**Quick start:** create a Dynamic Action on Page Load, action *Voice to Text for AI Assistant*, Affected Element = the AI Assistant region, then choose the Engine. Events, error codes and troubleshooting are in the project README.

## Web Speech Engine

- Uses the browser's built-in SpeechRecognition API. Lightweight, with live interim text.
- **Audio handling:** in Chrome and Edge the browser sends the audio to a third party cloud service (Google, Microsoft) for recognition. Do not use it where audio must stay on the device.
- **Browser support:** depends on the browser's SpeechRecognition implementation (Chrome and Edge are the reference targets). Firefox does not support it. Where it is missing the Mic Button is shown unavailable (crossed-out microphone, no action) with an explanation in its tooltip.
- **Requires HTTPS** (or localhost) for microphone access, and a network connection.

## Local Model Engine

- Runs a Whisper model in the browser through Transformers.js, inside a Web Worker. It uses WebGPU when the browser offers it and falls back to the CPU (WASM) otherwise. Audio never leaves the device.
- **Download size:** the first use downloads the library and the model. The size depends on the model; the default is the multilingual base model (about 80 MB quantised), and larger models download more. English-only models whose ID ends in .en (for example onnx-community/whisper-base.en) are supported and are more accurate for English. Check the model's published size before choosing one. The button shows the progress percentage. The browser caches the files afterwards, so later uses work offline.
- **Air-gapped installs:** host the library and model yourself and set the Library Base URL and Model ID component settings of the application. To use a different library or model for one Dynamic Action, set Overwrite Library & Model to Yes and enter its own Library Base URL and Model ID.
- **Interim Results:** off by default, the text appears after you stop or after 1.5 seconds of silence. When on, the recording is cut at short pauses and each part is transcribed while you keep talking, so text appears as you speak; when you stop, the whole recording is transcribed once more and that more accurate text corrects what is shown (a short dictation of one phrase skips this step). If you edit the prompt while dictating, your edit is kept and the correction is not written. The correction replaces the text at once, even with Typewriter Effect. Auto-Submit waits for the corrected text. A part in which no speech was heard is never sent to the model. Where a pause ends a segment, the shortest and longest segment and the silence that stops the dictation are set by the Segment Pause, Minimum and Maximum Segment Length and Silence Before Stopping component settings of the application (in seconds). Recording is capped at about 60 seconds.
- **Requires HTTPS** (or localhost) and a browser with WebAssembly and Web Worker support.

## Notes

- Microphone permission is requested only when the user first clicks the Mic Button. If the user denies it, the Mic Button shows as blocked and an APEX error message appears. Where the browser supports the Permissions API the Mic Button follows later permission changes without a reload.
- **Typewriter Effect:** when set to Yes, recognised text is typed into the prompt character by character. Stopping, or editing the prompt, completes the text at once; Auto-Submit waits until the text is typed.
- Recognition uses the APEX session language.
- Starting dictation in one Assistant stops any other active dictation on the page.
- All Mic Button labels and tooltips are plug-in messages (`VOICE_INPUT.*`) that you can translate.
