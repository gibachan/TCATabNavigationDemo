import ComposableArchitecture
import SwiftUI

struct TabStateHolder<State, Action, Content: View>: View {
    @SwiftUI.State var store: Store<State, Action>
    let content: (Store<State, Action>) -> Content

    init(
        store: Store<State, Action>,
        @ViewBuilder content: @escaping (Store<State, Action>) -> Content
    ) {
        self.store = store
        self.content = content
    }

    var body: some View {
        self.content(self.store)
    }
}
