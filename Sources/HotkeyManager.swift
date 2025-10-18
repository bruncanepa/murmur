import Cocoa
import Carbon

class HotkeyManager {
    private var globalMonitor: Any?
    private var localMonitor: Any?
    private var onKeyDown: (() -> Void)?
    private var onKeyUp: (() -> Void)?
    private var isKeyPressed = false
    private var lastEventTime: TimeInterval = 0
    private let debounceInterval: TimeInterval = 0.05 // 50ms debounce
    private let eventLock = NSLock()

    func register(onKeyDown: @escaping () -> Void, onKeyUp: @escaping () -> Void) {
        self.onKeyDown = onKeyDown
        self.onKeyUp = onKeyUp

        // Monitor for right Command key (keyCode 54)
        // We use NSEvent.addGlobalMonitorForEvents for system-wide monitoring
        // and NSEvent.addLocalMonitorForEvents for app-specific monitoring

        // Global monitor for when app is in background
        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.flagsChanged]) { [weak self] event in
            self?.handleFlagsChanged(event)
        }

        // Local monitor for when app is active
        localMonitor = NSEvent.addLocalMonitorForEvents(matching: [.flagsChanged]) { [weak self] event in
            self?.handleFlagsChanged(event)
            return event
        }
    }

    private func handleFlagsChanged(_ event: NSEvent) {
        // Wrap in error handling to prevent crashes
        eventLock.lock()
        defer { eventLock.unlock() }

        // Debounce rapid events
        let currentTime = Date().timeIntervalSince1970
        guard currentTime - lastEventTime >= debounceInterval else { return }
        lastEventTime = currentTime

        // Right Command key code is 54
        let rightCommandKeyCode: UInt16 = 54

        // Validate event integrity before accessing properties
        guard event.type == .flagsChanged else { return }

        // Check if the event is specifically for the right Command key
        guard event.keyCode == rightCommandKeyCode else { return }

        // Check if right Command is pressed
        let rightCommandPressed = event.modifierFlags.contains(.command)

        if rightCommandPressed && !isKeyPressed {
            // Key was just pressed down
            isKeyPressed = true
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                // Verify app is still active before triggering
                if NSApp.isActive || NSApp.activationPolicy() == .accessory {
                    self.onKeyDown?()
                }
            }
        } else if !rightCommandPressed && isKeyPressed {
            // Key was just released
            isKeyPressed = false
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                // Always trigger key up regardless of app state
                self.onKeyUp?()
            }
        }
    }

    func unregister() {
        eventLock.lock()
        defer { eventLock.unlock() }

        if let global = globalMonitor {
            NSEvent.removeMonitor(global)
            globalMonitor = nil
        }
        if let local = localMonitor {
            NSEvent.removeMonitor(local)
            localMonitor = nil
        }
    }

    deinit {
        unregister()
    }
}
