import Cocoa
import Carbon

class HotkeyManager {
    private var eventMonitor: Any?
    private var onKeyDown: (() -> Void)?
    private var onKeyUp: (() -> Void)?
    private var isKeyPressed = false

    func register(onKeyDown: @escaping () -> Void, onKeyUp: @escaping () -> Void) {
        self.onKeyDown = onKeyDown
        self.onKeyUp = onKeyUp

        // Monitor for right Command key (keyCode 54)
        // We use NSEvent.addGlobalMonitorForEvents for system-wide monitoring
        // and NSEvent.addLocalMonitorForEvents for app-specific monitoring

        // Global monitor for when app is in background
        let globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.flagsChanged]) { [weak self] event in
            self?.handleFlagsChanged(event)
        }

        // Local monitor for when app is active
        let localMonitor = NSEvent.addLocalMonitorForEvents(matching: [.flagsChanged]) { [weak self] event in
            self?.handleFlagsChanged(event)
            return event
        }

        eventMonitor = (globalMonitor, localMonitor)
    }

    private func handleFlagsChanged(_ event: NSEvent) {
        // Right Command key code is 54
        let rightCommandKeyCode: UInt16 = 54

        // Check if the event is specifically for the right Command key
        guard event.keyCode == rightCommandKeyCode else { return }

        // Check if right Command is pressed
        let rightCommandPressed = event.modifierFlags.contains(.command)

        if rightCommandPressed && !isKeyPressed {
            // Key was just pressed down
            isKeyPressed = true
            DispatchQueue.main.async { [weak self] in
                self?.onKeyDown?()
            }
        } else if !rightCommandPressed && isKeyPressed {
            // Key was just released
            isKeyPressed = false
            DispatchQueue.main.async { [weak self] in
                self?.onKeyUp?()
            }
        }
    }

    func unregister() {
        if let monitors = eventMonitor as? (Any?, Any?) {
            if let global = monitors.0 {
                NSEvent.removeMonitor(global)
            }
            if let local = monitors.1 {
                NSEvent.removeMonitor(local)
            }
        }
        eventMonitor = nil
    }

    deinit {
        unregister()
    }
}
