import ComposableArchitecture

// https://github.com/pointfreeco/swift-composable-architecture/pull/2906
typealias StackActionOf<R: Reducer> = StackAction<R.State, R.Action>
