//
//  MenuBarApp_SwiftUIApp.swift
//  MenuBarApp-SwiftUI
//
//  Created by paige shin on 2023/02/26.
//

import SwiftUI

@main
struct MenuBarApp_SwiftUIApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let statusButton = self.statusItem.button {
            statusButton.image = NSImage(systemSymbolName: "chart.line.uptrend.xyaxis.circle", accessibilityDescription: "Chart Line")
            statusButton.action = #selector(togglePopover)
        }
        
        self.popover = NSPopover()
        self.popover.contentSize = NSSize(width: 300, height: 300)
        self.popover.behavior = .transient
        // SWIFTUI
        self.popover.contentViewController = NSHostingController(rootView: ContentView())
        
    }
    
    @objc
    func togglePopover() {
        
        if let button = self.statusItem.button {
            if self.popover.isShown {
                self.popover.performClose(nil)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
        
    }
    
}
