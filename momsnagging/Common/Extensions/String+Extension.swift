//
//  String+Extension.swift
//  momsnagging
//
//  Created by suni on 2022/05/29.
//

import Foundation

extension String {
    func toDate(for dateFormat: String) -> Date? { // "yyyy-MM-dd"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}
