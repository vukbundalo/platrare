import Foundation

/// What the Numbers widget renders for one timeline entry.
struct ResolvedMetric {
    let label: String
    let valueText: String
    /// Secondary line: the date a trough lands on, the horizon, or an account
    /// name. Empty when there is nothing useful to add.
    let subLabel: String
    /// Series for the sparkline, in the snapshot's base currency (or the
    /// account's own currency for the account metric).
    let series: [Double]
    /// Index within `series` worth marking (the trough), if any.
    let markerIndex: Int?
    let rawValue: Double
    /// Used only for the circular accessory gauge.
    let gaugeRange: ClosedRange<Double>?
    let gaugeValue: Double?
}

@available(iOS 17.0, *)
enum MetricResolver {

    /// Resolves the configured metric against the snapshot as of `dayIndex`.
    ///
    /// `dayIndex` is the timeline entry's position in the 35-day series, which
    /// is what lets the widget roll over daily with the app never running.
    static func resolve(
        snapshot: Snapshot,
        metric: PlatrareMetric,
        horizon: PlatrareHorizon,
        accountId: String?,
        dayIndex: Int
    ) -> ResolvedMetric {
        let days = snapshot.series.days
        let i = max(0, min(dayIndex, days.count - 1))

        switch metric {
        case .spendableNow:
            return ResolvedMetric(
                label: snapshot.string("spendableNow"),
                valueText: AmountFormatter.display(
                    days[i].sp, snapshot: snapshot, preformatted: days[i].spText),
                subLabel: "",
                series: days.map(\.sp),
                markerIndex: nil,
                rawValue: days[i].sp,
                gaugeRange: nil,
                gaugeValue: nil
            )

        case .netWorth:
            return ResolvedMetric(
                label: snapshot.string("netWorth"),
                valueText: AmountFormatter.display(
                    days[i].nw, snapshot: snapshot, preformatted: days[i].nwText),
                subLabel: "",
                series: days.map(\.nw),
                markerIndex: nil,
                rawValue: days[i].nw,
                gaugeRange: nil,
                gaugeValue: nil
            )

        case .lowestPoint:
            // Recompute the trough from `i` forward rather than reusing
            // `derived.lowestSpendable`, whose window starts at the snapshot's
            // generation day. On a later timeline entry, days already past
            // must not still count as "upcoming".
            let end = max(i, snapshot.derived.endOfMonthIndex)
            var bestIndex = i
            var best = days[i].sp
            if end > i {
                for k in i...end where days[k].sp < best {
                    best = days[k].sp
                    bestIndex = k
                }
            }
            let onDate = bestIndex == i ? snapshot.string("horizonToday") : days[bestIndex].dLabel
            return ResolvedMetric(
                label: snapshot.string("lowestPoint"),
                valueText: AmountFormatter.display(best, snapshot: snapshot),
                subLabel: onDate,
                series: Array(days[i...end].map(\.sp)),
                markerIndex: bestIndex - i,
                rawValue: best,
                // Gauge runs from the trough up to today's figure, so the fill
                // reads as "how much headroom before the low point".
                gaugeRange: min(best, days[i].sp)...max(best, days[i].sp, best + 1),
                gaugeValue: days[i].sp
            )

        case .projected:
            let target: Int
            switch horizon {
            case .endOfToday: target = i
            case .plus7d:     target = min(i + 7, days.count - 1)
            case .endOfMonth: target = max(i, snapshot.derived.endOfMonthIndex)
            }
            let horizonLabel: String
            switch horizon {
            case .endOfToday: horizonLabel = snapshot.string("horizonToday")
            case .plus7d:     horizonLabel = snapshot.string("horizon7d")
            case .endOfMonth: horizonLabel = snapshot.string("horizonEndOfMonth")
            }
            return ResolvedMetric(
                label: snapshot.string("projected"),
                valueText: AmountFormatter.display(days[target].sp, snapshot: snapshot),
                subLabel: "\(horizonLabel) · \(days[target].dLabel)",
                series: Array(days[i...max(i, target)].map(\.sp)),
                markerIndex: nil,
                rawValue: days[target].sp,
                gaugeRange: nil,
                gaugeValue: nil
            )

        case .account:
            guard let accountId,
                  let acct = snapshot.accounts.first(where: { $0.id == accountId }),
                  i < acct.series.count
            else {
                // Configured account was deleted or archived: fall back rather
                // than rendering a blank tile.
                return resolve(snapshot: snapshot, metric: .spendableNow,
                               horizon: horizon, accountId: nil, dayIndex: dayIndex)
            }
            let v = acct.series[i]
            return ResolvedMetric(
                label: acct.displayName,
                valueText: snapshot.maskAmounts
                    ? snapshot.maskPlaceholder
                    : AmountFormatter.format(v, digits: acct.digits, symbol: acct.symbol),
                subLabel: acct.currency,
                series: acct.series,
                markerIndex: nil,
                rawValue: v,
                gaugeRange: nil,
                gaugeValue: nil
            )
        }
    }

    /// Deep link for tapping the widget: the account metric jumps straight to
    /// that account's transactions, everything else opens the Plan tab where
    /// the same projections live.
    static func url(metric: PlatrareMetric, accountId: String?) -> URL? {
        switch metric {
        case .account:
            guard let accountId else { return URL(string: PlatrareLink.openTab("plan", src: "widget")) }
            return URL(string: PlatrareLink.account(accountId, src: "widget"))
        default:
            return URL(string: PlatrareLink.openTab("plan", src: "widget"))
        }
    }
}
