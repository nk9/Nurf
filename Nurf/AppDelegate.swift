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
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return false
    }
    
    func application(_ application: NSApplication, open urls: [URL]) {
        print("application(_:open:)")
        
        if let window = nurfWindowController.window {
            let printer = Printer(window)
            printer.printURLs(urls)
        }
    }
    
    @IBAction func openAboutPanel(_ sender: Any) {
        NSApp.orderFrontStandardAboutPanel(options: [
            .credits: NSAttributedString(string:"By Nick Kocharhook\nRegion 4", attributes: [:])
        ])
    }
    
    // MARK: - Windows

    private lazy var nurfWindowController: NSWindowController! = {
        let mainStoryboard = NSStoryboard(name: "Main", bundle: nil)
        let searchIdentifier = "NurfWindowController"
        
        return mainStoryboard.instantiateController(withIdentifier: searchIdentifier) as? NSWindowController
    }()
}

