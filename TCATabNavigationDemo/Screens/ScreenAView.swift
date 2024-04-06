import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct ScreenA {
    @ObservableState
    struct State: Equatable {
        let id: Int
        let items: [Int] = (0..<20).map { $0 }
    }

    enum Action {
        case navigateToB(Int)
    }

    var body: some ReducerOf<Self> {
        Reduce { _, _ in .none }
    }
}

struct ScreenAView: View {
    let store: StoreOf<ScreenA>

    var body: some View {
        List {
            ForEach(store.state.items, id: \.self) { item in
                NavigationLink(
                    "ScreenB of \(item)",
                    state: TabA.Path.State.screenB(ScreenB.State(id: item))
                )
            }
        }
        .listStyle(.plain)
        .navigationTitle("ScreenA of \(store.state.id)")
    }
}
