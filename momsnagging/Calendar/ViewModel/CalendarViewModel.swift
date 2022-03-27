//
//  CalendarViewModel.swift
//  momsnagging
//
//  Created by 전창평 on 2022/03/24.
//

import Foundation
import RxSwift
import Moya

class CalenderViewModel {
    
    // MARK: - Properties & Variable
    private var model = CalendarModel()
    
    func dayList() -> [String] {
        return model.getDayList()
    }
    func rowCount() -> Int {
        return model.getMonthRow()
    }
    func weekDayList() -> [String] {
        return model.weekDayList
    }
}
