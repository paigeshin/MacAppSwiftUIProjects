//
//  AppKit.swift
//  MenuBarApp-Storyboard
//
//  Created by paige shin on 2023/02/26.
//

import AppKit

// WRITE THIS CODE TO MAKE YOUR APP KNOW ABOUT `APPDELEGATE`

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
