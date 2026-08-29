/// The page a blocked domain is redirected to, rendered by [BlockedPageServer].
///
/// Same tone and layout as the native blocked overlay used for apps — dark, calm,
/// "you're free of this one" rather than a punitive stop sign — but as a real page
/// inside the tab, so blocking a site never yanks focus over to this app the way
/// switching to a floating window would.
String blockedPageHtml({
  required String target,
  required String profileName,
  required int unlocksRemaining,
  required int unlockMinutes,
  required String returnUrl,
}) {
  final unlockHref =
      '/unlock?target=${Uri.encodeQueryComponent(target)}&returnUrl=${Uri.encodeQueryComponent(returnUrl)}';

  final unlockButton = unlocksRemaining > 0
      ? '<a class="unlock" href="$unlockHref">Unlock $unlockMinutes min · $unlocksRemaining left</a>'
      : '<span class="unlock unlock--spent">No unlocks left</span>';

  return '''
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Blocked</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500&family=JetBrains+Mono:wght@700;800&display=swap" rel="stylesheet">
<style>
  :root {
    color-scheme: dark;
  }
  * { box-sizing: border-box; }
  html, body {
    height: 100%;
    margin: 0;
  }
  body {
    background: #172554;
    color: #ffffff;
    font-family: 'Inter', -apple-system, sans-serif;
    display: flex;
    align-items: center;
    justify-content: center;
    text-align: center;
    padding: 24px;
  }
  .card {
    max-width: 480px;
  }
  /* Same easing as the rest of the app's design system (UiMotion.ease). */
  .enter {
    opacity: 0;
    animation: fadeUp 420ms cubic-bezier(0.4, 0, 0.2, 1) both;
  }
  @keyframes fadeUp {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
  }
  @keyframes breathe {
    0%, 100% { box-shadow: 0 0 0 0 rgba(37, 99, 235, 0.28); }
    50% { box-shadow: 0 0 0 8px rgba(37, 99, 235, 0); }
  }
  .icon {
    width: 44px;
    height: 44px;
    margin: 0 auto 24px;
    border-radius: 14px;
    background: rgba(37, 99, 235, 0.20);
    display: flex;
    align-items: center;
    justify-content: center;
    /* A slow, calm pulse — reinforces "you're free of this one" rather than nagging. */
    animation:
      fadeUp 420ms cubic-bezier(0.4, 0, 0.2, 1) both,
      breathe 2800ms cubic-bezier(0.4, 0, 0.2, 1) 420ms infinite;
  }
  .icon svg { width: 24px; height: 24px; }
  .eyebrow {
    font-family: 'JetBrains Mono', monospace;
    font-weight: 700;
    font-size: 11px;
    letter-spacing: 0.2em;
    color: #60a5fa;
    margin: 0 0 12px;
    animation-delay: 80ms;
  }
  h1 {
    font-family: 'JetBrains Mono', monospace;
    font-weight: 800;
    font-size: 26px;
    letter-spacing: -0.02em;
    margin: 0 0 12px;
    animation-delay: 140ms;
  }
  .meta {
    font-size: 13px;
    color: rgba(255, 255, 255, 0.7);
    margin: 0 0 32px;
    animation-delay: 200ms;
  }
  .unlock {
    display: inline-block;
    padding: 13px 28px;
    border-radius: 12px;
    border: 1px solid rgba(255, 255, 255, 0.16);
    color: #ffffff;
    font-family: 'Inter', sans-serif;
    font-size: 14px;
    font-weight: 500;
    text-decoration: none;
    transition: border-color 120ms ease, background 120ms ease;
    animation-delay: 260ms;
  }
  .unlock:hover {
    border-color: rgba(255, 255, 255, 0.40);
    background: rgba(255, 255, 255, 0.04);
  }
  .unlock--spent {
    color: rgba(255, 255, 255, 0.35);
    cursor: default;
  }
</style>
</head>
<body>
  <div class="card">
    <div class="icon">
      <svg viewBox="0 0 24 24" fill="none" stroke="#60a5fa" stroke-width="2" stroke-linecap="round">
        <circle cx="12" cy="12" r="9"/>
        <line x1="5.6" y1="5.6" x2="18.4" y2="18.4"/>
      </svg>
    </div>
    <p class="eyebrow enter">$target IS BLOCKED · $profileName</p>
    <h1 class="enter">You're free of this one.</h1>
    <p class="meta enter">Blocked while $profileName runs. Close the tab, or use an unlock below.</p>
    <div class="enter">$unlockButton</div>
  </div>
</body>
</html>
''';
}
