//
//  Printer.swift
//  Nurf
//
//  Created by Nick Kocharhook on 10/1/24.
//

import Foundation
import PDFKit

class Printer: NSObject {
    func printURLs(_ urls: [URL]) {
        for url in urls {
            if let doc = PDFDocument(url: url) {
                print("Examining \(url)")
                let newPDF = printablePDF(doc)
                
//                let tempPath = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, conformingTo: .pdf)
//                newPDF.write(to: tempPath)
                
                printPDF(newPDF)
            }
        }
    }
    
    func printablePageIndexes(doc: PDFDocument) -> IndexSet {
        var indexes = IndexSet()
        
        for i in 0...doc.pageCount {
            if let page = doc.page(at: i) {
                if i == 0 {
                    indexes.insert(i)
                }
                if page.string!.contains(/List \d{8}\-\d{5}/) {

                    indexes.insert(i)
                }
            }
        }
        
        return indexes
    }
    
    func printablePDF(_ doc: PDFDocument) -> PDFDocument {
        var outPDF = PDFDocument()
        var nextOutIndex = 0
        
        for i in 0...doc.pageCount {
            if let page = doc.page(at: i) {
                if i == 0 {
                    outPDF.insert(page, at: nextOutIndex)
                    nextOutIndex += 1
                }
                
                if page.string!.contains(/List \d{8}\-\d{5}/) {
                    outPDF.insert(page, at: nextOutIndex)
                    nextOutIndex += 1
                }
            }
        }
        
        return outPDF
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
        
        let scalingMode = PDFPrintScalingMode.pageScaleDownToFit
        let op = doc.printOperation(for: printInfo, scalingMode: scalingMode, autoRotate: true)
        
        op?.showsPrintPanel = true
        op?.showsProgressPanel = true
        op?.run()
    }
}
