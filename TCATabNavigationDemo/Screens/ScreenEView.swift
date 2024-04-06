import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct ScreenE {
    @ObservableState
    struct State: Equatable {
        let id: String
    }

    enum Action {
        case navigateToScreenF(String)
    }

    var body: some ReducerOf<Self> {
        Reduce { _, _ in .none }
    }
}

struct ScreenEView: View {
    let store: StoreOf<ScreenE>

    var body: some View {
        Button {
            store.send(.navigateToScreenF("c"))
        } label: {
            Text("Navigate to ScreenF")
        }
        .navigationTitle("ScreenE of \(store.state.id)")
    }
}
