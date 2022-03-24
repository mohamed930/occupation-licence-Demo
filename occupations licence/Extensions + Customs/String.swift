//
//  String.swift
//  DARDESH
//
//  Created by Mohamed Ali on 03/07/2021.
//

import Foundation

extension String {
    var localized:String {
        return NSLocalizedString(self, comment: "")
    }
    
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    public var replacedArabicDigitsWithEnglish: String {
        var str = self
        let map = ["0": "٠",
                   "1": "١",
                   "2": "٢",
                   "3": "٣",
                   "4": "٤",
                   "5": "٥",
                   "6": "٦",
                   "7": "٧",
                   "8": "٨",
                   "9": "٩",
                   ".": "."]
        map.forEach { str = str.replacingOccurrences(of: $0, with: $1) }
        return str
    }
}
