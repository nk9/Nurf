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

    func dragViewDraggingEnded(fileURLs: [URL]) {
        runPrintOperation(fileURLs)
    }
    
    @IBAction func chooseTurfPDFs(_ sender: Any?) {
        let panel = NSOpenPanel()

        panel.delegate = self
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowsMultipleSelection = true
        
        panel.runModal()

        runPrintOperation(panel.urls)
    }
    
    func runPrintOperation(_ fileURLs: [URL]) {
        dragView.enabled = false
        chooseTurfButton.isEnabled = false

        DispatchQueue.main.async() {
            if let window = self.view.window {
                let printer = Printer(window)
                printer.printURLs(fileURLs)
                self.dragView.enabled = true
                self.chooseTurfButton.isEnabled = true
            }
        }
    }
    
    func panel(_ sender: Any, shouldEnable url: URL) -> Bool {
        return url.pathExtension == "pdf"
    }
    
    @IBAction
    func openDocument(_ sender: Any?)
    {
        chooseTurfPDFs(sender)
    }
}
