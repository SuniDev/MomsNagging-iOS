//
//  Date+Extension.swift
//  momsnagging
//
//  Created by suni on 2022/05/29.
//

import Foundation

extension Date {
    
    func toString(for dateFormat: String) -> String { // "yyyy-MM-dd"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let str = dateFormatter.string(from: self)
        return str
    }
}
