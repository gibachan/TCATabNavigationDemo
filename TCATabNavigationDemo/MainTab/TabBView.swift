import ComposableArchitecture
import SwiftUI

@Reducer
struct TabB {
    @Dependency(\.tapTabB) var tapTabB

    @Reducer(state: .equatable)
    enum Path {
        case screenD(ScreenD)
        case screenE(ScreenE)
        case screenF(ScreenF)
    }

    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
    }

    enum Action: ViewAction {
        case view(View)
        case path(StackActionOf<Path>)
        case tapTab

        enum View {
            case onAppear
            case onDisappear
            case navigateToD(String)
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
                    let stream = await tapTabB()
                    await withTaskGroup(of: Void.self) { group in
                        for await _ in stream {
                            group.addTask { await send(.tapTab) }
                        }
                    }
                }
                .cancellable(id: CancelID.tapTab)
            case .view(.onDisappear):
                return .cancel(id: CancelID.tapTab)
            case .view(.navigateToD(let id)):
                state.path.append(.screenD(ScreenD.State(id: id)))
                return .none
            case let .path(action):
                switch action {
                case .element(id: _, action: .screenD(.navigateToScreenE(let id))):
                    state.path.append(.screenE(ScreenE.State(id: id)))
                    return .none
                case .element(id: _, action: .screenE(.navigateToScreenF(let id))):
                    state.path.append(.screenF(ScreenF.State(id: id)))
                    return .none
                case .element(id: _, action: .screenF(.popToRoot)):
                    state.path.removeAll()
                    return .none
                default:
                    return .none
                }
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

@ViewAction(for: TabB.self)
struct TabBView: View {
    @Bindable var store: StoreOf<TabB>
    @Namespace private var topID

    init(store: StoreOf<TabB>) {
        self.store = store
    }

    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            ScrollViewReader { scrollProxy in
                List {
                    Section {
                        ForEach(0..<10) { index in
                            Text("Dummy Item \(index)")
                        }
                    }
                    .id(topID)

                    Button {
                        send(.navigateToD("a"))
                    } label: {
                        Text("Navigate to ScreenD")
                    }

                    Section {
                        ForEach(0..<10) { index in
                            Text("Dummy Item \(index)")
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .onReceive(NotificationCenter.default.publisher(for: .scrollToTop)) { _ in
                    withAnimation {
                        scrollProxy.scrollTo(topID, anchor: UnitPoint(x: 0, y: 1))
                    }
                }
            }
            .navigationTitle("TabB")
        } destination: { store in
            switch store.case {
            case let .screenD(store):
                ScreenDView(store: store)
            case let .screenE(store):
                ScreenEView(store: store)
            case let .screenF(store):
                ScreenFView(store: store)
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
