# Oracle APEX AI Assistant Voice to Text Plug-in

Oracle APEX Dynamic Action plug-in (APEX 26.1+, `COM.LMOREAUX.VOICE_TO_TEXT`) that adds a Mic Button to an AI Assistant region so users can dictate prompts.

## Engines

Pick exactly one per Dynamic Action; there is no automatic selection or fallback.

| Engine | Audio | Notes |
| --- | --- | --- |
| Web Speech | Sent to a third party by Chrome/Edge | Live interim text, no download, no Firefox |
| Local Model | Stays in the browser | Whisper via Transformers.js, model download on first use, then offline; optional interim text |

Both need HTTPS (or localhost). Full limitations: [plugin/help.md](plugin/help.md), which is also the help text shown in the plug-in's Help tab in APEX.

## Usage

1. Import `plugin/voice-to-text-plugin.sql` into your application (Shared Components > Plug-ins > Import). When running the script with SQLcl into a workspace that already holds these IDs, call `apex_application_install.generate_offset` first.
2. Create a Dynamic Action on page load, action *Voice to Text for AI Assistant*, Affected Element = the AI Assistant region.
3. Pick the Engine. Optionally set Result Mode, Interim Results, Auto-Submit, Typewriter Effect and the Keyboard Shortcut (default Ctrl+Shift+S).
4. Users dictate with the Mic Button or the keyboard shortcut. React to `voice-start`, `voice-result` (`{ text, isFinal, engine }`), `voice-error` (`{ code, message, engine }`), `voice-end`.

Application-level component settings (Shared Components > Component Settings) hold the Actions Selector, the Local Model Library Base URL and Model ID, and the segment and silence timings. A Dynamic Action can overwrite the library and model for itself.

Error codes: `unsupported`, `permission-denied`, `no-microphone`, `model-unavailable`, `network`, `no-speech`.

## Events and troubleshooting

The plug-in fires these events on the AI Assistant region (use a Dynamic Action of event type *Custom*, data in `this.data`): `voice-start`, `voice-result` (`{ text, isFinal, engine }`, `isFinal` is false for interim text), `voice-error` (`{ code, message, engine }`), `voice-end`.

- **Mic Button is crossed out:** the Engine is not supported in this browser (for example Web Speech in Firefox) or no microphone was found. Hover it for the reason.
- **Mic Button is missing:** check the Affected Element is the AI Assistant region and, after an APEX upgrade, the Actions Selector component setting.
- **Local Model never finishes loading:** check the console and network for the Library Base URL and Model ID, and that the browser supports WebAssembly and Web Workers.
- **Nothing happens on a non-HTTPS page:** browsers only allow microphone access on HTTPS or localhost.

## Translating

Every label and tooltip is a plug-in message (`VOICE_INPUT.*`); defaults are in [plugin/messages.json](plugin/messages.json).

## Repository layout

- `src/voice-input.js`, `src/voice-input.css`: runtime and styles
- `plugin/`: messages, help text and `voice-to-text-plugin.sql` (importable plug-in export)
- `applications/voice-to-text-demo/`: APEXlang source of the demo app (app 9100: a home page with an Engine card list and the manual real-microphone checklist, plus one AI Assistant page per Engine; the AI Assistant agent needs a Generative AI service in your workspace), including the plug-in (its `static-files` copies of the runtime are checked against `src/` by the tests; re-export `plugin/voice-to-text-plugin.sql` after changing `src/`)
- `tests/`: Vitest + jsdom tests driving `orclapexVoiceInput.execute(...)` against a fake AI Assistant region
- `CONTEXT.md`: glossary

```bash
npm install
npm test
```

## Licence

MIT, see [LICENSE](LICENSE).
