/// Manually maintained donation progress, shown on the donate screen.
///
/// There's no backend, so these numbers are edited by hand and shipped in
/// a new build whenever they change — no automatic sync with Buy Me a
/// Coffee (its API needs a secret key, which can't safely live in a
/// client app).
class DonationConfig {
  const DonationConfig._();

  /// One-time goal: reimburses the Google Play developer registration
  /// fee. Never resets once reached.
  static const googleGoalEuros = 25.0;
  static const googleRaisedEuros = 0.0;

  /// Annual goal: covers the Apple Developer Program's yearly fee, so the
  /// app can keep being republished on the App Store.
  static const appleGoalEuros = 100.0;
  static const appleRaisedEuros = 0.0;

  /// The date of the first Apple Developer Program payment. The Apple
  /// goal's progress resets on each yearly anniversary of this date.
  static final appleFirstPaymentDate = DateTime(2026, 9, 21);

  /// When [appleRaisedEuros] was last updated by hand.
  static final appleRaisedUpdatedAt = DateTime(2026, 9, 21);

  /// The most recent anniversary of [appleFirstPaymentDate] that is on or
  /// before [now].
  static DateTime _lastAnniversary(DateTime now) {
    var anniversary = DateTime(
      now.year,
      appleFirstPaymentDate.month,
      appleFirstPaymentDate.day,
    );
    if (anniversary.isAfter(now)) {
      anniversary = DateTime(
        now.year - 1,
        appleFirstPaymentDate.month,
        appleFirstPaymentDate.day,
      );
    }
    return anniversary;
  }

  /// The Apple goal's progress for the current yearly cycle: 0 once a new
  /// cycle has started since [appleRaisedUpdatedAt], even if the raised
  /// amount hasn't been manually reset yet.
  static double appleRaisedForCurrentCycle([DateTime? now]) {
    final currentTime = now ?? DateTime.now();
    final cycleStart = _lastAnniversary(currentTime);
    return appleRaisedUpdatedAt.isBefore(cycleStart) ? 0 : appleRaisedEuros;
  }
}
