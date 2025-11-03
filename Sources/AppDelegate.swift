import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    private var hotkeyManager: HotkeyManager!
    private var speechRecognizer: SpeechRecognizer!
    private var previouslyFocusedApp: NSRunningApplication? // Track app to paste to

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide dock icon - we're a menu bar only app
        NSApp.setActivationPolicy(.accessory)

        // Initialize speech recognizer
        speechRecognizer = SpeechRecognizer()

        // Create status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            // Load custom menu bar icon (simple waveform design)
            if let menuBarIconPath = Bundle.main.path(forResource: "MenuBarIcon", ofType: "png"),
               let menuBarIcon = NSImage(contentsOfFile: menuBarIconPath) {
                // Make it a template image so it follows system appearance (white/black)
                menuBarIcon.isTemplate = true
                button.image = menuBarIcon
            } else {
                // Fallback to system icon
                button.image = NSImage(systemSymbolName: "waveform", accessibilityDescription: "Murmur")
            }
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
                guard let self = self else { return }

                // Remember which app was focused before we show popover
                self.previouslyFocusedApp = NSWorkspace.shared.frontmostApplication

                // Show popover to see live transcription
                if let button = self.statusItem.button, !self.popover.isShown {
                    self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                }

                // Start recording when right Command is pressed
                self.speechRecognizer.startRecording()
            },
            onKeyUp: { [weak self] in
                guard let self = self else { return }

                // Close popover first - macOS will restore focus automatically
                if self.popover.isShown {
                    self.popover.performClose(nil)
                }

                // Wait for focus to return, then stop recording and paste
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.speechRecognizer.stopRecording()
                }

                self.previouslyFocusedApp = nil
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
