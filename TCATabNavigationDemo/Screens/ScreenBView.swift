import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct ScreenB {
    @ObservableState
    struct State: Equatable {
        let id: Int
        let items: [Int] = (0..<20).map { $0 }
    }

    enum Action {
        case navigateToC
    }

    var body: some ReducerOf<Self> {
        Reduce { _, _ in .none }
    }
}

struct ScreenBView: View {
    let store: StoreOf<ScreenB>

    var body: some View {
        List {
            ForEach(store.state.items, id: \.self) { item in
                NavigationLink(
                    "ScreenC of \(item)",
                    state: TabA.Path.State.screenC(ScreenC.State(id: item))
                )
            }
        }
        .navigationTitle("ScreenB of \(store.state.id)")
    }
}
