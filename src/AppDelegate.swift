import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            window.titlebarAppearsTransparent = true
            window.titleVisibility = .hidden
            window.isOpaque = false
            window.backgroundColor = .clear
            window.styleMask = [.borderless, .resizable, .fullSizeContentView]
            window.level = .floating
            window.setFrame(NSScreen.main?.frame ?? NSRect.zero, display: true)
        }
    }
}
