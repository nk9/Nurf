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
        NSApp.activate()
        print("applicationDidFinishLaunching")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return false
    }

    func application(_ application: NSApplication, open urls: [URL]) {
        print("application(_:open:)")
        let printer = Printer()
        printer.printURLs(urls)
    }
    
    @IBAction func openAboutPanel(_ sender: Any) {
        print("openAboutPanel")
        
        NSApp.orderFrontStandardAboutPanel(options: [
            .credits: NSAttributedString(string:"By Nick Kocharhook\nRegion 4", attributes: [:])
        ])
    }
}

