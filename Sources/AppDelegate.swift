import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    private var hotkeyManager: HotkeyManager!
    private var speechRecognizer: SpeechRecognizer!

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide dock icon - we're a menu bar only app
        NSApp.setActivationPolicy(.accessory)

        // Initialize speech recognizer
        speechRecognizer = SpeechRecognizer()

        // Create status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "waveform", accessibilityDescription: "Murmur")
            button.action = #selector(togglePopover)
            button.target = self
        }

        // Create popover with shared speech recognizer
        popover = NSPopover()
        popover.contentSize = NSSize(width: 300, height: 280)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: ContentView(speechRecognizer: speechRecognizer))

        // Register global hotkey with press-and-hold behavior
        hotkeyManager = HotkeyManager()
        hotkeyManager.register(
            onKeyDown: { [weak self] in
                // Start recording when right Command is pressed
                self?.speechRecognizer.startRecording()
            },
            onKeyUp: { [weak self] in
                // Stop recording when right Command is released
                self?.speechRecognizer.stopRecording()
            }
        )
    }

    @objc func togglePopover() {
        guard let button = statusItem.button else { return }

        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }
}
