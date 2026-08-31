import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/focus/repository/focus_session.repository.dart';
import 'package:workspace_flow/domain/focus/model/focus_stats.dart';

part 'focus_stats.service.g.dart';

/// The two counters shown in the UI: sessions finished today and attempts blocked today.
///
/// Both are queried rather than counted in memory, so they survive a restart and roll
/// over at midnight on their own.
@Riverpod(keepAlive: true)
Stream<FocusStats> focusStats(Ref ref) {
  final repository = ref.watch(focusSessionRepositoryProvider);

  return repository.watchSessionsToday().asyncMap((int sessions) async {
    final blocked = await repository.watchBlockedAttemptsToday().first;
    return FocusStats(sessionsToday: sessions, blockedToday: blocked);
  });
}
