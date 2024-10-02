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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dragView.delegate = self
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

