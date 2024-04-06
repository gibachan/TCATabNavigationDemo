import Dependencies
import Foundation

extension DependencyValues {
    var tapTabA: @Sendable () async -> AsyncStream<Void> {
        get { self[TapTabAKey.self] }
        set { self[TapTabAKey.self] = newValue }
    }
    
    private enum TapTabAKey: DependencyKey {
        static let liveValue: @Sendable () async -> AsyncStream<Void> = {
            AsyncStream(
                NotificationCenter.default.notifications(named: .tapTabA)
                    .map { _ in }
            )
        }
    }
}

extension DependencyValues {
    var tapTabB: @Sendable () async -> AsyncStream<Void> {
        get { self[TapTabBKey.self] }
        set { self[TapTabBKey.self] = newValue }
    }

    private enum TapTabBKey: DependencyKey {
        static let liveValue: @Sendable () async -> AsyncStream<Void> = {
            AsyncStream(
                NotificationCenter.default.notifications(named: .tapTabB)
                    .map { _ in }
            )
        }
    }
}
