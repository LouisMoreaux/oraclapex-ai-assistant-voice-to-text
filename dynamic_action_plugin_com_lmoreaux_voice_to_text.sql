prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2026.03.30'
,p_release=>'26.1.5'
,p_default_workspace_id=>51223190626320684
,p_default_application_id=>9100
,p_default_id_offset=>0
,p_default_owner=>'WKSP_AIAGENT'
);
end;
/
 
prompt APPLICATION 9100 - Voice to Text Demo
--
-- Application Export:
--   Application:     9100
--   Name:            Voice to Text Demo
--   Date and Time:   21:36 Tuesday October 13, 2026
--   Exported By:     AI_AGENT
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 32396351144736598
--   Manifest End
--   Version:         26.1.5
--   Instance ID:     8169626539181247
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/dynamic_action/com_lmoreaux_voice_to_text
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(32396351144736598)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'COM.LMOREAUX.VOICE_TO_TEXT'
,p_display_name=>'Voice to Text for AI Assistant'
,p_apexlang_name=>'voiceToTextAIAssistant'
,p_category=>'AI'
,p_javascript_file_urls=>'#PLUGIN_FILES#voice-input.js'
,p_css_file_urls=>'#PLUGIN_FILES#voice-input.css'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'procedure render (',
'    p_plugin         in apex_plugin.t_plugin,',
'    p_dynamic_action in apex_plugin.t_dynamic_action,',
'    p_param          in apex_plugin.t_dynamic_action_render_param,',
'    p_result         in out nocopy apex_plugin.t_dynamic_action_render_result )',
'is',
'    -- Attribute keys: APEX hands render the custom attributes by position (see custom-attributes.apx).',
'    c_engine constant varchar2(12) := ''attribute_02'';',
'    c_resultMode constant varchar2(12) := ''attribute_03'';',
'    c_interimResults constant varchar2(12) := ''attribute_04'';',
'    c_autoSubmit constant varchar2(12) := ''attribute_05'';',
'    c_typewriter constant varchar2(12) := ''attribute_06'';',
'    c_micButtonCssClasses constant varchar2(12) := ''attribute_07'';',
'    c_keyboardShortcut constant varchar2(12) := ''attribute_08'';',
'    c_libraryBaseUrl constant varchar2(12) := ''attribute_09'';',
'    c_modelId constant varchar2(12) := ''attribute_10'';',
'    c_segmentPause constant varchar2(12) := ''attribute_11'';',
'    c_minSegmentLength constant varchar2(12) := ''attribute_12'';',
'    c_maxSegmentLength constant varchar2(12) := ''attribute_13'';',
'    c_stopSilence constant varchar2(12) := ''attribute_14'';',
'    c_overwriteLibraryAndModel constant varchar2(12) := ''attribute_15'';',
'    c_customLibraryBaseUrl constant varchar2(12) := ''attribute_16'';',
'    c_customModelId constant varchar2(12) := ''attribute_17'';',
'    c_actionsSelector constant varchar2(12) := ''attribute_01'';',
'    l_fn     varchar2(100);',
'    l_overwrite boolean := coalesce(p_dynamic_action.attributes.get_varchar2(c_overwriteLibraryAndModel), ''N'') = ''Y'';',
'    l_selector varchar2(1000) := coalesce(',
'            case when p_plugin.attributes is not null then p_plugin.attributes.get_varchar2(c_actionsSelector) end,',
'            p_plugin.attribute_01,',
'            ''.a-ChatInput-actions'');',
'',
'    -- Translatable message, falling back to the shipped English text.',
'    function msg (p_key in varchar2, p_default in varchar2) return varchar2 is',
'        l_text varchar2(4000) := apex_lang.message(p_key);',
'    begin',
'        return case when l_text is null or upper(l_text) = upper(p_key) then p_default else l_text end;',
'    end msg;',
'begin',
'    apex_javascript.add_inline_code(',
'        p_code => ''apex.lang.addMessages({''',
'            || ''"VOICE_INPUT.MIC_LABEL":'' || apex_javascript.add_value(msg(''VOICE_INPUT.MIC_LABEL'', ''Dictate''), false) || '',''',
'            || ''"VOICE_INPUT.LISTENING":'' || apex_javascript.add_value(msg(''VOICE_INPUT.LISTENING'', ''Listening''), false) || '',''',
'            || ''"VOICE_INPUT.STOPPED":'' || apex_javascript.add_value(msg(''VOICE_INPUT.STOPPED'', ''Stopped listening''), false) || '',''',
'            || ''"VOICE_INPUT.LOADING":'' || apex_javascript.add_value(msg(''VOICE_INPUT.LOADING'', ''Loading speech model''), false) || '',''',
'            || ''"VOICE_INPUT.BLOCKED":'' || apex_javascript.add_value(msg(''VOICE_INPUT.BLOCKED'', ''Microphone blocked. Allow it in the site settings of your browser to dictate.''), false) || '',''',
'            || ''"VOICE_INPUT.PROCESSING":'' || apex_javascript.add_value(msg(''VOICE_INPUT.PROCESSING'', ''Transcribing''), false) || '',''',
'            || ''"VOICE_INPUT.ERROR.unsupported":'' || apex_javascript.add_value(msg(''VOICE_INPUT.ERROR.unsupported'', ''Voice input is not supported by this browser or engine.''), false) || '',''',
'            || ''"VOICE_INPUT.ERROR.permission-denied":'' || apex_javascript.add_value(msg(''VOICE_INPUT.ERROR.permission-denied'', ''Microphone access was denied. Allow it in your browser settings to dictate.''), false) || '',''',
'            || ''"VOICE_INPUT.ERROR.no-microphone":'' || apex_javascript.add_value(msg(''VOICE_INPUT.ERROR.no-microphone'', ''No microphone found. Check that one is connected and that your browser is allowed to use it.''), false) || '',''',
'            || ''"VOICE_INPUT.ERROR.model-unavailable":'' || apex_javascript.add_value(msg(''VOICE_INPUT.ERROR.model-unavailable'', ''The speech model could not be loaded.''), false) || '',''',
'            || ''"VOICE_INPUT.ERROR.network":'' || apex_javascript.add_value(msg(''VOICE_INPUT.ERROR.network'', ''A network error interrupted voice input.''), false) || '',''',
'            || ''"VOICE_INPUT.ERROR.no-speech":'' || apex_javascript.add_value(msg(''VOICE_INPUT.ERROR.no-speech'', ''No speech was detected.''), false)',
'            || ''});''',
'    );',
'    apex_javascript.add_inline_code(p_code => ''window.orclapexVoiceInput=window.orclapexVoiceInput||{};'');',
'    l_fn := ''orclapexVoiceInput.da_'' || p_dynamic_action.id;',
'    apex_javascript.add_inline_code(',
'        p_code => l_fn || ''=function(s,c){orclapexVoiceInput.execute({affectedElement:c.affectedElements[0],settings:{''',
'            || ''engine:'' || apex_javascript.add_value(p_dynamic_action.attributes.get_varchar2(c_engine), false) || '',''',
'            || ''resultMode:'' || apex_javascript.add_value(p_dynamic_action.attributes.get_varchar2(c_resultMode), false) || '',''',
'            || ''interimResults:'' || apex_javascript.add_value(coalesce(p_dynamic_action.attributes.get_varchar2(c_interimResults) = ''Y'', false), false) || '',''',
'            || ''autoSubmit:'' || apex_javascript.add_value(coalesce(p_dynamic_action.attributes.get_varchar2(c_autoSubmit) = ''Y'', false), false) || '',''',
'            || ''typewriter:'' || apex_javascript.add_value(coalesce(p_dynamic_action.attributes.get_varchar2(c_typewriter) = ''Y'', false), false) || '',''',
'            || ''cssClasses:'' || apex_javascript.add_value(p_dynamic_action.attributes.get_varchar2(c_micButtonCssClasses), false) || '',''',
'            || ''shortcut:'' || apex_javascript.add_value(p_dynamic_action.attributes.get_varchar2(c_keyboardShortcut), false) || '',''',
'            || ''libraryUrl:'' || apex_javascript.add_value(case when l_overwrite then p_dynamic_action.attributes.get_varchar2(c_customLibraryBaseUrl) else p_plugin.attributes.get_varchar2(c_libraryBaseUrl) end, false) || '',''',
'            || ''modelId:'' || apex_javascript.add_value(case when l_overwrite then p_dynamic_action.attributes.get_varchar2(c_customModelId) else p_plugin.attributes.get_varchar2(c_modelId) end, false) || '',''',
'            || ''segmentPause:'' || apex_javascript.add_value(p_plugin.attributes.get_number(c_segmentPause), false) || '',''',
'            || ''minSegmentLength:'' || apex_javascript.add_value(p_plugin.attributes.get_number(c_minSegmentLength), false) || '',''',
'            || ''maxSegmentLength:'' || apex_javascript.add_value(p_plugin.attributes.get_number(c_maxSegmentLength), false) || '',''',
'            || ''stopSilence:'' || apex_javascript.add_value(p_plugin.attributes.get_number(c_stopSilence), false) || '',''',
'            || ''actionsSelector:'' || apex_javascript.add_value(l_selector, false)',
'            || ''}});};''',
'    );',
'    p_result.function_name := l_fn;',
'end render;'))
,p_api_version=>3
,p_render_function=>'render'
,p_standard_attributes=>'REGION:REQUIRED:ONLOAD'
,p_version_scn=>'SH256:vfKDCBDzm7YY7x3cb9b9eu41zGzAp52Q-0sQdD7XECM'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'# Voice to Text for AI Assistant',
'',
'Adds a Mic Button to an APEX AI Assistant region (APEX 26.1 or later). Choose exactly one Engine per Dynamic Action; the plug-in never switches Engine on its own.',
'',
'**Quick start:** create a Dynamic Action on Page Load, action *Voice to Text for AI Assistant*, Affected Element = the AI Assistant region, then choose the Engine. Events, error codes and troubleshooting are in the project README.',
'',
'## Web Speech Engine',
'',
'- Uses the browser''s built-in SpeechRecognition API. Lightweight, with live interim text.',
'- **Audio handling:** in Chrome and Edge the browser sends the audio to a third party cloud service (Google, Microsoft) for recognition. Do not use it where audio must stay on the device.',
'- **Browser support:** depends on the browser''s SpeechRecognition implementation (Chrome and Edge are the reference targets). Firefox does not support it. Where it is missing the Mic Button is shown unavailable (crossed-out microphone, no action) wit'
||'h an explanation in its tooltip.',
'- **Requires HTTPS** (or localhost) for microphone access, and a network connection.',
'',
'## Local Model Engine',
'',
'- Runs a Whisper model in the browser through Transformers.js, inside a Web Worker. It uses WebGPU when the browser offers it and falls back to the CPU (WASM) otherwise. Audio never leaves the device.',
'- **Download size:** the first use downloads the library and the model. The size depends on the model; the default is the multilingual base model (about 80 MB quantised), and larger models download more. English-only models whose ID ends in .en (for '
||'example onnx-community/whisper-base.en) are supported and are more accurate for English. Check the model''s published size before choosing one. The button shows the progress percentage. The browser caches the files afterwards, so later uses work offli'
||'ne.',
'- **Air-gapped installs:** host the library and model yourself and set the Library Base URL and Model ID component settings of the application. To use a different library or model for one Dynamic Action, set Overwrite Library & Model to Yes and enter'
||' its own Library Base URL and Model ID.',
'- **Interim Results:** off by default, the text appears after you stop or after 1.5 seconds of silence. When on, the recording is cut at short pauses and each part is transcribed while you keep talking, so text appears as you speak; when you stop, th'
||'e whole recording is transcribed once more and that more accurate text corrects what is shown (a short dictation of one phrase skips this step). If you edit the prompt while dictating, your edit is kept and the correction is not written. The correcti'
||'on replaces the text at once, even with Typewriter Effect. Auto-Submit waits for the corrected text. A part in which no speech was heard is never sent to the model. Where a pause ends a segment, the shortest and longest segment and the silence that s'
||'tops the dictation are set by the Segment Pause, Minimum and Maximum Segment Length and Silence Before Stopping component settings of the application (in seconds). Recording is capped at about 60 seconds.',
'- **Requires HTTPS** (or localhost) and a browser with WebAssembly and Web Worker support.',
'',
'## Notes',
'',
'- Microphone permission is requested only when the user first clicks the Mic Button. If the user denies it, the Mic Button shows as blocked and an APEX error message appears. Where the browser supports the Permissions API the Mic Button follows later'
||' permission changes without a reload.',
'- **Typewriter Effect:** when set to Yes, recognised text is typed into the prompt character by character. Stopping, or editing the prompt, completes the text at once; Auto-Submit waits until the text is typed.',
'- Recognition uses the APEX session language.',
'- Starting dictation in one chat stops any other active dictation on the page.',
'- All Mic Button labels and tooltips are plug-in messages (`VOICE_INPUT.*`) that you can translate.'))
,p_version_identifier=>'1.0.0'
,p_about_url=>'https://github.com/LouisMoreaux/oraclapex-ai-assistant-voice-to-text'
,p_files_version=>2461327204554
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(32396467519736599)
,p_plugin_id=>wwv_flow_imp.id(32396351144736598)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>1
,p_display_sequence=>110
,p_static_id=>'attribute_01'
,p_prompt=>'Actions Selector'
,p_apexlang_name=>'actionsSelector'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'.a-ChatInput-actions'
,p_is_translatable=>false
,p_help_text=>'CSS selector of the container inside the AI Chat where the Mic Button is injected. Change it if an APEX upgrade renames the markup.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(32397050299736600)
,p_plugin_id=>wwv_flow_imp.id(32396351144736598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_static_id=>'attribute_02'
,p_prompt=>'Engine'
,p_apexlang_name=>'engine'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'web-speech'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Exactly one Engine per Dynamic Action; the plug-in never falls back to another. See the plug-in help for each Engine''s limitations.'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(32397146137736600)
,p_plugin_attribute_id=>wwv_flow_imp.id(32397050299736600)
,p_display_sequence=>20
,p_display_value=>'Local Model (in-browser Whisper)'
,p_return_value=>'local-model'
,p_apexlang_name=>'localModelInBrowserWhisper'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(32397244918736601)
,p_plugin_attribute_id=>wwv_flow_imp.id(32397050299736600)
,p_display_sequence=>10
,p_display_value=>'Web Speech (browser, audio sent to a third party)'
,p_return_value=>'web-speech'
,p_apexlang_name=>'webSpeechBrowserAudioSentToAThirdParty'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(32397325296736601)
,p_plugin_id=>wwv_flow_imp.id(32396351144736598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_static_id=>'attribute_03'
,p_prompt=>'Result Mode'
,p_apexlang_name=>'resultMode'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'append'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Append adds dictated text to the prompt; Replace overwrites it.'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(32397466493736601)
,p_plugin_attribute_id=>wwv_flow_imp.id(32397325296736601)
,p_display_sequence=>10
,p_display_value=>'Append'
,p_return_value=>'append'
,p_apexlang_name=>'append'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(32397559781736601)
,p_plugin_attribute_id=>wwv_flow_imp.id(32397325296736601)
,p_display_sequence=>20
,p_display_value=>'Replace'
,p_return_value=>'replace'
,p_apexlang_name=>'replace'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(32397656713736601)
,p_plugin_id=>wwv_flow_imp.id(32396351144736598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_static_id=>'attribute_04'
,p_prompt=>'Interim Results'
,p_apexlang_name=>'interimResults'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_help_text=>'Show live text while speaking. With the Local Model Engine, text is transcribed at short pauses and corrected when dictation stops.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(32397786107736602)
,p_plugin_id=>wwv_flow_imp.id(32396351144736598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_static_id=>'attribute_05'
,p_prompt=>'Auto-Submit'
,p_apexlang_name=>'autoSubmit'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_help_text=>'Send the prompt automatically when dictation ends.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(32397890048736602)
,p_plugin_id=>wwv_flow_imp.id(32396351144736598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>45
,p_static_id=>'attribute_06'
,p_prompt=>'Typewriter Effect'
,p_apexlang_name=>'typewriter'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_help_text=>'Reveal recognised text character by character instead of all at once.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(32397927343736602)
,p_plugin_id=>wwv_flow_imp.id(32396351144736598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_static_id=>'attribute_07'
,p_prompt=>'Mic Button CSS Classes'
,p_apexlang_name=>'micButtonCssClasses'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>'Extra CSS classes for the Mic Button.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(32398005175736603)
,p_plugin_id=>wwv_flow_imp.id(32396351144736598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_static_id=>'attribute_08'
,p_prompt=>'Keyboard Shortcut'
,p_apexlang_name=>'keyboardShortcut'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'Ctrl+Shift+S'
,p_is_translatable=>false
,p_help_text=>'Toggles dictation while focus is in the chat. Leave blank to disable.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(32398132955736603)
,p_plugin_id=>wwv_flow_imp.id(32396351144736598)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_static_id=>'attribute_09'
,p_prompt=>'Library Base URL'
,p_apexlang_name=>'libraryBaseUrl'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'https://cdn.jsdelivr.net/npm/@huggingface/transformers@3.7.2/dist/'
,p_is_translatable=>false
,p_help_text=>'Local Model Engine only, application default: base URL of the pinned Transformers.js library. Host it yourself for air-gapped installs.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(32398241222736603)
,p_plugin_id=>wwv_flow_imp.id(32396351144736598)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>10
,p_display_sequence=>100
,p_static_id=>'attribute_10'
,p_prompt=>'Model ID'
,p_apexlang_name=>'modelId'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'onnx-community/whisper-base'
,p_is_translatable=>false
,p_help_text=>'Local Model Engine only, application default: Whisper model identifier.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(32398241223736603)
,p_plugin_id=>wwv_flow_imp.id(32396351144736598)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>11
,p_display_sequence=>41
,p_static_id=>'attribute_11'
,p_prompt=>'Segment Pause (seconds)'
,p_apexlang_name=>'segmentPause'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'0.5'
,p_is_translatable=>false
,p_help_text=>'Local Model Engine: length of silence that ends a segment, so its text can appear while the user keeps talking. Only used when Interim Results is enabled.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(32398241223847714)
,p_plugin_id=>wwv_flow_imp.id(32396351144736598)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>12
,p_display_sequence=>42
,p_static_id=>'attribute_12'
,p_prompt=>'Minimum Segment Length (seconds)'
,p_apexlang_name=>'minSegmentLength'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'3'
,p_is_translatable=>false
,p_help_text=>'Local Model Engine: shortest segment that is sent to the model. Only used when Interim Results is enabled.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(32398241223958825)
,p_plugin_id=>wwv_flow_imp.id(32396351144736598)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>13
,p_display_sequence=>43
,p_static_id=>'attribute_13'
,p_prompt=>'Maximum Segment Length (seconds)'
,p_apexlang_name=>'maxSegmentLength'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'15'
,p_is_translatable=>false
,p_help_text=>'Local Model Engine: a longer segment is cut at its quietest point. Only used when Interim Results is enabled.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(32398241224069936)
,p_plugin_id=>wwv_flow_imp.id(32396351144736598)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>14
,p_display_sequence=>44
,p_static_id=>'attribute_14'
,p_prompt=>'Silence Before Stopping (seconds)'
,p_apexlang_name=>'stopSilence'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'1.5'
,p_is_translatable=>false
,p_help_text=>'Local Model Engine only: length of silence after speech that stops the dictation.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(32398241224181047)
,p_plugin_id=>wwv_flow_imp.id(32396351144736598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>15
,p_display_sequence=>85
,p_static_id=>'attribute_15'
,p_prompt=>'Overwrite Library & Model'
,p_apexlang_name=>'overwriteLibraryAndModel'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(32397050299736600)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'local-model'
,p_help_text=>'Local Model Engine only: use the Library Base URL and Model ID below instead of the application-level values for this Dynamic Action.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(32398241224292158)
,p_plugin_id=>wwv_flow_imp.id(32396351144736598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>16
,p_display_sequence=>90
,p_static_id=>'attribute_16'
,p_prompt=>'Library Base URL'
,p_apexlang_name=>'customLibraryBaseUrl'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'https://cdn.jsdelivr.net/npm/@huggingface/transformers@3.7.2/dist/'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(32398241224181047)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>'Base URL of the pinned Transformers.js library for this Dynamic Action. Host it yourself for air-gapped installs.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(32398241224403269)
,p_plugin_id=>wwv_flow_imp.id(32396351144736598)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>17
,p_display_sequence=>100
,p_static_id=>'attribute_17'
,p_prompt=>'Model ID'
,p_apexlang_name=>'customModelId'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'onnx-community/whisper-base'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(32398241224181047)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>'Whisper model identifier for this Dynamic Action.'
);
wwv_flow_imp_shared.create_plugin_event(
 p_id=>wwv_flow_imp.id(32398322853736603)
,p_plugin_id=>wwv_flow_imp.id(32396351144736598)
,p_name=>'voice-end'
,p_display_name=>'Voice End'
);
wwv_flow_imp_shared.create_plugin_event(
 p_id=>wwv_flow_imp.id(32398460475736604)
,p_plugin_id=>wwv_flow_imp.id(32396351144736598)
,p_name=>'voice-error'
,p_display_name=>'Voice Error'
);
wwv_flow_imp_shared.create_plugin_event(
 p_id=>wwv_flow_imp.id(32398554687736604)
,p_plugin_id=>wwv_flow_imp.id(32396351144736598)
,p_name=>'voice-result'
,p_display_name=>'Voice Result'
);
wwv_flow_imp_shared.create_plugin_event(
 p_id=>wwv_flow_imp.id(32398671251736604)
,p_plugin_id=>wwv_flow_imp.id(32396351144736598)
,p_name=>'voice-start'
,p_display_name=>'Voice Start'
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2E766F6963652D696E7075742D6D69635B617269612D64697361626C65643D2274727565225D207B0A20206F7061636974793A20302E353B0A2020637572736F723A206E6F742D616C6C6F7765643B0A7D0A2E766F6963652D696E7075742D6D69635B64';
wwv_flow_imp.g_varchar2_table(2) := '6174612D73746174653D226C6F6164696E67225D2C0A2E766F6963652D696E7075742D6D69635B646174612D73746174653D2270726F63657373696E67225D207B0A20206F7061636974793A20302E373B0A2020637572736F723A2070726F6772657373';
wwv_flow_imp.g_varchar2_table(3) := '3B0A7D0A2E766F6963652D696E7075742D6D69635B646174612D73746174653D226C6F6164696E67225D5B646174612D70726F67726573735D3A3A6166746572207B0A2020636F6E74656E743A206174747228646174612D70726F677265737329202225';
wwv_flow_imp.g_varchar2_table(4) := '223B0A20206D617267696E2D696E6C696E652D73746172743A20302E3235656D3B0A2020666F6E742D73697A653A20302E3735656D3B0A7D0A2E766F6963652D696E7075742D6C697665207B0A2020706F736974696F6E3A206162736F6C7574653B0A20';
wwv_flow_imp.g_varchar2_table(5) := '2077696474683A203170783B0A20206865696768743A203170783B0A20206F766572666C6F773A2068696464656E3B0A2020636C69703A20726563742830203020302030293B0A202077686974652D73706163653A206E6F777261703B0A7D0A';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(32398774975736604)
,p_plugin_id=>wwv_flow_imp.id(32396351144736598)
,p_file_name=>'voice-input.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2A20566F69636520496E70757420506C75672D696E2072756E74696D652E205075626C696320636F6E74726163743A206F72636C61706578566F696365496E7075742E6578656375746528636F6E746578742920617474616368657320746865204D69';
wwv_flow_imp.g_varchar2_table(2) := '6320427574746F6E2E202A2F0A2866756E6374696F6E202877696E646F7729207B0A20202275736520737472696374223B0A0A20207661722044454641554C5453203D207B0A20202020616374696F6E7353656C6563746F723A20222E612D4368617449';
wwv_flow_imp.g_varchar2_table(3) := '6E7075742D616374696F6E73222C0A20202020637373436C61737365733A2022222C0A20202020656E67696E653A20227765622D737065656368222C0A20202020726573756C744D6F64653A2022617070656E64222C0A20202020696E746572696D5265';
wwv_flow_imp.g_varchar2_table(4) := '73756C74733A2066616C73652C0A20202020747970657772697465723A2066616C73652C0A202020206175746F5375626D69743A2066616C73652C0A202020206C69627261727955726C3A202268747470733A2F2F63646E2E6A7364656C6976722E6E65';
wwv_flow_imp.g_varchar2_table(5) := '742F6E706D2F4068756767696E67666163652F7472616E73666F726D65727340332E372E322F646973742F222C0A202020206D6F64656C49643A20226F6E6E782D636F6D6D756E6974792F776869737065722D62617365222C0A2020202073686F727463';
wwv_flow_imp.g_varchar2_table(6) := '75743A20224374726C2B53686966742B53222C0A202020207365676D656E7450617573653A20302E352C0A202020206D696E5365676D656E744C656E6774683A20332C0A202020206D61785365676D656E744C656E6774683A2031352C0A202020207374';
wwv_flow_imp.g_varchar2_table(7) := '6F7053696C656E63653A20312E352C0A20207D3B0A0A20202F2F205365636F6E64733B2061206D697373696E672C207A65726F206F7220696E76616C69642076616C75652066616C6C73206261636B20746F207468652064656661756C742E0A20207661';
wwv_flow_imp.g_varchar2_table(8) := '72205345434F4E4453203D205B227365676D656E745061757365222C20226D696E5365676D656E744C656E677468222C20226D61785365676D656E744C656E677468222C202273746F7053696C656E6365225D3B0A0A202076617220464C414753203D20';
wwv_flow_imp.g_varchar2_table(9) := '5B22696E746572696D526573756C7473222C202274797065777269746572222C20226175746F5375626D6974225D3B0A0A2020766172205441524745545F53454C4543544F52203D20222E612D43686174496E7075742D74657874223B0A0A2020766172';
wwv_flow_imp.g_varchar2_table(10) := '2053454E445F53454C4543544F52203D20222E612D43686174496E7075742D627574746F6E2D2D73656E64223B0A0A2020766172204D49435F415454524942555445203D2022646174612D766F6963652D696E7075742D6D6963223B0A0A202076617220';
wwv_flow_imp.g_varchar2_table(11) := '5245434F5244494E475F434C4153534553203D205B2266612D616E696D2D666C617368222C202266616D2D626C616E6B222C202266616D2D69732D64616E676572225D3B0A0A2020766172205245434F5244494E475F464C4153485F44454C41595F4D53';
wwv_flow_imp.g_varchar2_table(12) := '203D20313030303B0A0A20207661722050524F43455353494E475F49434F4E203D202266612066612D7370696E6E65722066612D6C672066612D616E696D2D7370696E223B0A0A20207661722049444C455F49434F4E203D202266612066612D6D696372';
wwv_flow_imp.g_varchar2_table(13) := '6F70686F6E65223B0A0A202076617220494E4143544956455F49434F4E203D202266612066612D6D6963726F70686F6E652D736C617368223B0A0A2020766172204E4F5F4D4943524F50484F4E455F4B4559203D2022564F4943455F494E5055542E4552';
wwv_flow_imp.g_varchar2_table(14) := '524F522E6E6F2D6D6963726F70686F6E65223B0A0A202076617220545950455752495445525F44454C41595F4D53203D2033303B0A0A202066756E6374696F6E206D657373616765286B657929207B0A2020202072657475726E2077696E646F772E6170';
wwv_flow_imp.g_varchar2_table(15) := '65782E6C616E672E6765744D657373616765286B6579293B0A20207D0A0A202066756E6374696F6E2073657474696E677346726F6D2872617729207B0A202020207661722073657474696E6773203D207B7D3B0A202020204F626A6563742E6B65797328';
wwv_flow_imp.g_varchar2_table(16) := '44454641554C5453292E666F72456163682866756E6374696F6E20286B657929207B0A20202020202073657474696E67735B6B65795D203D20726177202626207261775B6B65795D203F207261775B6B65795D203A2044454641554C54535B6B65795D3B';
wwv_flow_imp.g_varchar2_table(17) := '0A202020207D293B0A202020202F2F204120626C616E6B2073686F72746375742069732064656C696265726174653A2069742064697361626C657320746865206B6579626F6172642073686F72746375742E0A2020202069662028726177202626202273';
wwv_flow_imp.g_varchar2_table(18) := '686F72746375742220696E2072617729207B0A20202020202073657474696E67732E73686F7274637574203D20537472696E67287261772E73686F7274637574207C7C202222292E7472696D28293B0A202020207D0A202020205345434F4E44532E666F';
wwv_flow_imp.g_varchar2_table(19) := '72456163682866756E6374696F6E20286B657929207B0A202020202020766172207365636F6E6473203D204E756D6265722873657474696E67735B6B65795D293B0A20202020202073657474696E67735B6B65795D203D207365636F6E6473203E203020';
wwv_flow_imp.g_varchar2_table(20) := '262620697346696E697465287365636F6E647329203F207365636F6E6473203A2044454641554C54535B6B65795D3B0A202020207D293B0A20202020464C4147532E666F72456163682866756E6374696F6E20286B657929207B0A202020202020736574';
wwv_flow_imp.g_varchar2_table(21) := '74696E67735B6B65795D203D2073657474696E67735B6B65795D203D3D3D2074727565207C7C2073657474696E67735B6B65795D203D3D3D20225922207C7C2073657474696E67735B6B65795D203D3D3D202274727565223B0A202020207D293B0A2020';
wwv_flow_imp.g_varchar2_table(22) := '202072657475726E2073657474696E67733B0A20207D0A0A202066756E6374696F6E2064656661756C74546F6F6C7469702873657474696E677329207B0A20202020766172206C6162656C203D206D6573736167652822564F4943455F494E5055542E4D';
wwv_flow_imp.g_varchar2_table(23) := '49435F4C4142454C22293B0A2020202072657475726E2073657474696E67732E73686F7274637574203F206C6162656C202B2022202822202B2073657474696E67732E73686F7274637574202B20222922203A206C6162656C3B0A20207D0A0A20206675';
wwv_flow_imp.g_varchar2_table(24) := '6E6374696F6E206372656174654D6963427574746F6E2873657474696E677329207B0A2020202076617220627574746F6E203D20646F63756D656E742E637265617465456C656D656E742822627574746F6E22293B0A20202020627574746F6E2E747970';
wwv_flow_imp.g_varchar2_table(25) := '65203D2022627574746F6E223B0A20202020627574746F6E2E636C6173734E616D65203D205B22612D43686174496E7075742D627574746F6E222C2022766F6963652D696E7075742D6D6963225D0A2020202020202E636F6E6361742873657474696E67';
wwv_flow_imp.g_varchar2_table(26) := '732E637373436C61737365732E73706C6974282F5C732B2F292E66696C74657228426F6F6C65616E29290A2020202020202E6A6F696E28222022293B0A20202020627574746F6E2E736574417474726962757465284D49435F4154545249425554452C20';
wwv_flow_imp.g_varchar2_table(27) := '2222293B0A20202020627574746F6E2E7365744174747269627574652822646174612D7374617465222C202269646C6522293B0A20202020627574746F6E2E7365744174747269627574652822617269612D6C6162656C222C206D657373616765282256';
wwv_flow_imp.g_varchar2_table(28) := '4F4943455F494E5055542E4D49435F4C4142454C2229293B0A20202020627574746F6E2E7365744174747269627574652822617269612D70726573736564222C202266616C736522293B0A20202020627574746F6E2E7365744174747269627574652822';
wwv_flow_imp.g_varchar2_table(29) := '617269612D64697361626C6564222C202266616C736522293B0A20202020627574746F6E2E7469746C65203D2064656661756C74546F6F6C7469702873657474696E6773293B0A0A202020207661722069636F6E203D20646F63756D656E742E63726561';
wwv_flow_imp.g_varchar2_table(30) := '7465456C656D656E7428227370616E22293B0A2020202069636F6E2E636C6173734E616D65203D2049444C455F49434F4E3B0A2020202069636F6E2E7365744174747269627574652822617269612D68696464656E222C20227472756522293B0A202020';
wwv_flow_imp.g_varchar2_table(31) := '20627574746F6E2E617070656E644368696C642869636F6E293B0A2020202072657475726E20627574746F6E3B0A20207D0A0A202076617220696E7374616E636573203D206E6577205765616B4D617028293B0A0A20202F2F20546865206F6E6520696E';
wwv_flow_imp.g_varchar2_table(32) := '7374616E6365206F6E20746865207061676520746861742069732063757272656E746C79206C697374656E696E672C20696620616E792E0A202076617220616374697665203D206E756C6C3B0A0A202066756E6374696F6E2073657373696F6E4C616E67';
wwv_flow_imp.g_varchar2_table(33) := '756167652829207B0A20202020766172206C6F63616C65203D2077696E646F772E617065782E6C6F63616C653B0A2020202072657475726E20286C6F63616C65202626206C6F63616C652E6765744C616E6775616765202626206C6F63616C652E676574';
wwv_flow_imp.g_varchar2_table(34) := '4C616E6775616765282929207C7C20646F63756D656E742E646F63756D656E74456C656D656E742E6C616E67207C7C2022656E223B0A20207D0A0A202066756E6374696F6E206669726528696E7374616E63652C206E616D652C2064657461696C29207B';
wwv_flow_imp.g_varchar2_table(35) := '0A2020202064657461696C2E656E67696E65203D20696E7374616E63652E73657474696E67732E656E67696E653B0A20202020696E7374616E63652E726567696F6E2E64697370617463684576656E74286E657720437573746F6D4576656E74286E616D';
wwv_flow_imp.g_varchar2_table(36) := '652C207B2064657461696C3A2064657461696C207D29293B0A2020202077696E646F772E617065782E6576656E742E7472696767657228696E7374616E63652E726567696F6E2C206E616D652C2064657461696C293B0A20207D0A0A202066756E637469';
wwv_flow_imp.g_varchar2_table(37) := '6F6E20616E6E6F756E636528696E7374616E63652C206B657929207B0A20202020696E7374616E63652E6C697665526567696F6E2E74657874436F6E74656E74203D206D657373616765286B6579293B0A20207D0A0A202066756E6374696F6E20736574';
wwv_flow_imp.g_varchar2_table(38) := '537461746528696E7374616E63652C20737461746529207B0A202020207661722070726576696F7573203D20696E7374616E63652E73746174653B0A20202020696E7374616E63652E7374617465203D2073746174653B0A202020206966202873746174';
wwv_flow_imp.g_varchar2_table(39) := '65203D3D3D2022626C6F636B65642229207B0A202020202020616E6E6F756E636528696E7374616E63652C2022564F4943455F494E5055542E424C4F434B454422293B0A202020207D20656C736520696620287374617465203D3D3D2022756E61766169';
wwv_flow_imp.g_varchar2_table(40) := '6C61626C652229207B0A202020202020616E6E6F756E636528696E7374616E63652C20696E7374616E63652E6E6F4D6963726F70686F6E65203F204E4F5F4D4943524F50484F4E455F4B4559203A2022564F4943455F494E5055542E4552524F522E756E';
wwv_flow_imp.g_varchar2_table(41) := '737570706F7274656422293B0A202020207D20656C736520696620287374617465203D3D3D20226C697374656E696E672229207B0A202020202020616E6E6F756E636528696E7374616E63652C2022564F4943455F494E5055542E4C495354454E494E47';
wwv_flow_imp.g_varchar2_table(42) := '22293B0A202020207D20656C7365206966202870726576696F7573203D3D3D20226C697374656E696E672229207B0A202020202020616E6E6F756E636528696E7374616E63652C2022564F4943455F494E5055542E53544F5050454422293B0A20202020';
wwv_flow_imp.g_varchar2_table(43) := '7D0A2020202076617220696E616374697665203D207374617465203D3D3D2022626C6F636B656422207C7C207374617465203D3D3D2022756E617661696C61626C65223B0A20202020696E7374616E63652E627574746F6E2E7365744174747269627574';
wwv_flow_imp.g_varchar2_table(44) := '652822646174612D7374617465222C207374617465293B0A20202020696E7374616E63652E627574746F6E2E7365744174747269627574652822617269612D64697361626C6564222C20537472696E6728696E61637469766529293B0A20202020696620';
wwv_flow_imp.g_varchar2_table(45) := '28737461746520213D3D2070726576696F757329207B0A20202020202077696E646F772E636C65617254696D656F757428696E7374616E63652E666C61736854696D6572293B0A202020202020696E7374616E63652E69636F6E2E636C6173734E616D65';
wwv_flow_imp.g_varchar2_table(46) := '203D207374617465203D3D3D202270726F63657373696E6722203F2050524F43455353494E475F49434F4E203A20696E616374697665203F20494E4143544956455F49434F4E203A2049444C455F49434F4E3B0A20202020202069662028737461746520';
wwv_flow_imp.g_varchar2_table(47) := '3D3D3D20226C697374656E696E672229207B0A20202020202020202F2F20546865206D6963726F70686F6E652074616B65732061206D6F6D656E7420746F20737461727420636170747572696E673B206F6E6C7920666C617368206F6E63652069742069';
wwv_flow_imp.g_varchar2_table(48) := '732E0A2020202020202020696E7374616E63652E666C61736854696D6572203D2077696E646F772E73657454696D656F75742866756E6374696F6E202829207B0A2020202020202020202069662028696E7374616E63652E7374617465203D3D3D20226C';
wwv_flow_imp.g_varchar2_table(49) := '697374656E696E672229207B0A202020202020202020202020696E7374616E63652E69636F6E2E636C6173734E616D65203D2049444C455F49434F4E202B20222022202B205245434F5244494E475F434C41535345532E6A6F696E28222022293B0A2020';
wwv_flow_imp.g_varchar2_table(50) := '20202020202020207D0A20202020202020207D2C205245434F5244494E475F464C4153485F44454C41595F4D53293B0A2020202020207D0A202020207D0A20202020696E7374616E63652E627574746F6E2E736574417474726962757465282261726961';
wwv_flow_imp.g_varchar2_table(51) := '2D70726573736564222C20537472696E67287374617465203D3D3D20226C697374656E696E672229293B0A20207D0A0A202066756E6374696F6E20636F6D6D6F6E5072656669784C656E67746828612C206229207B0A20202020766172206E203D204D61';
wwv_flow_imp.g_varchar2_table(52) := '74682E6D696E28612E6C656E6774682C20622E6C656E677468293B0A202020207661722069203D20303B0A202020207768696C65202869203C206E20262620612E63686172436F64654174286929203D3D3D20622E63686172436F646541742869292920';
wwv_flow_imp.g_varchar2_table(53) := '7B0A202020202020692B2B3B0A202020207D0A2020202072657475726E20693B0A20207D0A0A20202F2F204368616E676573206F6E6C7920746865207461696C206F662074686520546172676574207468617420646966666572732C206B656570696E67';
wwv_flow_imp.g_varchar2_table(54) := '2074686520636172657420616E64207363726F6C6C20706F736974696F6E2E0A202066756E6374696F6E2073657454617267657456616C756528696E7374616E63652C207461726765742C2076616C756529207B0A202020207661722063757272656E74';
wwv_flow_imp.g_varchar2_table(55) := '203D207461726765742E76616C75653B0A202020206966202876616C7565203D3D3D2063757272656E7429207B0A20202020202072657475726E3B0A202020207D0A20202020766172207374617274203D207461726765742E73656C656374696F6E5374';
wwv_flow_imp.g_varchar2_table(56) := '6172743B0A2020202076617220656E64203D207461726765742E73656C656374696F6E456E643B0A20202020766172206174456E64203D207374617274203D3D3D2063757272656E742E6C656E67746820262620656E64203D3D3D2063757272656E742E';
wwv_flow_imp.g_varchar2_table(57) := '6C656E6774683B0A20202020766172207363726F6C6C203D207461726765742E7363726F6C6C546F703B0A2020202076617220707265666978203D20636F6D6D6F6E5072656669784C656E6774682863757272656E742C2076616C7565293B0A20202020';
wwv_flow_imp.g_varchar2_table(58) := '69662028747970656F66207461726765742E73657452616E676554657874203D3D3D202266756E6374696F6E2229207B0A2020202020207461726765742E73657452616E6765546578742876616C75652E736C69636528707265666978292C2070726566';
wwv_flow_imp.g_varchar2_table(59) := '69782C2063757272656E742E6C656E6774682C2022656E6422293B0A20202020202069662028216174456E6429207B0A20202020202020207461726765742E73657453656C656374696F6E52616E6765284D6174682E6D696E2873746172742C2076616C';
wwv_flow_imp.g_varchar2_table(60) := '75652E6C656E677468292C204D6174682E6D696E28656E642C2076616C75652E6C656E67746829293B0A2020202020207D0A202020207D20656C7365207B0A2020202020207461726765742E76616C7565203D2076616C75653B0A202020207D0A202020';
wwv_flow_imp.g_varchar2_table(61) := '207461726765742E7363726F6C6C546F70203D207363726F6C6C3B0A20202020696E7374616E63652E77726974696E67203D20747275653B0A20202020747279207B0A2020202020207461726765742E64697370617463684576656E74286E6577204576';
wwv_flow_imp.g_varchar2_table(62) := '656E742822696E707574222C207B20627562626C65733A2074727565207D29293B0A202020207D2066696E616C6C79207B0A202020202020696E7374616E63652E77726974696E67203D2066616C73653B0A202020207D0A20207D0A0A20202F2F205772';
wwv_flow_imp.g_varchar2_table(63) := '6974657320746865207574746572616E636520696E2070726F677265737320696E746F20746865205461726765742E2054686520626173652074657874206973206669786564207768656E207468650A20202F2F207574746572616E636520626567696E';
wwv_flow_imp.g_varchar2_table(64) := '733A20656D70747920666F7220746865206669727374207574746572616E6365206F662061207265706C6163652D6D6F64652073657373696F6E2E0A202066756E6374696F6E207772697465546F54617267657428696E7374616E63652C207465787429';
wwv_flow_imp.g_varchar2_table(65) := '207B0A2020202076617220746172676574203D20696E7374616E63652E726567696F6E2E717565727953656C6563746F72285441524745545F53454C4543544F52293B0A20202020696620282174617267657429207B0A20202020202072657475726E3B';
wwv_flow_imp.g_varchar2_table(66) := '0A202020207D0A2020202069662028696E7374616E63652E62617365203D3D3D206E756C6C29207B0A2020202020207661722063757272656E74203D207461726765742E76616C75653B0A202020202020696E7374616E63652E62617365203D20696E73';
wwv_flow_imp.g_varchar2_table(67) := '74616E63652E73657474696E67732E726573756C744D6F6465203D3D3D20227265706C616365222026262021696E7374616E63652E6469637461746564203F202222203A2063757272656E743B0A202020207D0A202020207661722062617365203D2069';
wwv_flow_imp.g_varchar2_table(68) := '6E7374616E63652E626173653B0A2020202076617220736570617261746F72203D2074657874202626206261736520262620212F5C73242F2E74657374286261736529203F20222022203A2022223B0A2020202073657454617267657456616C75652869';
wwv_flow_imp.g_varchar2_table(69) := '6E7374616E63652C207461726765742C2062617365202B20736570617261746F72202B2074657874293B0A20207D0A0A20202F2F2054797065777269746572204566666563743A2060676F616C6020697320746865206C6174657374207472616E736372';
wwv_flow_imp.g_varchar2_table(70) := '697074206F6620746865207574746572616E63652C206073686F776E60207768617420697320696E20746865205461726765742E0A202066756E6374696F6E20747970657772697465725469636B28696E7374616E636529207B0A20202020696E737461';
wwv_flow_imp.g_varchar2_table(71) := '6E63652E747970696E6754696D6572203D206E756C6C3B0A2020202076617220676F616C203D20696E7374616E63652E676F616C3B0A20202020766172206B656570203D20636F6D6D6F6E5072656669784C656E67746828696E7374616E63652E73686F';
wwv_flow_imp.g_varchar2_table(72) := '776E2C20676F616C293B0A2020202069662028696E7374616E63652E73686F776E2E6C656E677468203E206B65657029207B0A202020202020696E7374616E63652E73686F776E203D20676F616C2E736C69636528302C206B656570293B0A202020207D';
wwv_flow_imp.g_varchar2_table(73) := '20656C73652069662028696E7374616E63652E73686F776E2E6C656E677468203C20676F616C2E6C656E67746829207B0A202020202020696E7374616E63652E73686F776E203D20676F616C2E736C69636528302C20696E7374616E63652E73686F776E';
wwv_flow_imp.g_varchar2_table(74) := '2E6C656E677468202B2031293B0A202020207D0A202020207772697465546F54617267657428696E7374616E63652C20696E7374616E63652E73686F776E293B0A2020202069662028696E7374616E63652E73686F776E203D3D3D20676F616C29207B0A';
wwv_flow_imp.g_varchar2_table(75) := '20202020202066696E697368547970696E6728696E7374616E6365293B0A202020207D20656C7365207B0A202020202020696E7374616E63652E747970696E6754696D6572203D2077696E646F772E73657454696D656F75742866756E6374696F6E2028';
wwv_flow_imp.g_varchar2_table(76) := '29207B20747970657772697465725469636B28696E7374616E6365293B207D2C20545950455752495445525F44454C41595F4D53293B0A202020207D0A20207D0A0A202066756E6374696F6E2066696E697368547970696E6728696E7374616E63652920';
wwv_flow_imp.g_varchar2_table(77) := '7B0A2020202077696E646F772E636C65617254696D656F757428696E7374616E63652E747970696E6754696D6572293B0A20202020696E7374616E63652E747970696E6754696D6572203D206E756C6C3B0A2020202069662028696E7374616E63652E63';
wwv_flow_imp.g_varchar2_table(78) := '6F6D6D697474656429207B0A202020202020696E7374616E63652E636F6D6D6974746564203D2066616C73653B0A202020202020696E7374616E63652E62617365203D206E756C6C3B0A202020202020696E7374616E63652E676F616C203D2022223B0A';
wwv_flow_imp.g_varchar2_table(79) := '202020202020696E7374616E63652E73686F776E203D2022223B0A202020207D0A2020202069662028696E7374616E63652E7375626D69745768656E547970656429207B0A202020202020696E7374616E63652E7375626D69745768656E547970656420';
wwv_flow_imp.g_varchar2_table(80) := '3D2066616C73653B0A2020202020207375626D697428696E7374616E6365293B0A202020207D0A20207D0A0A20202F2F205075747320776861746576657220686173206E6F74206265656E2074797065642079657420696E746F20746865205461726765';
wwv_flow_imp.g_varchar2_table(81) := '74206174206F6E63652E0A202066756E6374696F6E20666C757368547970696E6728696E7374616E636529207B0A2020202069662028696E7374616E63652E73686F776E20213D3D20696E7374616E63652E676F616C29207B0A202020202020696E7374';
wwv_flow_imp.g_varchar2_table(82) := '616E63652E73686F776E203D20696E7374616E63652E676F616C3B0A2020202020207772697465546F54617267657428696E7374616E63652C20696E7374616E63652E676F616C293B0A202020207D0A2020202066696E697368547970696E6728696E73';
wwv_flow_imp.g_varchar2_table(83) := '74616E6365293B0A20207D0A0A20202F2F2060636F7272656374696F6E6020697320746865204C6F63616C204D6F64656C20456E67696E6527732066696E616C20706173733A206974207265706C616365732074686520696E746572696D207465787420';
wwv_flow_imp.g_varchar2_table(84) := '6174206F6E63652C206E657665722074797065642E0A202066756E6374696F6E2070726573656E7428696E7374616E63652C20746578742C20697346696E616C2C20636F7272656374696F6E29207B0A202020202F2F2054686520757365722065646974';
wwv_flow_imp.g_varchar2_table(85) := '65642074686520546172676574207768696C6520746865204C6F63616C204D6F64656C20456E67696E652077617320646963746174696E673A20746865697220656469742077696E732E0A2020202069662028696E7374616E63652E6564697465642920';
wwv_flow_imp.g_varchar2_table(86) := '7B0A20202020202072657475726E3B0A202020207D0A202020202F2F20416E20696E746572696D20726573756C7420746861742072657669736573207768617420697320616C72656164792073686F776E20776169747320666F72207468652066696E61';
wwv_flow_imp.g_varchar2_table(87) := '6C20726573756C742C0A202020202F2F20736F2074657874206F6E2073637265656E206973206E657665722074616B656E206261636B2E0A202020206966202821697346696E616C20262620696E7374616E63652E696E746572696D53686F776E202626';
wwv_flow_imp.g_varchar2_table(88) := '20746578742E696E6465784F6628696E7374616E63652E696E746572696D53686F776E2920213D3D203029207B0A20202020202072657475726E3B0A202020207D0A20202020696E7374616E63652E696E746572696D53686F776E203D20697346696E61';
wwv_flow_imp.g_varchar2_table(89) := '6C203F202222203A20746578743B0A2020202069662028636F7272656374696F6E20262620696E7374616E63652E73657474696E67732E7479706577726974657229207B0A20202020202077696E646F772E636C65617254696D656F757428696E737461';
wwv_flow_imp.g_varchar2_table(90) := '6E63652E747970696E6754696D6572293B0A202020202020696E7374616E63652E747970696E6754696D6572203D206E756C6C3B0A202020202020696E7374616E63652E676F616C203D20696E7374616E63652E73686F776E203D20746578743B0A2020';
wwv_flow_imp.g_varchar2_table(91) := '202020207772697465546F54617267657428696E7374616E63652C2074657874293B0A20202020202072657475726E3B0A202020207D0A202020206966202821696E7374616E63652E73657474696E67732E7479706577726974657229207B0A20202020';
wwv_flow_imp.g_varchar2_table(92) := '20207772697465546F54617267657428696E7374616E63652C2074657874293B0A20202020202072657475726E3B0A202020207D0A2020202069662028696E7374616E63652E636F6D6D697474656429207B0A202020202020666C757368547970696E67';
wwv_flow_imp.g_varchar2_table(93) := '28696E7374616E6365293B0A202020207D0A20202020696E7374616E63652E676F616C203D20746578743B0A202020206966202821696E7374616E63652E747970696E6754696D657229207B0A202020202020696E7374616E63652E747970696E675469';
wwv_flow_imp.g_varchar2_table(94) := '6D6572203D2077696E646F772E73657454696D656F75742866756E6374696F6E202829207B20747970657772697465725469636B28696E7374616E6365293B207D2C20545950455752495445525F44454C41595F4D53293B0A202020207D0A20207D0A0A';
wwv_flow_imp.g_varchar2_table(95) := '20202F2F205468652075736572206564697465642074686520546172676574207768696C65207465787420776173206265696E672074797065643A20616464207468652072657374206166746572207468656972206564697420616E642073746F702E0A';
wwv_flow_imp.g_varchar2_table(96) := '202066756E6374696F6E2063616E63656C547970696E6728696E7374616E636529207B0A2020202076617220746172676574203D20696E7374616E63652E726567696F6E2E717565727953656C6563746F72285441524745545F53454C4543544F52293B';
wwv_flow_imp.g_varchar2_table(97) := '0A202020207661722072657374203D20696E7374616E63652E676F616C2E736C69636528636F6D6D6F6E5072656669784C656E67746828696E7374616E63652E73686F776E2C20696E7374616E63652E676F616C29293B0A202020206966202874617267';
wwv_flow_imp.g_varchar2_table(98) := '6574202626207265737429207B0A2020202020207661722063757272656E74203D207461726765742E76616C75653B0A20202020202073657454617267657456616C756528696E7374616E63652C207461726765742C202863757272656E742026262021';
wwv_flow_imp.g_varchar2_table(99) := '2F5C73242F2E746573742863757272656E7429203F2063757272656E74202B20222022203A2063757272656E7429202B2072657374293B0A202020207D0A20202020696E7374616E63652E73686F776E203D20696E7374616E63652E676F616C203D2022';
wwv_flow_imp.g_varchar2_table(100) := '223B0A20202020696E7374616E63652E636F6D6D6974746564203D20747275653B0A2020202066696E697368547970696E6728696E7374616E6365293B0A20202020696E7374616E63652E62617365203D206E756C6C3B0A20207D0A0A20207661722045';
wwv_flow_imp.g_varchar2_table(101) := '52524F525F434F444553203D207B0A20202020226E6F742D616C6C6F776564223A20227065726D697373696F6E2D64656E696564222C0A2020202022736572766963652D6E6F742D616C6C6F776564223A20227065726D697373696F6E2D64656E696564';
wwv_flow_imp.g_varchar2_table(102) := '222C0A20202020226E6574776F726B223A20226E6574776F726B222C0A20202020226E6F2D737065656368223A20226E6F2D737065656368222C0A2020202022617564696F2D63617074757265223A20226E6F2D6D6963726F70686F6E65222C0A202020';
wwv_flow_imp.g_varchar2_table(103) := '20226C616E67756167652D6E6F742D737570706F72746564223A2022756E737570706F72746564222C0A20207D3B0A0A202066756E6374696F6E207265706F72744572726F7228696E7374616E63652C20636F646529207B0A202020206669726528696E';
wwv_flow_imp.g_varchar2_table(104) := '7374616E63652C2022766F6963652D6572726F72222C207B20636F64653A20636F64652C206D6573736167653A206D6573736167652822564F4943455F494E5055542E4552524F522E22202B20636F646529207D293B0A20207D0A0A202066756E637469';
wwv_flow_imp.g_varchar2_table(105) := '6F6E2073686F774572726F724D657373616765286B657929207B0A2020202076617220617065784D657373616765203D2077696E646F772E617065782E6D6573736167653B0A2020202069662028617065784D65737361676520262620617065784D6573';
wwv_flow_imp.g_varchar2_table(106) := '736167652E73686F774572726F727329207B0A20202020202069662028617065784D6573736167652E636C6561724572726F727329207B0A2020202020202020617065784D6573736167652E636C6561724572726F727328293B0A2020202020207D0A20';
wwv_flow_imp.g_varchar2_table(107) := '2020202020617065784D6573736167652E73686F774572726F7273285B7B0A2020202020202020747970653A20226572726F72222C0A20202020202020206C6F636174696F6E3A202270616765222C0A20202020202020206D6573736167653A206D6573';
wwv_flow_imp.g_varchar2_table(108) := '73616765286B6579292C0A2020202020202020756E736166653A2066616C73652C0A2020202020207D5D293B0A202020207D0A20207D0A0A202066756E6374696F6E20736574546F6F6C74697028696E7374616E63652C206B657929207B0A2020202069';
wwv_flow_imp.g_varchar2_table(109) := '6E7374616E63652E627574746F6E2E7469746C65203D206B6579203F206D657373616765286B657929203A2064656661756C74546F6F6C74697028696E7374616E63652E73657474696E6773293B0A20207D0A0A202066756E6374696F6E207765625370';
wwv_flow_imp.g_varchar2_table(110) := '65656368436F6E7374727563746F722829207B0A2020202072657475726E2077696E646F772E5370656563685265636F676E6974696F6E207C7C2077696E646F772E7765626B69745370656563685265636F676E6974696F6E3B0A20207D0A0A20202F2F';
wwv_flow_imp.g_varchar2_table(111) := '205765622053706565636820456E67696E653A20617564696F2D746F2D74657874206F6E6C793B207468652072756E74696D65206F776E732073746174652C206576656E747320616E64205461726765742E0A202066756E6374696F6E20637265617465';
wwv_flow_imp.g_varchar2_table(112) := '576562537065656368456E67696E652873657474696E67732C2068616E646C65727329207B0A20202020766172205265636F676E6974696F6E203D20776562537065656368436F6E7374727563746F7228293B0A20202020766172207265636F676E6974';
wwv_flow_imp.g_varchar2_table(113) := '696F6E203D206E6577205265636F676E6974696F6E28293B0A202020207265636F676E6974696F6E2E6C616E67203D2073657373696F6E4C616E677561676528293B0A202020207265636F676E6974696F6E2E636F6E74696E756F7573203D2074727565';
wwv_flow_imp.g_varchar2_table(114) := '3B0A202020207265636F676E6974696F6E2E696E746572696D526573756C7473203D2073657474696E67732E696E746572696D526573756C74733B0A202020207265636F676E6974696F6E2E6F6E7374617274203D2068616E646C6572732E6F6E537461';
wwv_flow_imp.g_varchar2_table(115) := '72743B0A202020207265636F676E6974696F6E2E6F6E656E64203D2068616E646C6572732E6F6E456E643B0A202020207265636F676E6974696F6E2E6F6E6572726F72203D2066756E6374696F6E20286576656E7429207B0A2020202020207661722063';
wwv_flow_imp.g_varchar2_table(116) := '6F6465203D204552524F525F434F4445535B6576656E742E6572726F725D3B0A20202020202069662028636F646529207B0A202020202020202068616E646C6572732E6F6E4572726F7228636F6465293B0A2020202020207D0A202020207D3B0A202020';
wwv_flow_imp.g_varchar2_table(117) := '207265636F676E6974696F6E2E6F6E726573756C74203D2066756E6374696F6E20286576656E7429207B0A202020202020666F7220287661722069203D206576656E742E726573756C74496E6465783B2069203C206576656E742E726573756C74732E6C';
wwv_flow_imp.g_varchar2_table(118) := '656E6774683B20692B2B29207B0A202020202020202076617220726573756C74203D206576656E742E726573756C74735B695D3B0A202020202020202069662028726573756C742E697346696E616C207C7C2073657474696E67732E696E746572696D52';
wwv_flow_imp.g_varchar2_table(119) := '6573756C747329207B0A2020202020202020202068616E646C6572732E6F6E5465787428726573756C745B305D2E7472616E7363726970742E7472696D28292C20726573756C742E697346696E616C293B0A20202020202020207D0A2020202020207D0A';
wwv_flow_imp.g_varchar2_table(120) := '202020207D3B0A2020202072657475726E207B0A20202020202073746172743A2066756E6374696F6E202829207B207265636F676E6974696F6E2E737461727428293B207D2C0A20202020202073746F703A2066756E6374696F6E202829207B20726563';
wwv_flow_imp.g_varchar2_table(121) := '6F676E6974696F6E2E73746F7028293B207D2C0A202020207D3B0A20207D0A0A20202F2F204C6F63616C204D6F64656C20456E67696E653A207265636F72647320746865206D6963726F70686F6E652C207468656E207472616E73637269626573207769';
wwv_flow_imp.g_varchar2_table(122) := '7468205768697370657220696E20612057656220576F726B65722E0A2020766172205441524745545F52415445203D2031363030303B0A2020766172205350454543485F4C4556454C203D20302E30323B0A2020766172204E4F5F5350454543485F5345';
wwv_flow_imp.g_varchar2_table(123) := '434F4E4453203D20353B0A2020766172204D41585F5345434F4E4453203D2036303B0A0A20202F2F20496E746572696D20526573756C74733A2061207365676D656E742074686174207265616368657320697473206D6178696D756D206C656E67746820';
wwv_flow_imp.g_varchar2_table(124) := '6973206375742061742074686520717569657465737420706F696E74206F662074686973206D616E79206C617374207365636F6E64732E0A202076617220464F524345445F4355545F57494E444F575F5345434F4E4453203D20333B0A0A20202F2F2052';
wwv_flow_imp.g_varchar2_table(125) := '756E7320696E736964652074686520576F726B65723A206C6F616473205472616E73666F726D6572732E6A732C207265706F72747320646F776E6C6F61642070726F67726573732C207472616E736372696265732E0A202076617220574F524B45525F53';
wwv_flow_imp.g_varchar2_table(126) := '4F55524345203D205B0A20202020226C6574207472616E736372696265723B222C0A202020202273656C662E6F6E6D657373616765203D206173796E6320286576656E7429203D3E207B222C0A20202020222020636F6E7374206D203D206576656E742E';
wwv_flow_imp.g_varchar2_table(127) := '646174613B222C0A20202020222020747279207B222C0A202020202220202020696620286D2E74797065203D3D3D20276C6F61642729207B222C0A2020202022202020202020636F6E7374206C6962203D20617761697420696D706F7274286D2E6C6962';
wwv_flow_imp.g_varchar2_table(128) := '7261727955726C202B20277472616E73666F726D6572732E6D696E2E6A7327293B222C0A2020202022202020202020636F6E73742066696C6573203D207B7D3B222C0A20202020222020202020207472616E73637269626572203D206177616974206C69';
wwv_flow_imp.g_varchar2_table(129) := '622E706970656C696E6528276175746F6D617469632D7370656563682D7265636F676E6974696F6E272C206D2E6D6F64656C49642C207B222C0A202020202220202020202020206465766963653A206D2E6465766963652C222C0A202020202220202020';
wwv_flow_imp.g_varchar2_table(130) := '2020202064747970653A206D2E646576696365203D3D3D202777656267707527203F207B20656E636F6465725F6D6F64656C3A202766703332272C206465636F6465725F6D6F64656C5F6D65726765643A2027713427207D203A20277138272C222C0A20';
wwv_flow_imp.g_varchar2_table(131) := '20202022202020202020202070726F67726573735F63616C6C6261636B3A20287029203D3E207B222C0A20202020222020202020202020202069662028702E73746174757320213D3D202770726F677265737327207C7C2021702E746F74616C29207265';
wwv_flow_imp.g_varchar2_table(132) := '7475726E3B222C0A20202020222020202020202020202066696C65735B702E66696C655D203D207B206C6F616465643A20702E6C6F616465642C20746F74616C3A20702E746F74616C207D3B222C0A2020202022202020202020202020206C6574206C6F';
wwv_flow_imp.g_varchar2_table(133) := '61646564203D20302C20746F74616C203D20303B222C0A202020202220202020202020202020666F722028636F6E73742066206F66204F626A6563742E76616C7565732866696C65732929207B206C6F61646564202B3D20662E6C6F616465643B20746F';
wwv_flow_imp.g_varchar2_table(134) := '74616C202B3D20662E746F74616C3B207D222C0A20202020222020202020202020202073656C662E706F73744D657373616765287B20747970653A202770726F6772657373272C2070657263656E743A204D6174682E6D696E283130302C204D6174682E';
wwv_flow_imp.g_varchar2_table(135) := '726F756E6428313030202A206C6F61646564202F20746F74616C2929207D293B222C0A202020202220202020202020207D2C222C0A20202020222020202020207D293B222C0A202020202220202020202073656C662E706F73744D657373616765287B20';
wwv_flow_imp.g_varchar2_table(136) := '747970653A2027726561647927207D293B222C0A2020202022202020207D20656C736520696620286D2E74797065203D3D3D20277472616E7363726962652729207B222C0A2020202022202020202020636F6E7374206F7074696F6E73203D207B206368';
wwv_flow_imp.g_varchar2_table(137) := '756E6B5F6C656E6774685F733A2033302C207374726964655F6C656E6774685F733A20352C206E6F5F7265706561745F6E6772616D5F73697A653A2033207D3B222C0A2020202022202020202020696620286D2E6C616E677561676529207B206F707469';
wwv_flow_imp.g_varchar2_table(138) := '6F6E732E6C616E6775616765203D206D2E6C616E67756167653B206F7074696F6E732E7461736B203D20277472616E736372696265273B207D222C0A2020202022202020202020636F6E7374206F7574203D206177616974207472616E73637269626572';
wwv_flow_imp.g_varchar2_table(139) := '286D2E617564696F2C206F7074696F6E73293B222C0A202020202220202020202073656C662E706F73744D657373616765287B20747970653A2027726573756C74272C20746578743A206F75742E74657874207D293B222C0A2020202022202020207D22';
wwv_flow_imp.g_varchar2_table(140) := '2C0A202020202220207D20636174636820286529207B222C0A20202020222020202073656C662E706F73744D657373616765287B20747970653A20276572726F72272C206D6573736167653A20537472696E67286529207D293B222C0A20202020222020';
wwv_flow_imp.g_varchar2_table(141) := '7D222C0A20202020227D3B222C0A20205D2E6A6F696E28225C6E22293B0A0A20202F2F204C6F61646564206D6F64656C732C2073686172656420627920657665727920696E7374616E636520746861742061736B7320666F72207468652073616D65206C';
wwv_flow_imp.g_varchar2_table(142) := '69627261727920616E64206D6F64656C2E0A2020766172206D6F64656C73203D207B7D3B0A0A202066756E6374696F6E206C6F61644D6F64656C2873657474696E67732C206F6E50726F677265737329207B0A20202020766172206B6579203D20736574';
wwv_flow_imp.g_varchar2_table(143) := '74696E67732E6C69627261727955726C202B20227C22202B2073657474696E67732E6D6F64656C49643B0A2020202076617220656E747279203D206D6F64656C735B6B65795D3B0A202020206966202821656E74727929207B0A20202020202076617220';
wwv_flow_imp.g_varchar2_table(144) := '75726C203D2055524C2E6372656174654F626A65637455524C286E657720426C6F62285B574F524B45525F534F555243455D2C207B20747970653A2022746578742F6A61766173637269707422207D29293B0A20202020202076617220776F726B657220';
wwv_flow_imp.g_varchar2_table(145) := '3D206E65772077696E646F772E576F726B65722875726C2C207B20747970653A20226D6F64756C6522207D293B0A202020202020656E747279203D206D6F64656C735B6B65795D203D207B20776F726B65723A20776F726B65722C206C697374656E6572';
wwv_flow_imp.g_varchar2_table(146) := '733A205B5D207D3B0A2020202020207661722063757272656E74203D20656E7472793B0A20202020202076617220646576696365203D2077696E646F772E6E6176696761746F722E677075203F202277656267707522203A20227761736D223B0A202020';
wwv_flow_imp.g_varchar2_table(147) := '202020766172206C6F6164203D2066756E6374696F6E202829207B0A2020202020202020776F726B65722E706F73744D657373616765287B20747970653A20226C6F6164222C206C69627261727955726C3A2073657474696E67732E6C69627261727955';
wwv_flow_imp.g_varchar2_table(148) := '726C2C206D6F64656C49643A2073657474696E67732E6D6F64656C49642C206465766963653A20646576696365207D293B0A2020202020207D3B0A202020202020656E7472792E7265616479203D206E65772050726F6D6973652866756E6374696F6E20';
wwv_flow_imp.g_varchar2_table(149) := '287265736F6C76652C2072656A65637429207B0A2020202020202020776F726B65722E6F6E6D657373616765203D2066756E6374696F6E20286576656E7429207B0A20202020202020202020766172206D203D206576656E742E646174613B0A20202020';
wwv_flow_imp.g_varchar2_table(150) := '202020202020696620286D2E74797065203D3D3D202270726F67726573732229207B0A20202020202020202020202063757272656E742E6C697374656E6572732E666F72456163682866756E6374696F6E20286C697374656E657229207B206C69737465';
wwv_flow_imp.g_varchar2_table(151) := '6E6572286D2E70657263656E74293B207D293B0A202020202020202020207D20656C736520696620286D2E74797065203D3D3D202272656164792229207B0A2020202020202020202020207265736F6C766528293B0A202020202020202020207D20656C';
wwv_flow_imp.g_varchar2_table(152) := '736520696620286D2E74797065203D3D3D20226572726F722220262620646576696365203D3D3D20227765626770752229207B0A2020202020202020202020202F2F205765624750552063616E2062652070726573656E7420796574206661696C20746F';
wwv_flow_imp.g_varchar2_table(153) := '206C6F616420746865206D6F64656C3A20747279206F6E6365206D6F7265206F6E20746865204350552E0A20202020202020202020202077696E646F772E636F6E736F6C652E7761726E2822566F69636520496E7075743A20576562475055206661696C';
wwv_flow_imp.g_varchar2_table(154) := '6564202822202B206D2E6D657373616765202B2022292C2066616C6C696E67206261636B20746F205741534D22293B0A202020202020202020202020646576696365203D20227761736D223B0A2020202020202020202020206C6F616428293B0A202020';
wwv_flow_imp.g_varchar2_table(155) := '202020202020207D20656C736520696620286D2E74797065203D3D3D20226572726F722229207B0A20202020202020202020202072656A656374286E6577204572726F72286D2E6D65737361676529293B0A202020202020202020207D0A202020202020';
wwv_flow_imp.g_varchar2_table(156) := '20207D3B0A2020202020202020776F726B65722E6F6E6572726F72203D2072656A6563743B0A2020202020207D292E63617463682866756E6374696F6E20286572726F7229207B0A202020202020202064656C657465206D6F64656C735B6B65795D3B0A';
wwv_flow_imp.g_varchar2_table(157) := '2020202020202020776F726B65722E7465726D696E61746528293B0A20202020202020207468726F77206572726F723B0A2020202020207D293B0A2020202020206C6F616428293B0A202020207D0A20202020656E7472792E6C697374656E6572732E70';
wwv_flow_imp.g_varchar2_table(158) := '757368286F6E50726F6772657373293B0A2020202072657475726E20656E7472792E72656164792E7468656E2866756E6374696F6E202829207B2072657475726E20656E7472793B207D293B0A20207D0A0A202066756E6374696F6E206C6F63616C4D6F';
wwv_flow_imp.g_varchar2_table(159) := '64656C417661696C61626C652829207B0A2020202072657475726E2021212877696E646F772E576F726B65722026262077696E646F772E417564696F436F6E746578742026262077696E646F772E6E6176696761746F722E6D6564696144657669636573';
wwv_flow_imp.g_varchar2_table(160) := '2026260A20202020202077696E646F772E6E6176696761746F722E6D65646961446576696365732E676574557365724D65646961293B0A20207D0A0A202066756E6374696F6E20726573616D706C652873616D706C65732C2066726F6D2C20746F29207B';
wwv_flow_imp.g_varchar2_table(161) := '0A202020206966202866726F6D203D3D3D20746F29207B0A20202020202072657475726E2073616D706C65733B0A202020207D0A20202020766172206F7574203D206E657720466C6F617433324172726179284D6174682E666C6F6F722873616D706C65';
wwv_flow_imp.g_varchar2_table(162) := '732E6C656E677468202A20746F202F2066726F6D29293B0A20202020666F7220287661722069203D20303B2069203C206F75742E6C656E6774683B20692B2B29207B0A20202020202076617220706F736974696F6E203D2069202A2066726F6D202F2074';
wwv_flow_imp.g_varchar2_table(163) := '6F3B0A20202020202076617220696E646578203D204D6174682E666C6F6F7228706F736974696F6E293B0A202020202020766172206E657874203D204D6174682E6D696E28696E646578202B20312C2073616D706C65732E6C656E677468202D2031293B';
wwv_flow_imp.g_varchar2_table(164) := '0A202020202020766172206672616374696F6E203D20706F736974696F6E202D20696E6465783B0A2020202020206F75745B695D203D2073616D706C65735B696E6465785D202A202831202D206672616374696F6E29202B2073616D706C65735B6E6578';
wwv_flow_imp.g_varchar2_table(165) := '745D202A206672616374696F6E3B0A202020207D0A2020202072657475726E206F75743B0A20207D0A0A202066756E6374696F6E20636F6E636174286672616D65732C2066726F6D2C20746F29207B0A20202020766172206C656E677468203D20303B0A';
wwv_flow_imp.g_varchar2_table(166) := '20202020666F7220287661722069203D2066726F6D3B2069203C20746F3B20692B2B29207B0A2020202020206C656E677468202B3D206672616D65735B695D2E646174612E6C656E6774683B0A202020207D0A2020202076617220616C6C203D206E6577';
wwv_flow_imp.g_varchar2_table(167) := '20466C6F617433324172726179286C656E677468293B0A20202020766172206F6666736574203D20303B0A20202020666F722028766172206A203D2066726F6D3B206A203C20746F3B206A2B2B29207B0A202020202020616C6C2E736574286672616D65';
wwv_flow_imp.g_varchar2_table(168) := '735B6A5D2E646174612C206F6666736574293B0A2020202020206F6666736574202B3D206672616D65735B6A5D2E646174612E6C656E6774683B0A202020207D0A2020202072657475726E20616C6C3B0A20207D0A0A202066756E6374696F6E20637265';
wwv_flow_imp.g_varchar2_table(169) := '6174654C6F63616C4D6F64656C456E67696E652873657474696E67732C2068616E646C65727329207B0A202020207661722073747265616D203D206E756C6C3B0A2020202076617220636F6E74657874203D206E756C6C3B0A2020202076617220726174';
wwv_flow_imp.g_varchar2_table(170) := '65203D20303B0A20202020766172206672616D6573203D205B5D3B0A2020202076617220746F74616C203D20303B0A20202020766172207175696574203D20303B0A20202020766172206865617264203D2066616C73653B0A2020202076617220726563';
wwv_flow_imp.g_varchar2_table(171) := '6F7264696E67203D2066616C73653B0A202020207661722066696E6973686564203D2066616C73653B0A20202020766172206D6F64656C203D206E756C6C3B0A0A202020202F2F205468652063757272656E74207365676D656E74206973206672616D65';
wwv_flow_imp.g_varchar2_table(172) := '735B7365676D656E7446726F6D2E2E5D3B207365676D656E747320617265206F6E6C7920637574207768656E20496E746572696D20526573756C7473206973206F6E2E0A20202020766172207365676D656E7446726F6D203D20303B0A20202020766172';
wwv_flow_imp.g_varchar2_table(173) := '207365676D656E7453616D706C6573203D20303B0A20202020766172207365676D656E745175696574203D20303B0A20202020766172207365676D656E744865617264203D2066616C73653B0A0A202020202F2F205365676D656E747320617265207472';
wwv_flow_imp.g_varchar2_table(174) := '616E73637269626564206F6E6520617420612074696D652C20696E206F726465722C207468656E207468652077686F6C65207265636F7264696E67206F6E63652E0A20202020766172207175657565203D205B5D3B0A2020202076617220696E466C6967';
wwv_flow_imp.g_varchar2_table(175) := '6874203D206E756C6C3B0A2020202076617220637574436F756E74203D20303B0A20202020766172207465787473203D205B5D3B0A202020207661722073746F70706564203D2066616C73653B0A202020207661722066696E616C517565756564203D20';
wwv_flow_imp.g_varchar2_table(176) := '66616C73653B0A0A2020202066756E6374696F6E2072656C65617365417564696F2829207B0A2020202020206966202873747265616D29207B0A202020202020202073747265616D2E676574547261636B7328292E666F72456163682866756E6374696F';
wwv_flow_imp.g_varchar2_table(177) := '6E2028747261636B29207B20747261636B2E73746F7028293B207D293B0A202020202020202073747265616D203D206E756C6C3B0A2020202020207D0A20202020202069662028636F6E7465787429207B0A2020202020202020636F6E746578742E636C';
wwv_flow_imp.g_varchar2_table(178) := '6F736528293B0A2020202020202020636F6E74657874203D206E756C6C3B0A2020202020207D0A202020207D0A0A2020202066756E6374696F6E20656E64286166746572526573756C7429207B0A2020202020206966202866696E697368656429207B0A';
wwv_flow_imp.g_varchar2_table(179) := '202020202020202072657475726E3B0A2020202020207D0A20202020202066696E6973686564203D20747275653B0A2020202020207265636F7264696E67203D2066616C73653B0A20202020202072656C65617365417564696F28293B0A202020202020';
wwv_flow_imp.g_varchar2_table(180) := '68616E646C6572732E6F6E456E64286166746572526573756C74293B0A202020207D0A0A2020202066756E6374696F6E206661696C28636F646529207B0A202020202020696620282166696E697368656429207B0A202020202020202068616E646C6572';
wwv_flow_imp.g_varchar2_table(181) := '732E6F6E4572726F7228636F6465293B0A2020202020202020656E6428293B0A2020202020207D0A202020207D0A0A2020202066756E6374696F6E2073656E642829207B0A20202020202069662028696E466C69676874207C7C202171756575652E6C65';
wwv_flow_imp.g_varchar2_table(182) := '6E677468207C7C2066696E697368656429207B0A202020202020202072657475726E3B0A2020202020207D0A202020202020696E466C69676874203D2071756575652E736869667428293B0A2020202020206D6F64656C2E776F726B65722E706F73744D';
wwv_flow_imp.g_varchar2_table(183) := '657373616765280A20202020202020207B20747970653A20227472616E736372696265222C20617564696F3A20696E466C696768742E73616D706C65732C206C616E67756167653A202F5C2E656E242F692E746573742873657474696E67732E6D6F6465';
wwv_flow_imp.g_varchar2_table(184) := '6C496429203F20756E646566696E6564203A2073657373696F6E4C616E677561676528292E73706C697428222D22295B305D207D2C0A20202020202020205B696E466C696768742E73616D706C65732E6275666665725D0A202020202020293B0A202020';
wwv_flow_imp.g_varchar2_table(185) := '207D0A0A202020202F2F20416674657220746865206C617374207365676D656E743A20746865206F6E65207365676D656E742069732074686520726573756C742C206F72207468652077686F6C65207265636F7264696E67206973207472616E73637269';
wwv_flow_imp.g_varchar2_table(186) := '626564206F6E6365206D6F72652E0A2020202066756E6374696F6E20636F6D706C6574652829207B0A202020202020696620282173746F70706564207C7C20696E466C69676874207C7C2071756575652E6C656E677468207C7C2066696E616C51756575';
wwv_flow_imp.g_varchar2_table(187) := '6564207C7C2066696E697368656429207B0A202020202020202072657475726E3B0A2020202020207D0A202020202020696620282174657874732E6C656E67746829207B0A20202020202020206661696C28226E6F2D73706565636822293B0A20202020';
wwv_flow_imp.g_varchar2_table(188) := '20207D20656C73652069662028637574436F756E74203D3D3D203129207B0A202020202020202068616E646C6572732E6F6E546578742874657874735B305D2C2074727565293B0A2020202020202020656E642874727565293B0A2020202020207D2065';
wwv_flow_imp.g_varchar2_table(189) := '6C7365207B0A202020202020202066696E616C517565756564203D20747275653B0A202020202020202071756575652E70757368287B2073616D706C65733A20726573616D706C6528636F6E636174286672616D65732C20302C206672616D65732E6C65';
wwv_flow_imp.g_varchar2_table(190) := '6E677468292C20726174652C205441524745545F52415445292C20697346696E616C3A2074727565207D293B0A202020202020202073656E6428293B0A2020202020207D0A202020207D0A0A2020202066756E6374696F6E207265636569766564286576';
wwv_flow_imp.g_varchar2_table(191) := '656E7429207B0A202020202020766172206D203D206576656E742E646174613B0A2020202020206966202866696E6973686564207C7C2021696E466C6967687429207B0A202020202020202072657475726E3B0A2020202020207D0A2020202020206966';
wwv_flow_imp.g_varchar2_table(192) := '20286D2E74797065203D3D3D20226572726F722229207B0A20202020202020206661696C28226D6F64656C2D756E617661696C61626C6522293B0A202020202020202072657475726E3B0A2020202020207D0A202020202020696620286D2E7479706520';
wwv_flow_imp.g_varchar2_table(193) := '213D3D2022726573756C742229207B0A202020202020202072657475726E3B0A2020202020207D0A2020202020207661722072657175657374203D20696E466C696768743B0A202020202020696E466C69676874203D206E756C6C3B0A20202020202076';
wwv_flow_imp.g_varchar2_table(194) := '61722074657874203D20286D2E74657874207C7C202222292E7472696D28293B0A20202020202069662028726571756573742E697346696E616C29207B0A202020202020202068616E646C6572732E6F6E546578742874657874207C7C2074657874732E';
wwv_flow_imp.g_varchar2_table(195) := '6A6F696E28222022292C20747275652C2074727565293B0A2020202020202020656E642874727565293B0A202020202020202072657475726E3B0A2020202020207D0A202020202020696620287465787429207B0A202020202020202074657874732E70';
wwv_flow_imp.g_varchar2_table(196) := '7573682874657874293B0A2020202020202020696620282173746F70706564207C7C20637574436F756E74203E203129207B0A2020202020202020202068616E646C6572732E6F6E546578742874657874732E6A6F696E28222022292C2066616C736529';
wwv_flow_imp.g_varchar2_table(197) := '3B0A20202020202020207D0A2020202020207D0A20202020202073656E6428293B0A202020202020636F6D706C65746528293B0A202020207D0A0A2020202066756E6374696F6E2063757428746F29207B0A2020202020202F2F2041207365676D656E74';
wwv_flow_imp.g_varchar2_table(198) := '20696E207768696368206E6F2073706565636820776173206865617264206973206E657665722073656E743A205768697370657220696E76656E7473207465787420666F722073696C656E63652E0A202020202020696620287365676D656E7448656172';
wwv_flow_imp.g_varchar2_table(199) := '6429207B0A202020202020202071756575652E70757368287B2073616D706C65733A20726573616D706C6528636F6E636174286672616D65732C207365676D656E7446726F6D2C20746F292C20726174652C205441524745545F5241544529207D293B0A';
wwv_flow_imp.g_varchar2_table(200) := '2020202020202020637574436F756E742B2B3B0A2020202020207D0A2020202020207365676D656E7446726F6D203D20746F3B0A2020202020207365676D656E7453616D706C6573203D20303B0A2020202020207365676D656E745175696574203D2030';
wwv_flow_imp.g_varchar2_table(201) := '3B0A2020202020207365676D656E744865617264203D2066616C73653B0A202020202020666F7220287661722069203D20746F3B2069203C206672616D65732E6C656E6774683B20692B2B29207B0A20202020202020206D656173757265286672616D65';
wwv_flow_imp.g_varchar2_table(202) := '735B695D293B0A2020202020207D0A20202020202073656E6428293B0A202020207D0A0A2020202066756E6374696F6E206D656173757265286672616D6529207B0A2020202020207365676D656E7453616D706C6573202B3D206672616D652E64617461';
wwv_flow_imp.g_varchar2_table(203) := '2E6C656E6774683B0A202020202020696620286672616D652E6C6576656C203E205350454543485F4C4556454C29207B0A20202020202020207365676D656E744865617264203D20747275653B0A20202020202020207365676D656E745175696574203D';
wwv_flow_imp.g_varchar2_table(204) := '20303B0A2020202020207D20656C7365207B0A20202020202020207365676D656E745175696574202B3D206672616D652E646174612E6C656E6774683B0A2020202020207D0A202020207D0A0A202020202F2F2054686520717569657465737420667261';
wwv_flow_imp.g_varchar2_table(205) := '6D65206F6620746865206C61737420666577207365636F6E6473206F6620746865207365676D656E743A20746865206265737420706C61636520746F20637574206D69642D7370656563682E0A2020202066756E6374696F6E2071756965746573744672';
wwv_flow_imp.g_varchar2_table(206) := '616D652829207B0A2020202020207661722062657374203D206672616D65732E6C656E677468202D20313B0A20202020202076617220636F7665726564203D20303B0A202020202020666F7220287661722069203D206672616D65732E6C656E67746820';
wwv_flow_imp.g_varchar2_table(207) := '2D20313B2069203E3D207365676D656E7446726F6D20262620636F7665726564203C20464F524345445F4355545F57494E444F575F5345434F4E4453202A20726174653B20692D2D29207B0A2020202020202020636F7665726564202B3D206672616D65';
wwv_flow_imp.g_varchar2_table(208) := '735B695D2E646174612E6C656E6774683B0A2020202020202020696620286672616D65735B695D2E6C6576656C203C206672616D65735B626573745D2E6C6576656C29207B0A2020202020202020202062657374203D20693B0A20202020202020207D0A';
wwv_flow_imp.g_varchar2_table(209) := '2020202020207D0A20202020202072657475726E20626573743B0A202020207D0A0A2020202066756E6374696F6E207365676D656E7449664475652829207B0A202020202020696620287365676D656E744865617264202626207365676D656E74517569';
wwv_flow_imp.g_varchar2_table(210) := '6574203E3D2073657474696E67732E7365676D656E745061757365202A2072617465202626207365676D656E7453616D706C6573203E3D2073657474696E67732E6D696E5365676D656E744C656E677468202A207261746529207B0A2020202020202020';
wwv_flow_imp.g_varchar2_table(211) := '637574286672616D65732E6C656E677468293B0A2020202020207D20656C736520696620287365676D656E7453616D706C6573203E3D2073657474696E67732E6D61785365676D656E744C656E677468202A207261746529207B0A202020202020202063';
wwv_flow_imp.g_varchar2_table(212) := '75742871756965746573744672616D652829202B2031293B0A2020202020207D0A202020207D0A0A2020202066756E6374696F6E2066696E6973685265636F7264696E672829207B0A20202020202069662028217265636F7264696E6729207B0A202020';
wwv_flow_imp.g_varchar2_table(213) := '202020202072657475726E3B0A2020202020207D0A2020202020207265636F7264696E67203D2066616C73653B0A20202020202072656C65617365417564696F28293B0A2020202020206966202821686561726429207B0A20202020202020206661696C';
wwv_flow_imp.g_varchar2_table(214) := '28226E6F2D73706565636822293B0A202020202020202072657475726E3B0A2020202020207D0A20202020202068616E646C6572732E6F6E50726F63657373696E6728293B0A20202020202073746F70706564203D20747275653B0A2020202020206966';
wwv_flow_imp.g_varchar2_table(215) := '20287365676D656E74486561726429207B0A2020202020202020637574286672616D65732E6C656E677468293B0A2020202020207D0A202020202020636F6D706C65746528293B0A202020207D0A0A2020202066756E6374696F6E207265636F72642829';
wwv_flow_imp.g_varchar2_table(216) := '207B0A2020202020202F2F2046697265666F782063616E6E6F7420636F6E6E65637420746865206D6963726F70686F6E6520746F206120636F6E7465787420617420616E6F7468657220726174652C20736F207265636F7264206174207468650A202020';
wwv_flow_imp.g_varchar2_table(217) := '2020202F2F20646576696365207261746520616E6420726573616D706C6520746F205441524745545F5241544520616674657277617264732E0A202020202020636F6E74657874203D206E65772077696E646F772E417564696F436F6E7465787428293B';
wwv_flow_imp.g_varchar2_table(218) := '0A20202020202072617465203D20636F6E746578742E73616D706C65526174653B0A20202020202076617220736F75726365203D20636F6E746578742E6372656174654D6564696153747265616D536F757263652873747265616D293B0A202020202020';
wwv_flow_imp.g_varchar2_table(219) := '7661722070726F636573736F72203D20636F6E746578742E63726561746553637269707450726F636573736F7228343039362C20312C2031293B0A2020202020206D6F64656C2E776F726B65722E6F6E6D657373616765203D2072656365697665643B0A';
wwv_flow_imp.g_varchar2_table(220) := '20202020202070726F636573736F722E6F6E617564696F70726F63657373203D2066756E6374696F6E20286576656E7429207B0A202020202020202069662028217265636F7264696E6729207B0A2020202020202020202072657475726E3B0A20202020';
wwv_flow_imp.g_varchar2_table(221) := '202020207D0A20202020202020207661722064617461203D206E657720466C6F617433324172726179286576656E742E696E7075744275666665722E6765744368616E6E656C44617461283029293B0A20202020202020207661722073756D203D20303B';
wwv_flow_imp.g_varchar2_table(222) := '0A2020202020202020666F7220287661722069203D20303B2069203C20646174612E6C656E6774683B20692B2B29207B0A2020202020202020202073756D202B3D20646174615B695D202A20646174615B695D3B0A20202020202020207D0A2020202020';
wwv_flow_imp.g_varchar2_table(223) := '202020766172206672616D65203D207B20646174613A20646174612C206C6576656C3A204D6174682E737172742873756D202F20646174612E6C656E67746829207D3B0A20202020202020206672616D65732E70757368286672616D65293B0A20202020';
wwv_flow_imp.g_varchar2_table(224) := '20202020746F74616C202B3D20646174612E6C656E6774683B0A20202020202020206D656173757265286672616D65293B0A2020202020202020696620286672616D652E6C6576656C203E205350454543485F4C4556454C29207B0A2020202020202020';
wwv_flow_imp.g_varchar2_table(225) := '20206865617264203D20747275653B0A202020202020202020207175696574203D20303B0A20202020202020207D20656C7365207B0A202020202020202020207175696574202B3D20646174612E6C656E6774683B0A20202020202020207D0A20202020';
wwv_flow_imp.g_varchar2_table(226) := '202020206966202873657474696E67732E696E746572696D526573756C747329207B0A202020202020202020207365676D656E74496644756528293B0A20202020202020207D0A202020202020202069662028746F74616C203E3D204D41585F5345434F';
wwv_flow_imp.g_varchar2_table(227) := '4E4453202A2072617465207C7C0A202020202020202020202020286865617264202626207175696574203E3D2073657474696E67732E73746F7053696C656E6365202A207261746529207C7C0A2020202020202020202020202821686561726420262620';
wwv_flow_imp.g_varchar2_table(228) := '746F74616C203E3D204E4F5F5350454543485F5345434F4E4453202A20726174652929207B0A2020202020202020202066696E6973685265636F7264696E6728293B0A20202020202020207D0A2020202020207D3B0A202020202020736F757263652E63';
wwv_flow_imp.g_varchar2_table(229) := '6F6E6E6563742870726F636573736F72293B0A20202020202070726F636573736F722E636F6E6E65637428636F6E746578742E64657374696E6174696F6E293B0A2020202020207265636F7264696E67203D20747275653B0A20202020202068616E646C';
wwv_flow_imp.g_varchar2_table(230) := '6572732E6F6E537461727428293B0A202020207D0A0A2020202072657475726E207B0A20202020202073746172743A2066756E6374696F6E202829207B0A202020202020202068616E646C6572732E6F6E4C6F6164696E672830293B0A20202020202020';
wwv_flow_imp.g_varchar2_table(231) := '20766172206C6F6164696E67203D206C6F61644D6F64656C2873657474696E67732C2066756E6374696F6E202870657263656E7429207B0A202020202020202020202F2F2054686520646F776E6C6F6164206F75746C6976657320612073657373696F6E';
wwv_flow_imp.g_varchar2_table(232) := '2074686174206661696C6564206F72207761732073746F707065643B2069676E6F7265206974732070726F67726573732E0A20202020202020202020696620282166696E697368656429207B0A20202020202020202020202068616E646C6572732E6F6E';
wwv_flow_imp.g_varchar2_table(233) := '4C6F6164696E672870657263656E74293B0A202020202020202020207D0A20202020202020207D292E63617463682866756E6374696F6E202829207B0A202020202020202020207468726F7720226D6F64656C2D756E617661696C61626C65223B0A2020';
wwv_flow_imp.g_varchar2_table(234) := '2020202020207D293B0A2020202020202020766172206D6963726F70686F6E65203D2077696E646F772E6E6176696761746F722E6D65646961446576696365732E676574557365724D65646961287B20617564696F3A2074727565207D292E7468656E28';
wwv_flow_imp.g_varchar2_table(235) := '66756E6374696F6E20286772616E74656429207B0A2020202020202020202073747265616D203D206772616E7465643B0A202020202020202020206966202866696E697368656429207B0A20202020202020202020202072656C65617365417564696F28';
wwv_flow_imp.g_varchar2_table(236) := '293B0A202020202020202020207D0A20202020202020207D2C2066756E6374696F6E20286572726F7229207B0A20202020202020202020766172206E616D65203D206572726F72202626206572726F722E6E616D653B0A20202020202020202020746872';
wwv_flow_imp.g_varchar2_table(237) := '6F77206E616D65203D3D3D20224E6F74416C6C6F7765644572726F7222207C7C206E616D65203D3D3D202253656375726974794572726F7222203F20227065726D697373696F6E2D64656E69656422203A0A2020202020202020202020206E616D65203D';
wwv_flow_imp.g_varchar2_table(238) := '3D3D20224E6F74466F756E644572726F7222203F20226E6F2D6D6963726F70686F6E6522203A2022756E737570706F72746564223B0A20202020202020207D293B0A202020202020202050726F6D6973652E616C6C285B6C6F6164696E672C206D696372';
wwv_flow_imp.g_varchar2_table(239) := '6F70686F6E655D292E7468656E2866756E6374696F6E2028726573756C747329207B0A202020202020202020206966202866696E697368656429207B0A20202020202020202020202072657475726E3B0A202020202020202020207D0A20202020202020';
wwv_flow_imp.g_varchar2_table(240) := '2020206D6F64656C203D20726573756C74735B305D3B0A20202020202020202020747279207B0A2020202020202020202020207265636F726428293B0A202020202020202020207D20636174636820286572726F7229207B0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(241) := '206661696C2822756E737570706F7274656422293B0A202020202020202020207D0A20202020202020207D2C206661696C293B0A2020202020207D2C0A20202020202073746F703A2066756E6374696F6E202829207B0A20202020202020206966202872';
wwv_flow_imp.g_varchar2_table(242) := '65636F7264696E6729207B0A2020202020202020202066696E6973685265636F7264696E6728293B0A20202020202020207D20656C73652069662028216D6F64656C29207B0A20202020202020202020656E6428293B0A20202020202020207D0A202020';
wwv_flow_imp.g_varchar2_table(243) := '2020207D2C0A202020207D3B0A20207D0A0A202076617220454E47494E4553203D207B0A20202020227765622D737065656368223A207B20617661696C61626C653A2066756E6374696F6E202829207B2072657475726E20212177656253706565636843';
wwv_flow_imp.g_varchar2_table(244) := '6F6E7374727563746F7228293B207D2C206372656174653A20637265617465576562537065656368456E67696E65207D2C0A20202020226C6F63616C2D6D6F64656C223A207B20617661696C61626C653A206C6F63616C4D6F64656C417661696C61626C';
wwv_flow_imp.g_varchar2_table(245) := '652C206372656174653A206372656174654C6F63616C4D6F64656C456E67696E65207D2C0A20207D3B0A0A202066756E6374696F6E20656E67696E65417661696C61626C6528696E7374616E636529207B0A2020202076617220656E67696E65203D2045';
wwv_flow_imp.g_varchar2_table(246) := '4E47494E45535B696E7374616E63652E73657474696E67732E656E67696E655D3B0A2020202072657475726E202121656E67696E6520262620656E67696E652E617661696C61626C6528293B0A20207D0A0A202066756E6374696F6E207375626D697428';
wwv_flow_imp.g_varchar2_table(247) := '696E7374616E636529207B0A202020207661722073656E64203D20696E7374616E63652E726567696F6E2E717565727953656C6563746F722853454E445F53454C4543544F52293B0A202020206966202873656E6429207B0A20202020202073656E642E';
wwv_flow_imp.g_varchar2_table(248) := '636C69636B28293B0A202020207D0A20207D0A0A202066756E6374696F6E20636F6D6D697428696E7374616E63652C207465787429207B0A20202020696E7374616E63652E70656E64696E67203D206E756C6C3B0A20202020696E7374616E63652E6469';
wwv_flow_imp.g_varchar2_table(249) := '637461746564203D20747275653B0A2020202069662028696E7374616E63652E73657474696E67732E7479706577726974657229207B0A202020202020696E7374616E63652E636F6D6D6974746564203D20747275653B0A202020202020696620282169';
wwv_flow_imp.g_varchar2_table(250) := '6E7374616E63652E747970696E6754696D657229207B0A202020202020202066696E697368547970696E6728696E7374616E6365293B0A2020202020207D0A202020207D20656C7365207B0A202020202020696E7374616E63652E62617365203D206E75';
wwv_flow_imp.g_varchar2_table(251) := '6C6C3B0A202020207D0A202020206669726528696E7374616E63652C2022766F6963652D726573756C74222C207B20746578743A20746578742C20697346696E616C3A2074727565207D293B0A20207D0A0A202066756E6374696F6E206D61726B556E61';
wwv_flow_imp.g_varchar2_table(252) := '7661696C61626C6528696E7374616E636529207B0A20202020736574537461746528696E7374616E63652C2022756E617661696C61626C6522293B0A20202020736574546F6F6C74697028696E7374616E63652C20696E7374616E63652E6E6F4D696372';
wwv_flow_imp.g_varchar2_table(253) := '6F70686F6E65203F204E4F5F4D4943524F50484F4E455F4B4559203A2022564F4943455F494E5055542E4552524F522E756E737570706F7274656422293B0A20207D0A0A20202F2F205468652075736572206861732064656E69656420286F7220726573';
wwv_flow_imp.g_varchar2_table(254) := '746F72656429206D6963726F70686F6E65206163636573732E2054616B65732065666665637420696D6D6564696174656C79207768656E0A20202F2F2069646C653B206F7468657277697365207768656E207468652072756E6E696E6720646963746174';
wwv_flow_imp.g_varchar2_table(255) := '696F6E20656E64732E0A202066756E6374696F6E20736574426C6F636B656428696E7374616E63652C20626C6F636B656429207B0A20202020696E7374616E63652E626C6F636B6564203D20626C6F636B65643B0A2020202069662028696E7374616E63';
wwv_flow_imp.g_varchar2_table(256) := '652E7374617465203D3D3D202269646C6522207C7C20696E7374616E63652E7374617465203D3D3D2022626C6F636B65642229207B0A202020202020736574537461746528696E7374616E63652C20626C6F636B6564203F2022626C6F636B656422203A';
wwv_flow_imp.g_varchar2_table(257) := '202269646C6522293B0A202020202020736574546F6F6C74697028696E7374616E63652C20626C6F636B6564203F2022564F4943455F494E5055542E424C4F434B454422203A206E756C6C293B0A202020207D0A20207D0A0A202066756E6374696F6E20';
wwv_flow_imp.g_varchar2_table(258) := '747261636B5065726D697373696F6E28696E7374616E636529207B0A20202020766172207065726D697373696F6E73203D2077696E646F772E6E6176696761746F722E7065726D697373696F6E733B0A2020202069662028217065726D697373696F6E73';
wwv_flow_imp.g_varchar2_table(259) := '207C7C20217065726D697373696F6E732E717565727929207B0A20202020202072657475726E3B0A202020207D0A202020207661722071756572793B0A20202020747279207B0A2020202020207175657279203D207065726D697373696F6E732E717565';
wwv_flow_imp.g_varchar2_table(260) := '7279287B206E616D653A20226D6963726F70686F6E6522207D293B0A202020207D20636174636820286572726F7229207B0A20202020202072657475726E3B0A202020207D0A2020202050726F6D6973652E7265736F6C7665287175657279292E746865';
wwv_flow_imp.g_varchar2_table(261) := '6E2866756E6374696F6E202873746174757329207B0A202020202020696E7374616E63652E7065726D697373696F6E547261636B6564203D20747275653B0A202020202020766172206170706C79203D2066756E6374696F6E202829207B20736574426C';
wwv_flow_imp.g_varchar2_table(262) := '6F636B656428696E7374616E63652C207374617475732E7374617465203D3D3D202264656E69656422293B207D3B0A2020202020207374617475732E6F6E6368616E6765203D206170706C793B0A2020202020206170706C7928293B0A202020207D2C20';
wwv_flow_imp.g_varchar2_table(263) := '66756E6374696F6E202829207B7D293B0A20207D0A0A202066756E6374696F6E20737461727428696E7374616E636529207B0A202020202F2F20576974686F757420746865205065726D697373696F6E732041504920746865206F6E6C79207761792074';
wwv_flow_imp.g_varchar2_table(264) := '6F206C6561726E2074686174206163636573732063616D65206261636B20697320746F2074727920616761696E2E0A20202020766172207265747279203D20696E7374616E63652E7374617465203D3D3D2022626C6F636B6564222026262021696E7374';
wwv_flow_imp.g_varchar2_table(265) := '616E63652E7065726D697373696F6E547261636B65643B0A2020202069662028696E7374616E63652E737461746520213D3D202269646C65222026262021726574727929207B0A20202020202072657475726E3B0A202020207D0A202020206966202821';
wwv_flow_imp.g_varchar2_table(266) := '656E67696E65417661696C61626C6528696E7374616E63652929207B0A2020202020206D61726B556E617661696C61626C6528696E7374616E6365293B0A2020202020207265706F72744572726F7228696E7374616E63652C2022756E737570706F7274';
wwv_flow_imp.g_varchar2_table(267) := '656422293B0A20202020202072657475726E3B0A202020207D0A20202020696620286163746976652026262061637469766520213D3D20696E7374616E636529207B0A20202020202073746F7028616374697665293B0A202020207D0A20202020616374';
wwv_flow_imp.g_varchar2_table(268) := '697665203D20696E7374616E63653B0A20202020666C757368547970696E6728696E7374616E6365293B0A20202020696E7374616E63652E62617365203D206E756C6C3B0A20202020696E7374616E63652E696E746572696D53686F776E203D2022223B';
wwv_flow_imp.g_varchar2_table(269) := '0A20202020696E7374616E63652E70656E64696E67203D206E756C6C3B0A20202020696E7374616E63652E6469637461746564203D2066616C73653B0A20202020696E7374616E63652E656469746564203D2066616C73653B0A20202020696E7374616E';
wwv_flow_imp.g_varchar2_table(270) := '63652E656E67696E65203D20454E47494E45535B696E7374616E63652E73657474696E67732E656E67696E655D2E63726561746528696E7374616E63652E73657474696E67732C207B0A2020202020206F6E4C6F6164696E673A2066756E6374696F6E20';
wwv_flow_imp.g_varchar2_table(271) := '2870657263656E7429207B0A2020202020202020736574537461746528696E7374616E63652C20226C6F6164696E6722293B0A2020202020202020696E7374616E63652E627574746F6E2E7365744174747269627574652822646174612D70726F677265';
wwv_flow_imp.g_varchar2_table(272) := '7373222C20537472696E672870657263656E7429293B0A2020202020202020696E7374616E63652E627574746F6E2E7469746C65203D206D6573736167652822564F4943455F494E5055542E4C4F4144494E472229202B20222022202B2070657263656E';
wwv_flow_imp.g_varchar2_table(273) := '74202B202225223B0A2020202020207D2C0A2020202020206F6E50726F63657373696E673A2066756E6374696F6E202829207B0A2020202020202020736574537461746528696E7374616E63652C202270726F63657373696E6722293B0A202020202020';
wwv_flow_imp.g_varchar2_table(274) := '2020736574546F6F6C74697028696E7374616E63652C2022564F4943455F494E5055542E50524F43455353494E4722293B0A2020202020207D2C0A2020202020206F6E53746172743A2066756E6374696F6E202829207B0A2020202020202020696E7374';
wwv_flow_imp.g_varchar2_table(275) := '616E63652E626C6F636B6564203D2066616C73653B0A2020202020202020696E7374616E63652E627574746F6E2E72656D6F76654174747269627574652822646174612D70726F677265737322293B0A2020202020202020736574546F6F6C7469702869';
wwv_flow_imp.g_varchar2_table(276) := '6E7374616E63652C206E756C6C293B0A2020202020202020736574537461746528696E7374616E63652C20226C697374656E696E6722293B0A20202020202020206669726528696E7374616E63652C2022766F6963652D7374617274222C207B7D293B0A';
wwv_flow_imp.g_varchar2_table(277) := '2020202020207D2C0A2020202020206F6E546578743A2066756E6374696F6E2028746578742C20697346696E616C2C20636F7272656374696F6E29207B0A202020202020202069662028217465787429207B0A2020202020202020202072657475726E3B';
wwv_flow_imp.g_varchar2_table(278) := '0A20202020202020207D0A202020202020202070726573656E7428696E7374616E63652C20746578742C20697346696E616C2C20636F7272656374696F6E293B0A202020202020202069662028697346696E616C29207B0A20202020202020202020636F';
wwv_flow_imp.g_varchar2_table(279) := '6D6D697428696E7374616E63652C2074657874293B0A20202020202020207D20656C7365207B0A20202020202020202020696E7374616E63652E70656E64696E67203D20746578743B0A202020202020202020206669726528696E7374616E63652C2022';
wwv_flow_imp.g_varchar2_table(280) := '766F6963652D726573756C74222C207B20746578743A20746578742C20697346696E616C3A2066616C7365207D293B0A20202020202020207D0A2020202020207D2C0A2020202020206F6E4572726F723A2066756E6374696F6E2028636F646529207B0A';
wwv_flow_imp.g_varchar2_table(281) := '20202020202020207265706F72744572726F7228696E7374616E63652C20636F6465293B0A202020202020202069662028636F6465203D3D3D20227065726D697373696F6E2D64656E6965642229207B0A20202020202020202020696E7374616E63652E';
wwv_flow_imp.g_varchar2_table(282) := '626C6F636B6564203D20747275653B0A20202020202020202020736574546F6F6C74697028696E7374616E63652C2022564F4943455F494E5055542E424C4F434B454422293B0A2020202020202020202073686F774572726F724D657373616765282256';
wwv_flow_imp.g_varchar2_table(283) := '4F4943455F494E5055542E4552524F522E7065726D697373696F6E2D64656E69656422293B0A20202020202020207D20656C73652069662028636F6465203D3D3D20226E6F2D6D6963726F70686F6E652229207B0A20202020202020202020696E737461';
wwv_flow_imp.g_varchar2_table(284) := '6E63652E6E6F4D6963726F70686F6E65203D20747275653B0A2020202020202020202073686F774572726F724D657373616765284E4F5F4D4943524F50484F4E455F4B4559293B0A20202020202020207D0A2020202020207D2C0A2020202020206F6E45';
wwv_flow_imp.g_varchar2_table(285) := '6E643A2066756E6374696F6E20286166746572526573756C7429207B0A202020202020202069662028696E7374616E63652E70656E64696E6729207B0A20202020202020202020636F6D6D697428696E7374616E63652C20696E7374616E63652E70656E';
wwv_flow_imp.g_varchar2_table(286) := '64696E67293B0A20202020202020207D0A202020202020202069662028216166746572526573756C7429207B0A20202020202020202020666C757368547970696E6728696E7374616E6365293B0A20202020202020207D0A2020202020202020696E7374';
wwv_flow_imp.g_varchar2_table(287) := '616E63652E656E67696E65203D206E756C6C3B0A202020202020202069662028616374697665203D3D3D20696E7374616E636529207B0A20202020202020202020616374697665203D206E756C6C3B0A20202020202020207D0A2020202020202020696E';
wwv_flow_imp.g_varchar2_table(288) := '7374616E63652E627574746F6E2E72656D6F76654174747269627574652822646174612D70726F677265737322293B0A202020202020202069662028696E7374616E63652E6E6F4D6963726F70686F6E6529207B0A202020202020202020206D61726B55';
wwv_flow_imp.g_varchar2_table(289) := '6E617661696C61626C6528696E7374616E6365293B0A20202020202020207D20656C7365207B0A20202020202020202020736574537461746528696E7374616E63652C20696E7374616E63652E626C6F636B6564203F2022626C6F636B656422203A2022';
wwv_flow_imp.g_varchar2_table(290) := '69646C6522293B0A20202020202020202020736574546F6F6C74697028696E7374616E63652C20696E7374616E63652E626C6F636B6564203F2022564F4943455F494E5055542E424C4F434B454422203A206E756C6C293B0A20202020202020207D0A20';
wwv_flow_imp.g_varchar2_table(291) := '202020202020206669726528696E7374616E63652C2022766F6963652D656E64222C207B7D293B0A202020202020202069662028696E7374616E63652E646963746174656420262620696E7374616E63652E73657474696E67732E6175746F5375626D69';
wwv_flow_imp.g_varchar2_table(292) := '7429207B0A2020202020202020202069662028696E7374616E63652E747970696E6754696D657229207B0A202020202020202020202020696E7374616E63652E7375626D69745768656E5479706564203D20747275653B0A202020202020202020207D20';
wwv_flow_imp.g_varchar2_table(293) := '656C7365207B0A2020202020202020202020207375626D697428696E7374616E6365293B0A202020202020202020207D0A20202020202020207D0A2020202020207D2C0A202020207D293B0A20202020696E7374616E63652E656E67696E652E73746172';
wwv_flow_imp.g_varchar2_table(294) := '7428293B0A20207D0A0A202066756E6374696F6E2073746F7028696E7374616E636529207B0A2020202069662028696E7374616E63652E656E67696E6529207B0A202020202020696E7374616E63652E656E67696E652E73746F7028293B0A202020207D';
wwv_flow_imp.g_varchar2_table(295) := '0A20207D0A0A202066756E6374696F6E20746F67676C6528696E7374616E636529207B0A2020202069662028696E7374616E63652E7374617465203D3D3D20226C697374656E696E6722207C7C20696E7374616E63652E7374617465203D3D3D20226C6F';
wwv_flow_imp.g_varchar2_table(296) := '6164696E672229207B0A20202020202073746F7028696E7374616E6365293B0A202020207D20656C7365207B0A202020202020737461727428696E7374616E6365293B0A202020207D0A20207D0A0A202076617220616C6C203D205B5D3B0A2020766172';
wwv_flow_imp.g_varchar2_table(297) := '207265676973746572656453686F727463757473203D207B7D3B0A0A20202F2F204F6E65204150455820616374696F6E207065722064697374696E63742073686F72746375743B206974206F6E6C79206669726573207768696C6520666F637573206973';
wwv_flow_imp.g_varchar2_table(298) := '20696E736964652061206368617420726567696F6E2E0A202066756E6374696F6E20726567697374657253686F72746375742873686F727463757429207B0A20202020696620282173686F7274637574207C7C207265676973746572656453686F727463';
wwv_flow_imp.g_varchar2_table(299) := '7574735B73686F72746375745D29207B0A20202020202072657475726E3B0A202020207D0A202020207265676973746572656453686F7274637574735B73686F72746375745D203D20747275653B0A2020202077696E646F772E617065782E616374696F';
wwv_flow_imp.g_varchar2_table(300) := '6E732E616464287B0A2020202020206E616D653A20226F72636C617065782D766F6963652D696E7075742D746F67676C652D22202B2073686F72746375742E7265706C616365282F5B5E412D5A612D7A302D395D2B2F672C20222D22292C0A2020202020';
wwv_flow_imp.g_varchar2_table(301) := '206C6162656C3A206D6573736167652822564F4943455F494E5055542E4D49435F4C4142454C22292C0A20202020202073686F72746375743A2073686F72746375742C0A202020202020616374696F6E3A2066756E6374696F6E202829207B0A20202020';
wwv_flow_imp.g_varchar2_table(302) := '2020202076617220666F6375736564203D20646F63756D656E742E616374697665456C656D656E743B0A2020202020202020666F7220287661722069203D20303B2069203C20616C6C2E6C656E6774683B20692B2B29207B0A2020202020202020202076';
wwv_flow_imp.g_varchar2_table(303) := '617220696E7374616E6365203D20616C6C5B695D3B0A2020202020202020202069662028696E7374616E63652E73657474696E67732E73686F7274637574203D3D3D2073686F727463757420262620696E7374616E63652E726567696F6E2E6973436F6E';
wwv_flow_imp.g_varchar2_table(304) := '6E656374656420262620696E7374616E63652E726567696F6E2E636F6E7461696E7328666F63757365642929207B0A202020202020202020202020746F67676C6528696E7374616E6365293B0A20202020202020202020202072657475726E3B0A202020';
wwv_flow_imp.g_varchar2_table(305) := '202020202020207D0A20202020202020207D0A2020202020207D2C0A202020207D293B0A20207D0A0A202066756E6374696F6E2061747461636828726567696F6E2C2072617753657474696E677329207B0A202020207661722073657474696E6773203D';
wwv_flow_imp.g_varchar2_table(306) := '2073657474696E677346726F6D2872617753657474696E6773293B0A2020202076617220636F6E7461696E6572203D20726567696F6E2E717565727953656C6563746F722873657474696E67732E616374696F6E7353656C6563746F72293B0A20202020';
wwv_flow_imp.g_varchar2_table(307) := '6966202821636F6E7461696E6572207C7C20636F6E7461696E65722E717565727953656C6563746F7228225B22202B204D49435F415454524942555445202B20225D222929207B0A20202020202072657475726E3B0A202020207D0A2020202076617220';
wwv_flow_imp.g_varchar2_table(308) := '627574746F6E203D206372656174654D6963427574746F6E2873657474696E6773293B0A20202020766172206C697665526567696F6E203D20646F63756D656E742E637265617465456C656D656E7428227370616E22293B0A202020206C697665526567';
wwv_flow_imp.g_varchar2_table(309) := '696F6E2E636C6173734E616D65203D2022766F6963652D696E7075742D6C697665223B0A202020206C697665526567696F6E2E7365744174747269627574652822726F6C65222C202273746174757322293B0A202020206C697665526567696F6E2E7365';
wwv_flow_imp.g_varchar2_table(310) := '744174747269627574652822617269612D6C697665222C2022706F6C69746522293B0A2020202076617220696E7374616E6365203D207B0A2020202020206C697665526567696F6E3A206C697665526567696F6E2C20726567696F6E3A20726567696F6E';
wwv_flow_imp.g_varchar2_table(311) := '2C2073657474696E67733A2073657474696E67732C20627574746F6E3A20627574746F6E2C2069636F6E3A20627574746F6E2E717565727953656C6563746F7228227370616E22292C0A20202020202073746174653A202269646C65222C20656E67696E';
wwv_flow_imp.g_varchar2_table(312) := '653A206E756C6C2C20626173653A206E756C6C2C2070656E64696E673A206E756C6C2C2064696374617465643A2066616C73652C20626C6F636B65643A2066616C73652C206564697465643A2066616C73652C206E6F4D6963726F70686F6E653A206661';
wwv_flow_imp.g_varchar2_table(313) := '6C73652C207065726D697373696F6E547261636B65643A2066616C73652C0A202020202020676F616C3A2022222C2073686F776E3A2022222C20636F6D6D69747465643A2066616C73652C20747970696E6754696D65723A206E756C6C2C207375626D69';
wwv_flow_imp.g_varchar2_table(314) := '745768656E54797065643A2066616C73652C2077726974696E673A2066616C73652C0A202020207D3B0A20202020696E7374616E6365732E73657428726567696F6E2C20696E7374616E6365293B0A20202020627574746F6E2E6164644576656E744C69';
wwv_flow_imp.g_varchar2_table(315) := '7374656E65722822636C69636B222C2066756E6374696F6E202829207B20746F67676C6528696E7374616E6365293B207D293B0A20202020726567696F6E2E6164644576656E744C697374656E65722822696E707574222C2066756E6374696F6E202865';
wwv_flow_imp.g_varchar2_table(316) := '76656E7429207B0A202020202020766172207479706564203D2021696E7374616E63652E77726974696E67202626206576656E742E7461726765742E6D617463686573202626206576656E742E7461726765742E6D617463686573285441524745545F53';
wwv_flow_imp.g_varchar2_table(317) := '454C4543544F52293B0A2020202020202F2F205769746820696E746572696D207365676D656E747320696E20746865205461726765742C2061207573657220656469742073746F707320667572746865722077726974657320666F722074686973207365';
wwv_flow_imp.g_varchar2_table(318) := '7373696F6E2E0A20202020202069662028747970656420262620696E7374616E63652E656E67696E652026262073657474696E67732E656E67696E65203D3D3D20226C6F63616C2D6D6F64656C222026262073657474696E67732E696E746572696D5265';
wwv_flow_imp.g_varchar2_table(319) := '73756C74732026260A2020202020202020202028696E7374616E63652E6261736520213D3D206E756C6C207C7C20696E7374616E63652E747970696E6754696D65722929207B0A2020202020202020696E7374616E63652E656469746564203D20747275';
wwv_flow_imp.g_varchar2_table(320) := '653B0A2020202020207D0A2020202020206966202821696E7374616E63652E77726974696E6720262620696E7374616E63652E747970696E6754696D6572202626206576656E742E7461726765742E6D617463686573202626206576656E742E74617267';
wwv_flow_imp.g_varchar2_table(321) := '65742E6D617463686573285441524745545F53454C4543544F522929207B0A202020202020202063616E63656C547970696E6728696E7374616E6365293B0A2020202020207D0A202020207D293B0A20202020636F6E7461696E65722E617070656E6443';
wwv_flow_imp.g_varchar2_table(322) := '68696C64286C697665526567696F6E293B0A20202020636F6E7461696E65722E617070656E644368696C6428627574746F6E293B0A20202020616C6C203D20616C6C2E66696C7465722866756E6374696F6E20286F7468657229207B2072657475726E20';
wwv_flow_imp.g_varchar2_table(323) := '6F746865722E726567696F6E2E6973436F6E6E65637465643B207D293B0A20202020616C6C2E7075736828696E7374616E6365293B0A20202020726567697374657253686F72746375742873657474696E67732E73686F7274637574293B0A2020202069';
wwv_flow_imp.g_varchar2_table(324) := '66202821656E67696E65417661696C61626C6528696E7374616E63652929207B0A2020202020206D61726B556E617661696C61626C6528696E7374616E6365293B0A2020202020207265706F72744572726F7228696E7374616E63652C2022756E737570';
wwv_flow_imp.g_varchar2_table(325) := '706F7274656422293B0A202020207D20656C7365207B0A202020202020747261636B5065726D697373696F6E28696E7374616E6365293B0A202020207D0A20207D0A0A20202F2F2054686520706C75672D696E206F6E6C792061747461636865733B2064';
wwv_flow_imp.g_varchar2_table(326) := '6963746174696F6E2069732064726976656E20627920746865204D696320427574746F6E20616E6420746865206B6579626F6172642073686F72746375742E0A20202F2F2054686520706C75672D696E27732072656E64657220636F6465206D61792061';
wwv_flow_imp.g_varchar2_table(327) := '6C72656164792068617665206164646564207065722D616374696F6E2066756E6374696F6E7320746F2074686973206F626A6563742E0A202077696E646F772E6F72636C61706578566F696365496E707574203D204F626A6563742E61737369676E2877';
wwv_flow_imp.g_varchar2_table(328) := '696E646F772E6F72636C61706578566F696365496E707574207C7C207B7D2C207B0A20202020657865637574653A2066756E6374696F6E2028636F6E7465787429207B0A20202020202061747461636828636F6E746578742E6166666563746564456C65';
wwv_flow_imp.g_varchar2_table(329) := '6D656E742C20636F6E746578742E73657474696E6773293B0A202020207D2C0A20207D293B0A7D292877696E646F77293B0A';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(32398824512736606)
,p_plugin_id=>wwv_flow_imp.id(32396351144736598)
,p_file_name=>'voice-input.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false)
);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
