//
//  DragView.swift
//
//  Copyright (c) 2020 Geri Borbás http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.

import Cocoa


@objc protocol DragViewDelegate
{
    func dragViewDraggingEnded(fileURLs: [URL])
}


class DragView: NSView
{
    @IBOutlet weak var delegate: DragViewDelegate?

    let fileExtensions = ["pdf"]
    let cornerRadius = 10.0
    var draggedItems: [URL] = []
    
    var enabled: Bool = true {
        didSet {
            needsDisplay = true
        }
    }
    
    var backgroundColor: NSColor {
        get {
            if (enabled) {
                return .white
            } else {
                return #colorLiteral(red: 0.86, green: 0.86, blue: 0.86, alpha: 1.0)
            }
        }
    }


    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
        registerForDraggedTypes([.fileURL])
        
        self.wantsLayer = true
        self.layer?.cornerRadius = cornerRadius
        self.layer?.borderWidth = 2.0
        self.layer?.borderColor = #colorLiteral(red: 0.777, green: 0.808, blue: 0.841, alpha: 1.0)
    }
    
    override func layout() {
        super.layout()
        addInnerShadow()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        color(to: backgroundColor)
        super.draw(dirtyRect)
    }

    private func addInnerShadow() {
        let innerShadow = CALayer()
        innerShadow.cornerRadius = cornerRadius
        
        innerShadow.frame = bounds
        
        // Shadow path (1pt ring around bounds)
        let path = NSBezierPath(rect: innerShadow.bounds.insetBy(dx: -1, dy: -1))
        let cutout = NSBezierPath(rect: innerShadow.bounds).reversed
        path.append(cutout)
        innerShadow.shadowPath = path.cgPath
        innerShadow.masksToBounds = true
        
        // Shadow properties
        innerShadow.shadowColor = NSColor(white: 0, alpha: 1).cgColor
        innerShadow.shadowOffset = CGSize.zero
        innerShadow.shadowOpacity = 1
        innerShadow.shadowRadius = 3
        
        // Add
        self.layer?.addSublayer(innerShadow)
    }
    
    override func draggingEntered(_ draggingInfo: NSDraggingInfo) -> NSDragOperation
    {
        var containsMatchingFiles = false
        draggingInfo.draggingPasteboard.readObjects(forClasses: [NSURL.self], options: nil)?.forEach
        {
            eachObject in
            if let eachURL = eachObject as? URL
            {
                containsMatchingFiles = containsMatchingFiles || fileExtensions.contains(eachURL.pathExtension.lowercased())
                if containsMatchingFiles { print(eachURL.path) }
            }
        }

        switch (containsMatchingFiles)
        {
            case true:
            color(to: #colorLiteral(red: 0.693, green: 0.846, blue: 1.0, alpha: 1.0))
                return .copy
            case false:
                color(to: .disabledControlTextColor)
                return .init()
        }
    }
    
    override func prepareForDragOperation(_ sender: any NSDraggingInfo) -> Bool {
        draggedItems = []
        
        return enabled
    }

    override func performDragOperation(_ draggingInfo: NSDraggingInfo) -> Bool
    {
        let matchingFileURLs = matchingFiles(draggingInfo)
        
        // Only continue if any matched
        guard matchingFileURLs.count > 0
        else { return false }

        // Save the dragged items
        draggedItems = matchingFileURLs
        return true
    }
    
    func matchingFiles(_ draggingInfo: NSDraggingInfo) -> [URL] {
        // Collect URLs
        var matchingFileURLs: [URL] = []
        draggingInfo.draggingPasteboard.readObjects(forClasses: [NSURL.self], options: nil)?.forEach
        {
            eachObject in
            if
                let eachURL = eachObject as? URL,
                fileExtensions.contains(eachURL.pathExtension.lowercased())
            { matchingFileURLs.append(eachURL) }
        }
        
        return matchingFileURLs
    }

    override func draggingExited(_ sender: NSDraggingInfo?) {
        color(to: backgroundColor)
    }

    override func draggingEnded(_ sender: NSDraggingInfo) {
        if draggedItems.count > 0 {
            delegate?.dragViewDraggingEnded(fileURLs: draggedItems)
        }
    }
}


extension DragView
{
    func color(to color: NSColor)
    {
        self.wantsLayer = true
        self.layer?.backgroundColor = color.cgColor
    }
}

