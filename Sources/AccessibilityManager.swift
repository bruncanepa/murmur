import Cocoa
import ApplicationServices

class AccessibilityManager {

    // Check if we have accessibility permissions
    static func hasAccessibilityPermission() -> Bool {
        return AXIsProcessTrusted()
    }

    // Request accessibility permissions
    static func requestAccessibilityPermission() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        AXIsProcessTrustedWithOptions(options as CFDictionary)
    }

    // Type text into the currently focused application
    static func typeText(_ text: String) {
        guard hasAccessibilityPermission() else {
            print("No accessibility permission - requesting...")
            requestAccessibilityPermission()
            return
        }

        // Get the currently focused application
        guard let focusedApp = NSWorkspace.shared.frontmostApplication else {
            print("No focused application found")
            return
        }

        // Use CGEvent to simulate typing
        let source = CGEventSource(stateID: .hidSystemState)

        // Type each character
        for character in text {
            if let unicodeScalar = character.unicodeScalars.first {
                let unicodeValue = UInt16(unicodeScalar.value)

                // Create key down event
                if let keyDownEvent = CGEvent(keyboardEventSource: source, virtualKey: 0, keyDown: true) {
                    keyDownEvent.keyboardSetUnicodeString(stringLength: 1, unicodeString: [unicodeValue])
                    keyDownEvent.post(tap: .cghidEventTap)
                }

                // Create key up event
                if let keyUpEvent = CGEvent(keyboardEventSource: source, virtualKey: 0, keyDown: false) {
                    keyUpEvent.keyboardSetUnicodeString(stringLength: 1, unicodeString: [unicodeValue])
                    keyUpEvent.post(tap: .cghidEventTap)
                }

                // Small delay between characters for reliability
                usleep(1000) // 1ms delay
            }
        }
    }

    // Paste text using Cmd+V (alternative method)
    static func pasteText(_ text: String) {
        guard hasAccessibilityPermission() else {
            print("No accessibility permission - requesting...")
            requestAccessibilityPermission()
            return
        }

        // Save current clipboard
        let pasteboard = NSPasteboard.general
        let previousContents = pasteboard.pasteboardItems

        // Set our text to clipboard
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)

        // Simulate Cmd+V
        let source = CGEventSource(stateID: .hidSystemState)

        // Key down for Cmd
        let cmdDown = CGEvent(keyboardEventSource: source, virtualKey: 0x37, keyDown: true) // 0x37 is Command key
        cmdDown?.flags = .maskCommand
        cmdDown?.post(tap: .cghidEventTap)

        // Key down for V
        let vDown = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: true) // 0x09 is V key
        vDown?.flags = .maskCommand
        vDown?.post(tap: .cghidEventTap)

        // Key up for V
        let vUp = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: false)
        vUp?.flags = .maskCommand
        vUp?.post(tap: .cghidEventTap)

        // Key up for Cmd
        let cmdUp = CGEvent(keyboardEventSource: source, virtualKey: 0x37, keyDown: false)
        cmdUp?.post(tap: .cghidEventTap)

        // Restore previous clipboard after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let items = previousContents {
                pasteboard.clearContents()
                pasteboard.writeObjects(items)
            }
        }
    }
}
