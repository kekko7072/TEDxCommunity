///Foundation
export 'dart:io';
export 'dart:math';
export 'dart:async';
export 'dart:convert';
export 'dart:typed_data';
export 'package:flutter/services.dart';
export 'package:flutter/foundation.dart' show kIsWeb;

///Server
export 'firebase_options.dart';
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_auth/firebase_auth.dart';
export 'package:cloud_firestore/cloud_firestore.dart';

///Calendar
//export '../../test/calendar_service.dart';
//export 'package:google_sign_in/google_sign_in.dart';
//export 'package:googleapis_auth/auth_io.dart';
//export 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

///Basic
export 'package:provider/provider.dart';
export 'package:file_picker/file_picker.dart';
export 'package:uuid/uuid.dart';
export 'package:flutter_vibrate/flutter_vibrate.dart';
export 'package:speech_to_text/speech_to_text.dart';
export 'package:flutter_tts/flutter_tts.dart';
export 'package:speech_to_text/speech_recognition_result.dart';
export 'package:audio_service/audio_service.dart';
export 'package:audio_session/audio_session.dart';
export 'package:shared_preferences/shared_preferences.dart';

///Design
export 'package:flutter/material.dart';
export 'package:cupertino_stepper/cupertino_stepper.dart';
export 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';
//export 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
export 'package:flutter_easyloading/flutter_easyloading.dart';
export 'package:url_launcher/url_launcher.dart';
export 'package:url_launcher/url_launcher_string.dart';
export 'package:flutter_signin_button/flutter_signin_button.dart';
export 'package:macos_ui/macos_ui.dart';
export 'package:package_info_plus/package_info_plus.dart';
export 'package:siri_wave/siri_wave.dart';

export '../interface/pages/team/confirmed.dart';
export '../interface/pages/team/elaboration.dart';
export '../interface/pages/team/long_list.dart';
export '../interface/screen/authenticate.dart';

export '../services/database_speaker.dart';
export '../services/step_service.dart';
//export 'package:sendgrid_mailer/sendgrid_mailer.dart';
export '../services/dialog_contact.dart';
export '../services/auth_service.dart';
export '../services/database_user.dart';
export '../services/style.dart';
export '../services/text_labels.dart';

export '../interface/screen/menu_team.dart';
export '../app.dart';
export '../services/database_license.dart';
export '../constants.dart';
export '../interface/pages/speaker/management.dart';
export '../interface/pages/speaker/coaching.dart';
export '../interface/widget/top_bar_team.dart';
export '../interface/screen/menu_speaker.dart';
export '../services/database_warehouse.dart';
export '../../../services/vocal_assistant.dart';

///Screen
export '../interface/screen/loading_or_error.dart';
export '../interface/screen/confirmed_team.dart';
export '../interface/screen/info_app_team.dart';
export '../interface/screen/info_app_speaker.dart';
export '../interface/pages/team/bags.dart';

///Widget
export '../interface/widget/add_coach.dart';
export '../interface/widget/add_speaker.dart';
export '../interface/widget/add_bag.dart';
export '../interface/widget/add_license.dart';
export '../interface/widget/speaker_item.dart';
export '../interface/widget/speaker_profile.dart';
export '../interface/widget/input_field.dart';
export '../interface/widget/confirmed_elements.dart';
export '../interface/widget/datetimepicker_modal.dart';
export '../interface/widget/edit_speaker.dart';
export '../interface/widget/top_bar_speaker.dart';

///Models
export '../models/styles.dart';
export '../models/license.dart';
export '../models/user.dart';
export '../models/speaker.dart';
export '../models/warehouse.dart';
