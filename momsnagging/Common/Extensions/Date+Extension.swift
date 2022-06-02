//
//  Date+Extension.swift
//  momsnagging
//
//  Created by suni on 2022/05/29.
//

import Foundation

extension Date {
    
    func to(for dateFormat: String) -> Date { // "yyyy-MM-dd"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let date = dateFormatter.date(from: self.toString())
        return date ?? self
    }
    
    func toString(for dateFormat: String) -> String { // "yyyy-MM-dd"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let str = dateFormatter.string(from: self)
        return str
    }
    /**
     # dateCompare
     - Parameters:
        - fromDate: 비교 대상 Date
     - Note: 두 날짜간 비교해서 과거(Future)/현재(Same)/미래(Past) 반환
    */
    func dateCompare(fromDate: Date) -> String {
        var strDateMessage: String = ""
        let result: ComparisonResult = self.compare(fromDate)
        switch result {
        case .orderedAscending:
            strDateMessage = "Future"
        case .orderedDescending:
            strDateMessage = "Past"
        case .orderedSame:
            strDateMessage = "Same"
        default:
            strDateMessage = "Error"
        }
        return strDateMessage
    }
}
