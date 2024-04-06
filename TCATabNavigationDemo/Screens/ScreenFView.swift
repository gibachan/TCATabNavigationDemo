import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct ScreenF {
    @ObservableState
    struct State: Equatable {
        let id: String
    }

    enum Action {
        case popToRoot
    }

    var body: some ReducerOf<Self> {
        Reduce { _, _ in .none }
    }
}

struct ScreenFView: View {
    let store: StoreOf<ScreenF>

    var body: some View {
        Button {
            store.send(.popToRoot)
        } label: {
            Text("Pop to root")
        }
        .navigationTitle("ScreenF of \(store.state.id)")
    }
}
