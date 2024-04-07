import ComposableArchitecture
@testable import TCATabNavigationDemo
import XCTest

final class TabATests: XCTestCase {
    @MainActor
    func testScrollToTopNotificationDeliveredWhenpActiveTapIsTappedWithEmptyNavigationStack() async throws {
        let emptyStackPath: StackState<TabA.Path.State> = .init()
        let store = TestStore(initialState: TabA.State(path: emptyStackPath)) {
            TabA()
        } withDependencies: {
            $0.tapTabA = {
                AsyncStream(
                    NotificationCenter.default.notifications(named: .tapTabA)
                        .map { _ in }
                )
            }
        }
        let expectation = expectation(forNotification: .scrollToTop, object: nil)

        await store.send(.view(.onAppear))
        NotificationCenter.default.post(name: .tapTabA, object: nil)
        await store.receive(\.tapTab)
        await store.send(.view(.onDisappear))

        await fulfillment(of: [expectation], timeout: 1.0)
    }

    @MainActor
    func testNavigationStackIsClearedWhenActiveTapIsTappedWithSomeNavigationStack() async throws {
        let someSatckPath: StackState<TabA.Path.State> = .init([.screenA(ScreenA.State(id: 1))])
        let store = TestStore(initialState: TabA.State(path: someSatckPath)) {
            TabA()
        } withDependencies: {
            $0.tapTabA = {
                AsyncStream(
                    NotificationCenter.default.notifications(named: .tapTabA)
                        .map { _ in }
                )
            }
        }

        await store.send(.view(.onAppear))
        NotificationCenter.default.post(name: .tapTabA, object: nil)
        await store.receive(\.tapTab) {
            $0.path = .init()
        }
        await store.send(.view(.onDisappear))
    }
}
