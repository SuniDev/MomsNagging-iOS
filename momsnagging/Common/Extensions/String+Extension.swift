//
//  String+Extension.swift
//  momsnagging
//
//  Created by suni on 2022/05/29.
//

import Foundation

extension String {
    func toDate(for dateFormat: String, locale: Locale? = nil) -> Date? { // "yyyy-MM-dd"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        if let locale = locale {
            dateFormatter.locale = locale
        }
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}
