//
//  Printer.swift
//  Nurf
//
//  Created by Nick Kocharhook on 10/1/24.
//

import Foundation
import PDFKit

class Printer: NSObject {
    weak var _window: NSWindow?
    
    required init(_ window: NSWindow) {
        _window = window
    }
    
    func printURLs(_ urls: [URL]) {
        let outDoc = PDFDocument()
        
        for url in urls {
            if let doc = PDFDocument(url: url) {
                appendPrintablePages(fromDoc: doc, toDoc: outDoc)
            }
        }
        
        if (outDoc.pageCount > 0){
            printPDF(outDoc)
        }
    }
    
    func appendPrintablePages(fromDoc doc: PDFDocument, toDoc outDoc: PDFDocument) {
        var nextOutIndex = outDoc.pageCount
        
        for i in 0...doc.pageCount {
            if let page = doc.page(at: i) {
                if i == 0 {
                    outDoc.insert(page, at: nextOutIndex)
                    nextOutIndex += 1
                }
                
                if page.string!.contains(/List \d{8}\-\d{5}/) {
                    outDoc.insert(page, at: nextOutIndex)
                    nextOutIndex += 1
                }
            }
        }
    }
    
    func printPDF(_ doc: PDFDocument) {
        let printInfo = NSPrintInfo()
        printInfo.topMargin = 0;
        printInfo.bottomMargin = 0;
        printInfo.leftMargin = 0;
        printInfo.rightMargin = 0;
        printInfo.horizontalPagination = .fit
        printInfo.verticalPagination = .fit
        
        let printSettings = PMPrintSettings(printInfo.pmPrintSettings())
        PMSetDuplex(printSettings, PMDuplexMode(kPMDuplexNone))
        printInfo.updateFromPMPrintSettings()
        
        let pageFormat = PMPageFormat(printInfo.pmPageFormat())
        PMSetOrientation(pageFormat, PMOrientation(kPMLandscape), false)
        printInfo.updateFromPMPageFormat()
        
        let scalingMode = PDFPrintScalingMode.pageScaleDownToFit
        let op = doc.printOperation(for: printInfo, scalingMode: scalingMode, autoRotate: true)
        
        op?.showsPrintPanel = true
        op?.showsProgressPanel = true
        
        op?.run()

        // if let window = _window {
        //    op?.runModal(for: window, delegate: self, didRun: #selector(printOperationDidRun), contextInfo: nil)
        // }
    }
    
    @objc func printOperationDidRun( printOperation: NSPrintOperation,
                                     success: Bool,
                                     contextInfo: UnsafeMutableRawPointer?){
        print("finished print op")
    }
}
