//
//  Date+AFExtension.swift
//  ArtFlow
//
//  Created by Quinn on 4/12/21.
//

import Foundation


extension String {
    func date(withFormat f : String) -> Date? {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = f
        if let date = dateFormatterGet.date(from: self) {
           return date
        }
        return nil
    }
    
    func dateFromTimestamp() -> Date? {
        if let t = TimeInterval(self) {
            let d = Date.init(timeIntervalSince1970: t)
            return d

        }
        return nil
    }
}


public let KAppDateFormat = "MMM dd, YYYY | hh:mm a"
extension Date {
    func string(forFormat f :String) -> String {
        let df = DateFormatter()
        df.dateFormat = f
        return df.string(from: self)
    }
}

