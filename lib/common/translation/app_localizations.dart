import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'translation/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @common_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get common_save;

  /// No description provided for @common_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get common_cancel;

  /// No description provided for @common_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get common_delete;

  /// No description provided for @common_add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get common_add;

  /// No description provided for @common_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get common_edit;

  /// No description provided for @common_new.
  ///
  /// In en, this message translates to:
  /// **'+ New'**
  String get common_new;

  /// No description provided for @common_kind_site.
  ///
  /// In en, this message translates to:
  /// **'site'**
  String get common_kind_site;

  /// No description provided for @common_kind_app.
  ///
  /// In en, this message translates to:
  /// **'app'**
  String get common_kind_app;

  /// No description provided for @window_title_idle.
  ///
  /// In en, this message translates to:
  /// **'Focus — {projectName}'**
  String window_title_idle(String projectName);

  /// No description provided for @window_title_running.
  ///
  /// In en, this message translates to:
  /// **'In focus'**
  String get window_title_running;

  /// No description provided for @projects_label.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projects_label;

  /// No description provided for @projects_subtitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 app · saved layout} other{{count} apps · saved layout}}'**
  String projects_subtitle(int count);

  /// No description provided for @projects_footer_hint.
  ///
  /// In en, this message translates to:
  /// **'A project is a saved window layout. Launching it opens the same apps in the same places, every time.'**
  String get projects_footer_hint;

  /// No description provided for @workspace_launch.
  ///
  /// In en, this message translates to:
  /// **'Launch workspace'**
  String get workspace_launch;

  /// No description provided for @workspace_launching.
  ///
  /// In en, this message translates to:
  /// **'Opening…'**
  String get workspace_launching;

  /// No description provided for @workspace_rearrange.
  ///
  /// In en, this message translates to:
  /// **'Re-arrange'**
  String get workspace_rearrange;

  /// No description provided for @workspace_window_state_pending.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get workspace_window_state_pending;

  /// No description provided for @workspace_window_state_opening.
  ///
  /// In en, this message translates to:
  /// **'opening…'**
  String get workspace_window_state_opening;

  /// No description provided for @workspace_window_state_open.
  ///
  /// In en, this message translates to:
  /// **'open'**
  String get workspace_window_state_open;

  /// No description provided for @workspace_window_state_failed.
  ///
  /// In en, this message translates to:
  /// **'failed'**
  String get workspace_window_state_failed;

  /// No description provided for @focus_session_label.
  ///
  /// In en, this message translates to:
  /// **'Focus session'**
  String get focus_session_label;

  /// No description provided for @focus_session_hint_idle.
  ///
  /// In en, this message translates to:
  /// **'Drag the dial to set the length'**
  String get focus_session_hint_idle;

  /// No description provided for @focus_session_hint_dragging.
  ///
  /// In en, this message translates to:
  /// **'Release to keep {minutes} min'**
  String focus_session_hint_dragging(int minutes);

  /// No description provided for @focus_session_ends_at.
  ///
  /// In en, this message translates to:
  /// **'ends {time}'**
  String focus_session_ends_at(String time);

  /// No description provided for @focus_session_no_end_time.
  ///
  /// In en, this message translates to:
  /// **'no end time'**
  String get focus_session_no_end_time;

  /// No description provided for @focus_session_open_end_symbol.
  ///
  /// In en, this message translates to:
  /// **'∞'**
  String get focus_session_open_end_symbol;

  /// No description provided for @focus_session_start.
  ///
  /// In en, this message translates to:
  /// **'Start focus'**
  String get focus_session_start;

  /// No description provided for @focus_session_pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get focus_session_pause;

  /// No description provided for @focus_session_resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get focus_session_resume;

  /// No description provided for @focus_session_stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get focus_session_stop;

  /// No description provided for @focus_session_stats.
  ///
  /// In en, this message translates to:
  /// **'{sessions, plural, =1{1 session today} other{{sessions} sessions today}} · {blocked} blocked'**
  String focus_session_stats(int sessions, int blocked);

  /// No description provided for @focus_preset_pomodoro.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro'**
  String get focus_preset_pomodoro;

  /// No description provided for @focus_preset_deep_work.
  ///
  /// In en, this message translates to:
  /// **'Deep work'**
  String get focus_preset_deep_work;

  /// No description provided for @focus_preset_long_haul.
  ///
  /// In en, this message translates to:
  /// **'Long haul'**
  String get focus_preset_long_haul;

  /// No description provided for @focus_preset_open_end.
  ///
  /// In en, this message translates to:
  /// **'Open end'**
  String get focus_preset_open_end;

  /// No description provided for @focus_preset_minutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String focus_preset_minutes(int minutes);

  /// No description provided for @focus_running_badge.
  ///
  /// In en, this message translates to:
  /// **'In focus'**
  String get focus_running_badge;

  /// No description provided for @blocker_label.
  ///
  /// In en, this message translates to:
  /// **'App blocker'**
  String get blocker_label;

  /// No description provided for @blocker_profile_label.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get blocker_profile_label;

  /// No description provided for @blocker_add_placeholder.
  ///
  /// In en, this message translates to:
  /// **'add app or domain'**
  String get blocker_add_placeholder;

  /// No description provided for @blocker_blocked_today_label.
  ///
  /// In en, this message translates to:
  /// **'Blocked today'**
  String get blocker_blocked_today_label;

  /// No description provided for @blocker_blocked_today_caption.
  ///
  /// In en, this message translates to:
  /// **'Attempts intercepted while a profile was armed.'**
  String get blocker_blocked_today_caption;

  /// No description provided for @project_editor_eyebrow.
  ///
  /// In en, this message translates to:
  /// **'Settings · Project'**
  String get project_editor_eyebrow;

  /// No description provided for @project_editor_title_new.
  ///
  /// In en, this message translates to:
  /// **'New project'**
  String get project_editor_title_new;

  /// No description provided for @project_editor_title_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit project'**
  String get project_editor_title_edit;

  /// No description provided for @project_editor_name_label.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get project_editor_name_label;

  /// No description provided for @project_editor_name_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Project name'**
  String get project_editor_name_placeholder;

  /// No description provided for @project_editor_untitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled project'**
  String get project_editor_untitled;

  /// No description provided for @project_editor_sources_label.
  ///
  /// In en, this message translates to:
  /// **'Apps & websites'**
  String get project_editor_sources_label;

  /// No description provided for @project_editor_choose_from_finder.
  ///
  /// In en, this message translates to:
  /// **'Choose from Finder…'**
  String get project_editor_choose_from_finder;

  /// No description provided for @project_editor_add_project.
  ///
  /// In en, this message translates to:
  /// **'Add project…'**
  String get project_editor_add_project;

  /// No description provided for @project_editor_use_current_arrangement.
  ///
  /// In en, this message translates to:
  /// **'Use current arrangement'**
  String get project_editor_use_current_arrangement;

  /// No description provided for @project_editor_arrange_on_screen.
  ///
  /// In en, this message translates to:
  /// **'Arrange on screen'**
  String get project_editor_arrange_on_screen;

  /// No description provided for @project_editor_capture_empty.
  ///
  /// In en, this message translates to:
  /// **'No windows to capture. Grant Accessibility access, or open the apps you want to save.'**
  String get project_editor_capture_empty;

  /// No description provided for @project_editor_website_placeholder.
  ///
  /// In en, this message translates to:
  /// **'example.com'**
  String get project_editor_website_placeholder;

  /// No description provided for @project_editor_layout_label.
  ///
  /// In en, this message translates to:
  /// **'Window layout'**
  String get project_editor_layout_label;

  /// No description provided for @project_editor_library_hint.
  ///
  /// In en, this message translates to:
  /// **'The apps a project can draw on. Which of them end up in the layout is settled in \"Arrange on screen\".'**
  String get project_editor_library_hint;

  /// No description provided for @project_editor_monitor_caption.
  ///
  /// In en, this message translates to:
  /// **'Monitor {index} · {inches}″'**
  String project_editor_monitor_caption(int index, String inches);

  /// No description provided for @project_editor_tile_size.
  ///
  /// In en, this message translates to:
  /// **'{width}×{height}'**
  String project_editor_tile_size(String width, String height);

  /// No description provided for @layout_overlay_save.
  ///
  /// In en, this message translates to:
  /// **'Save layout'**
  String get layout_overlay_save;

  /// No description provided for @layout_overlay_library_label.
  ///
  /// In en, this message translates to:
  /// **'Drag an app onto a screen'**
  String get layout_overlay_library_label;

  /// No description provided for @layout_overlay_hint.
  ///
  /// In en, this message translates to:
  /// **'Drag and resize at full size · ⌥ turns off snapping · ⏎ save · esc cancel'**
  String get layout_overlay_hint;

  /// No description provided for @profile_editor_eyebrow.
  ///
  /// In en, this message translates to:
  /// **'Settings · Profile'**
  String get profile_editor_eyebrow;

  /// No description provided for @profile_editor_title_new.
  ///
  /// In en, this message translates to:
  /// **'New profile'**
  String get profile_editor_title_new;

  /// No description provided for @profile_editor_title_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profile_editor_title_edit;

  /// No description provided for @profile_editor_name_label.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get profile_editor_name_label;

  /// No description provided for @profile_editor_name_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Profile name'**
  String get profile_editor_name_placeholder;

  /// No description provided for @profile_editor_untitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled profile'**
  String get profile_editor_untitled;

  /// No description provided for @profile_editor_items_label.
  ///
  /// In en, this message translates to:
  /// **'Blocked apps & sites'**
  String get profile_editor_items_label;

  /// No description provided for @profile_editor_add_entry.
  ///
  /// In en, this message translates to:
  /// **'+ Add entry'**
  String get profile_editor_add_entry;

  /// No description provided for @profile_editor_entry_placeholder.
  ///
  /// In en, this message translates to:
  /// **'app or domain'**
  String get profile_editor_entry_placeholder;

  /// No description provided for @blocked_page_eyebrow.
  ///
  /// In en, this message translates to:
  /// **'{target} is blocked · {profile}'**
  String blocked_page_eyebrow(String target, String profile);

  /// No description provided for @blocked_page_headline.
  ///
  /// In en, this message translates to:
  /// **'Session runs until {time}.'**
  String blocked_page_headline(String time);

  /// No description provided for @blocked_page_headline_open_end.
  ///
  /// In en, this message translates to:
  /// **'Session is running.'**
  String get blocked_page_headline_open_end;

  /// No description provided for @blocked_page_meta.
  ///
  /// In en, this message translates to:
  /// **'{project} · {profile} · {remaining} left'**
  String blocked_page_meta(String project, String profile, String remaining);

  /// No description provided for @blocked_page_back_to_work.
  ///
  /// In en, this message translates to:
  /// **'Back to work'**
  String get blocked_page_back_to_work;

  /// No description provided for @blocked_page_unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock {minutes} min · {left} left'**
  String blocked_page_unlock(int minutes, int left);

  /// No description provided for @permission_accessibility_title.
  ///
  /// In en, this message translates to:
  /// **'Accessibility permission required'**
  String get permission_accessibility_title;

  /// No description provided for @permission_accessibility_body.
  ///
  /// In en, this message translates to:
  /// **'Focus needs Accessibility access to move and resize the windows of other apps. Grant it in System Settings › Privacy & Security › Accessibility.'**
  String get permission_accessibility_body;

  /// No description provided for @permission_accessibility_open_settings.
  ///
  /// In en, this message translates to:
  /// **'Open System Settings'**
  String get permission_accessibility_open_settings;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
