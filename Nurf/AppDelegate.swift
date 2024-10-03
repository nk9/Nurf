//
//  AppDelegate.swift
//  Nurf
//
//  Created by Nick Kocharhook on 2024-09-29.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // MARK: - Delegate Methods
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // AppleEvents are being just as flaky. :-/
//        let aem = NSAppleEventManager.shared();
//        aem.setEventHandler(self,
//                            andSelector: #selector(AppDelegate.handleOpenEvent(_:withReplyEvent:)),
//                            forEventClass: AEEventClass(kCoreEventClass),
//                            andEventID: AEEventID(kAEOpenDocuments))
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return false
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func application(_ application: NSApplication, open urls: [URL]) {
        if let window = nurfWindowController.window {
            let printer = Printer(window)
            printer.printURLs(urls)
        }
    }
    
    @IBAction func openAboutPanel(_ sender: Any) {
        NSApp.orderFrontStandardAboutPanel(options: [
            .credits: NSAttributedString(string:"By Nick Kocharhook\nMI, Region 4", attributes: nil)
        ])
    }
    
    // MARK: - Windows

    private lazy var nurfWindowController: NSWindowController! = {
        let mainStoryboard = NSStoryboard(name: "Main", bundle: nil)
        let searchIdentifier = "NurfWindowController"
        
        return mainStoryboard.instantiateController(withIdentifier: searchIdentifier) as? NSWindowController
    }()
}

