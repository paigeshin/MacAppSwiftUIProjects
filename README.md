# APP - Reminders 

### Composing Menu

```swift

struct DueDateSelectionView: View {
    
    @Binding var dueDate: DueDate?
    @State private var selectedDate: Date = Date.today
    @State private var showCalendar: Bool = false
    
    var body: some View {
        Menu {
            Button {
                self.dueDate = .today
            } label: {
                VStack {
                    Text("Today \n \(Date.today.formattedAsString)")
                } //: VSTACK
            }
            
            Button {
                self.dueDate = .tomorrow
            } label: {
                VStack {
                    Text("Tomorrow \n \(Date.today.formattedAsString)")
                } //: VSTACK
            }
            
            Button {
                self.showCalendar = true
            } label: {
                VStack {
                    Text("Custom")
                } //: VSTACK
            }
            
        } label: {
            Label(self.dueDate == nil ? "Add Date:" : self.dueDate!.title, systemImage: "calendar")
        }
        .menuStyle(.borderedButton)
        .fixedSize()
        .popover(isPresented: self.$showCalendar,
                 content: {
            DatePicker("Custom", selection: self.$selectedDate, displayedComponents: .date)
                .labelsHidden()
                .datePickerStyle(.graphical)
                .onChange(of: self.selectedDate) { newValue in
                    self.dueDate = .custom(newValue)
                    self.showCalendar = false 
                }
        })
    }
}

```

### Composing SideBarView

```swift

NavigationView {
    SideBarView()
        .frame(minWidth: 200)
    Text("MyListItems")
}

```

### Useful Duedate Logic 

```swift
import Foundation

enum DueDate {
    case today
    case tomorrow
    case yesterday
    case custom(Date)
}

extension DueDate {
    
    var value: Date {
        switch self {
        case .today:
            return Date.today
        case .tomorrow:
            return Date.tomorrow
        case .yesterday:
            return Date.yesterDay
        case .custom(let date):
            return date
        }
    }
    
    var title: String {
        switch self {
        case .today:
            return "Today"
        case .tomorrow:
            return "Tomorrow"
        case .yesterday:
            return "Yesterday"
        case .custom(let date):
            return date.formattedAsString
        }
    }
    
    var isPastDue: Bool {
        self.value < Date()
    }
    
    static func from(value: Date) -> DueDate {
        let calendar = NSCalendar.current
        if calendar.isDateInToday(value) {
            return DueDate.today
        } else if calendar.isDateInTomorrow(value) {
            return DueDate.tomorrow
        } else if calendar.isDateInYesterday(value) {
            return DueDate.yesterday
        }
        return DueDate.custom(value)
    }
    
}

```

### onHover

```swift
    .onHover { value in
        self.active = value 
    }
```

### Right Click Deleting in macOS

```swift
        VStack(alignment: .leading, spacing: 0) {
            
            List {
                Text("My Lists")
                ForEach(vm.myLists) { myList in
                    
                    NavigationLink {
                        MyListItemsHeaderView(name: myList.name,
                                              count: 6,
                                              color: myList.color)
                        
                        MyListItemsView(
                            items: myList.items,
                            onItemAdded: { title, dateDue in
                                self.vm.saveTo(list: myList,
                                               title: title,
                                               dueDate: dateDue)
                            },
                            onItemDeleted: self.vm.deleteItem
                        )
                    } label: {
                        HStack {
                            Image(systemName: Constants.Icons.line3HorizontalCircleFill)
                                .font(.title)
                                .foregroundColor(myList.color)
                            Text(myList.name)
                        }
                    } //: NavigationLink
                    .contextMenu {
                        Button {
                            vm.delete(myList)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }

                    }
                    
                } //: FOREACH
            } //: LIST
            
        }
```

### CoreData Observer 

```swift
    private func setupObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextDidChange), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: context)
    }
    
    @objc
    func managedObjectContextDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<MyListItem>, updates.count > 0 {
            fetchAll()
        }
    }
```

### Delay Util 


```swift
//
//  Delay.swift
//  Reminders
//
//  Created by paige shin on 2023/02/26.
//

import Foundation

class Delay {
    
    private var seconds: Double
    
    init(_ seconds: Double = 2) {
        self.seconds = seconds
    }
    
    var workItem: DispatchWorkItem?
    
    func performWork(_ work: @escaping() -> Void) {
        workItem = DispatchWorkItem(block: {
            work()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: workItem!)
    }
    
    func cancel() {
        workItem?.cancel()
    }
    
}

/*
 if
     delay.performWork {

     }
 
 else
 
    delay.cancel()
 
 */

```

# MenuBar App - UIKit

### Populate Menu

```swift

class AppDelegate: NSObject, NSApplicationDelegate {

    private var statusItem: NSStatusItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        // statusButton => Menubar Item
        if let statusButton = statusItem.button {
            statusButton.image = NSImage(systemSymbolName: "pawprint.circle", accessibilityDescription: "Paw")
        }
        
    }
...
```

### If you want to create `Menu Bar` Only App Add this property to info.plist

![create menu bar only app](./img1.png)

### Add PopOver 

- You must assign ViewController  

```swift
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
```

### If you don't use storyboard, then you have to define `override func loadView()`

- Just build an app like an usual UIKit App on ViewController

```swift
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


```

# MenuBar App - SwiftUI

```swift
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

```
