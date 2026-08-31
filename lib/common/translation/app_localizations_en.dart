// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get common_save => 'Save';

  @override
  String get common_cancel => 'Cancel';

  @override
  String get common_delete => 'Delete';

  @override
  String get common_add => 'Add';

  @override
  String get common_edit => 'Edit';

  @override
  String get common_new => '+ New';

  @override
  String get common_kind_site => 'site';

  @override
  String get common_kind_app => 'app';

  @override
  String window_title_idle(String projectName) {
    return 'Focus — $projectName';
  }

  @override
  String get window_title_running => 'In focus';

  @override
  String get projects_label => 'Projects';

  @override
  String projects_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count apps · saved layout',
      one: '1 app · saved layout',
    );
    return '$_temp0';
  }

  @override
  String get projects_footer_hint =>
      'A project is a saved window layout. Launching it opens the same apps in the same places, every time.';

  @override
  String get workspace_launch => 'Launch workspace';

  @override
  String get workspace_launching => 'Opening…';

  @override
  String get workspace_rearrange => 'Re-arrange';

  @override
  String get workspace_window_state_pending => '—';

  @override
  String get workspace_window_state_opening => 'opening…';

  @override
  String get workspace_window_state_open => 'open';

  @override
  String get workspace_window_state_failed => 'failed';

  @override
  String get focus_session_label => 'Focus session';

  @override
  String get focus_session_hint_idle => 'Drag the dial to set the length';

  @override
  String focus_session_hint_dragging(int minutes) {
    return 'Release to keep $minutes min';
  }

  @override
  String focus_session_ends_at(String time) {
    return 'ends $time';
  }

  @override
  String get focus_session_no_end_time => 'no end time';

  @override
  String get focus_session_open_end_symbol => '∞';

  @override
  String get focus_session_start => 'Start focus';

  @override
  String get focus_session_pause => 'Pause';

  @override
  String get focus_session_resume => 'Resume';

  @override
  String get focus_session_stop => 'Stop';

  @override
  String focus_session_stats(int sessions, int blocked) {
    String _temp0 = intl.Intl.pluralLogic(
      sessions,
      locale: localeName,
      other: '$sessions sessions today',
      one: '1 session today',
    );
    return '$_temp0 · $blocked blocked';
  }

  @override
  String get focus_preset_pomodoro => 'Pomodoro';

  @override
  String get focus_preset_deep_work => 'Deep work';

  @override
  String get focus_preset_long_haul => 'Long haul';

  @override
  String get focus_preset_open_end => 'Open end';

  @override
  String focus_preset_minutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get focus_running_badge => 'In focus';

  @override
  String get blocker_label => 'App blocker';

  @override
  String get blocker_profile_label => 'Profile';

  @override
  String get blocker_blocked_today_label => 'Blocked today';

  @override
  String get blocker_blocked_today_caption => 'Attempts intercepted while a profile was armed.';

  @override
  String get blocker_error_arm_failed => 'Couldn\'t arm the blocker. Please try again.';

  @override
  String get blocker_error_disarm_failed => 'Couldn\'t fully disarm the blocker. Please try again.';

  @override
  String get blocker_error_site_permission_denied =>
      'Site blocking needs permission for a browser — check System Settings › Privacy & Security › Automation.';

  @override
  String get project_editor_eyebrow => 'Settings · Project';

  @override
  String get project_editor_title_new => 'New project';

  @override
  String get project_editor_title_edit => 'Edit project';

  @override
  String get project_editor_name_label => 'Name';

  @override
  String get project_editor_name_placeholder => 'Project name';

  @override
  String get project_editor_untitled => 'Untitled project';

  @override
  String get project_editor_sources_label => 'Apps & websites';

  @override
  String get project_editor_choose_from_finder => 'Choose from Finder…';

  @override
  String get project_editor_add_project => 'Add project…';

  @override
  String get project_editor_use_current_arrangement => 'Use current arrangement';

  @override
  String get project_editor_arrange_on_screen => 'Arrange on screen';

  @override
  String get project_editor_capture_empty =>
      'No windows to capture. Grant Accessibility access, or open the apps you want to save.';

  @override
  String get project_editor_website_placeholder => 'example.com';

  @override
  String get project_editor_layout_label => 'Window layout';

  @override
  String get project_editor_library_hint =>
      'The apps a project can draw on. Which of them end up in the layout is settled in \"Arrange on screen\".';

  @override
  String project_editor_monitor_caption(int index, String inches) {
    return 'Monitor $index · $inches″';
  }

  @override
  String project_editor_tile_size(String width, String height) {
    return '$width×$height';
  }

  @override
  String get layout_overlay_save => 'Save layout';

  @override
  String get layout_overlay_library_label => 'Drag an app onto a screen';

  @override
  String get layout_overlay_hint => 'Drag and resize at full size · ⌥ turns off snapping · ⏎ save · esc cancel';

  @override
  String get profile_editor_eyebrow => 'Settings · Profile';

  @override
  String get profile_editor_title_new => 'New profile';

  @override
  String get profile_editor_title_edit => 'Edit profile';

  @override
  String get profile_editor_name_label => 'Name';

  @override
  String get profile_editor_name_placeholder => 'Profile name';

  @override
  String get profile_editor_untitled => 'Untitled profile';

  @override
  String get profile_editor_items_label => 'Blocked apps & sites';

  @override
  String get profile_editor_choose_app => 'Choose app…';

  @override
  String get profile_editor_entry_placeholder => 'app or domain';

  @override
  String get profile_editor_website_placeholder => 'example.com';

  @override
  String blocked_page_eyebrow(String target, String profile) {
    return '$target is blocked · $profile';
  }

  @override
  String blocked_page_headline(String time) {
    return 'Session runs until $time.';
  }

  @override
  String get blocked_page_headline_open_end => 'Session is running.';

  @override
  String blocked_page_meta(String project, String profile, String remaining) {
    return '$project · $profile · $remaining left';
  }

  @override
  String get blocked_page_back_to_work => 'Back to work';

  @override
  String blocked_page_unlock(int minutes, int left) {
    return 'Unlock $minutes min · $left left';
  }

  @override
  String get permission_accessibility_title => 'Accessibility permission required';

  @override
  String get permission_accessibility_body =>
      'Focus needs Accessibility access to move and resize the windows of other apps. Grant it in System Settings › Privacy & Security › Accessibility.';

  @override
  String get permission_accessibility_open_settings => 'Open System Settings';
}
