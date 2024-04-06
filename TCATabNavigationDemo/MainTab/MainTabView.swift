import ComposableArchitecture
import Dependencies
import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = Tab.tabA.rawValue

    private var tabSelection: Binding<Int> { Binding(
        get: { self.selectedTab },
        set: {
            if self.selectedTab == $0 {
                switch $0 {
                case Tab.tabA.rawValue:
                    NotificationCenter.default.post(name: .tapTabA, object: nil)
                case Tab.tabB.rawValue:
                    NotificationCenter.default.post(name: .tapTabB, object: nil)
                default:
                    break
                }
            }
            self.selectedTab = $0
        }
    )}

    var body: some View {
        TabView(selection: tabSelection) {
            TabStateHolder(store: Store(initialState: TabA.State()) { TabA() }) { store in
                TabAView(store: store)
            }
            .tabItem {
                Image(systemName: "a.square")
                Text("TabA")
            }
            .tag(Tab.tabA.rawValue)
            
            TabStateHolder(store: Store(initialState: TabB.State()) { TabB() }) { store in
                TabBView(store: store)
            }
            .tabItem {
                Image(systemName: "b.square")
                Text("TabB")
            }
            .tag(Tab.tabB.rawValue)
        }
    }
}

private extension MainTabView {
    enum Tab: Int {
        case tabA
        case tabB
    }
}

#Preview {
    MainTabView()
}
