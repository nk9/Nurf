//
//  ViewController.swift
//  Nurf
//
//  Created by Nick Kocharhook on 2024-09-29.
//

import Cocoa

class ViewController: NSViewController, DragViewDelegate {
    @IBOutlet weak var dragView: DragView!
    @IBOutlet weak var mainTextField: NSTextField!
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
}

