import ComposableArchitecture
import SwiftUI

@Reducer
struct TabA {
    @Dependency(\.tapTabA) var tapTabA

    @Reducer(state: .equatable)
    enum Path {
        case screenA(ScreenA)
        case screenB(ScreenB)
        case screenC(ScreenC)
    }

    @ObservableState
    struct State: Equatable {
        let items: [Int] = (0..<20).map { $0 }
        var path = StackState<Path.State>()
    }

    enum Action: ViewAction {
        case view(View)
        case path(StackActionOf<Path>)
        case tapTab

        enum View {
            case onAppear
            case onDisappear
        }
    }

    private enum CancelID {
        case tapTab
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .run { send in
                    let stream = await tapTabA()
                    await withTaskGroup(of: Void.self) { group in
                        for await _ in stream {
                            group.addTask { await send(.tapTab) }
                        }
                    }
                }
                .cancellable(id: CancelID.tapTab)
            case .view(.onDisappear):
                return .cancel(id: CancelID.tapTab)
            case .path:
                return .none
            case .tapTab:
                if state.path.isEmpty {
                    NotificationCenter.default.post(name: .scrollToTop, object: nil)
                } else {
                    state.path.removeAll()
                }
                return .none
            }
        }
        .forEach(\.path, action: \.path)
        ._printChanges()
    }
}

@ViewAction(for: TabA.self)
struct TabAView: View {
    @Bindable var store: StoreOf<TabA>

    init(store: StoreOf<TabA>) {
        self.store = store
    }
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            ScrollViewReader { scrollProxy in
                List {
                    ForEach(store.state.items, id: \.self) { item in
                        NavigationLink("ScreenA of \(item)",
                                       state: TabA.Path.State.screenA(ScreenA.State(id: item))
                        )
                        .id(item)
                    }
                }
                .listStyle(.plain)
                .onReceive(NotificationCenter.default.publisher(for: .scrollToTop)) { _ in
                    withAnimation {
                        scrollProxy.scrollTo(0)
                    }
                }
            }
            .navigationTitle("TabA")
        } destination: { store in
            switch store.case {
            case let .screenA(store):
                ScreenAView(store: store)
            case let .screenB(store):
                ScreenBView(store: store)
            case let .screenC(store):
                ScreenCView(store: store)
            }
        }
        .onAppear {
            send(.onAppear)
        }
        .onDisappear {
            send(.onDisappear)
        }
    }
}
