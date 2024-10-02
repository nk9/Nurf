//
//  ViewController.swift
//  Nurf
//
//  Created by Nick Kocharhook on 2024-09-29.
//

import Cocoa

class ViewController: NSViewController, DragViewDelegate, NSOpenSavePanelDelegate {
    @IBOutlet weak var dragView: DragView!
    @IBOutlet weak var mainTextField: NSTextField!
    @IBOutlet weak var chooseTurfButton: NSButton!
    
    @IBOutlet weak var dropImageView: NSImageView! {
        didSet {
            dropImageView.unregisterDraggedTypes()
        }
    }
        
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func dragViewDidReceive(fileURLs: [URL]) {
        let printer = Printer()
        printer.printURLs(fileURLs)
    }
    
    @IBAction func chooseTurfPDFs(_ sender: Any) {
        let panel = NSOpenPanel()

        panel.delegate = self
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowsMultipleSelection = true
        
        panel.runModal()

        let printer = Printer()
        printer.printURLs(panel.urls)
    }
    
    func panel(_ sender: Any, shouldEnable url: URL) -> Bool {
        print(url)
        return url.pathExtension == "pdf"
    }
}
