//
//  NSMutableAttributedString+Extensions.swift
//  Nurf
//
//  Created by Nick Kocharhook on 10/3/24.
//

import Foundation

extension NSMutableAttributedString {

    public func setAsLink(textToFind:String, linkURL:String) -> Bool {

        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}
