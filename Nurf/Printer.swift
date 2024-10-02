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
                let indexes = printablePageIndexes(doc: doc)
                print(">>> page indexes to print:", indexes)
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
}
