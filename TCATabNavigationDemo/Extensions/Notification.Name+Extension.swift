import Foundation

extension Notification.Name {
    /// Posted when the TabA is on its active state.
    static let tapTabA: Notification.Name = .init(rawValue: "tap_tab_a")
    /// Posted when the TabB is on its active state.
    static let tapTabB: Notification.Name = .init(rawValue: "tap_tab_b")
    /// Posted when you need to scroll the list back to the top.
    static let scrollToTop: Notification.Name = .init(rawValue: "scroll_to_top")
}
