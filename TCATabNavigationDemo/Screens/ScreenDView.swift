import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct ScreenD {
    @ObservableState
    struct State: Equatable {
        let id: String
    }

    enum Action {
        case navigateToScreenE(String)
    }

    var body: some ReducerOf<Self> {
        Reduce { _, _ in .none }
    }
}

struct ScreenDView: View {
    let store: StoreOf<ScreenD>

    var body: some View {
        Button {
            store.send(.navigateToScreenE("b"))
        } label: {
            Text("Navigate to ScreenE")
        }
        .navigationTitle("ScreenD of \(store.state.id)")
    }
}
