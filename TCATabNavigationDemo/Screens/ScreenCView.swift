import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct ScreenC {
    @ObservableState
    struct State: Equatable {
        var id: Int
    }

    enum Action {
    }

    var body: some ReducerOf<Self> {
        Reduce { _, _ in .none }
    }
}

struct ScreenCView: View {
    let store: StoreOf<ScreenC>

    var body: some View {
        Text("Reached at the end of TabA")
            .navigationTitle("ScreenC of \(store.state.id)")
    }
}
