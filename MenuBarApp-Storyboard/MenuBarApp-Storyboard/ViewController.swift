//
//  ViewController.swift
//  MenuBarApp-Storyboard
//
//  Created by paige shin on 2023/02/26.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func loadView() {
        self.view = NSView(frame: NSRect(x: 0, y: 0, width: 400, height: 200))
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

