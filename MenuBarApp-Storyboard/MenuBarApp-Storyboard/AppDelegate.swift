//
//  AppDelegate.swift
//  MenuBarApp-Storyboard
//
//  Created by paige shin on 2023/02/26.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        // statusButton => Menubar Item
        if let statusButton = statusItem.button {
            statusButton.image = NSImage(systemSymbolName: "pawprint.circle", accessibilityDescription: "Paw")
            statusButton.action = #selector(togglePopover)
        }
        
        self.popover = NSPopover()
        self.popover.contentSize = NSSize(width: 400, height: 200)
        self.popover.behavior = .transient
        self.popover.contentViewController = ViewController()
        
    }
    
    @objc func togglePopover() {
        if let button = statusItem.button {
            if popover.isShown {
                self.popover.performClose(nil)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}


