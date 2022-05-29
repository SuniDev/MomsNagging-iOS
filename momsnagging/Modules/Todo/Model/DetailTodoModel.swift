//
//  DetailTodoModel.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/28.
//

import Foundation

struct TodoInfoResponseModel {
    var id: Int?
    var naggingId: Int?
    var goalCount: Int?
    var scheduleName: String?
    var scheduleTime: String?
    var scheduleDate: String?
    var alarmTime: String?
    var done: Bool?
    var mon: Bool?
    var tue: Bool?
    var wed: Bool?
    var thu: Bool?
    var fri: Bool?
    var sat: Bool?
    var sun: Bool?
    var scheduleType: String?
}
