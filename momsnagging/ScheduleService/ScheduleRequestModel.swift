//
//  ScheduleRequestModel.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/25.
//

import Foundation

struct CreateTodoRequestModel: Encodable {
    var scheduleName: String?
    var naggingId: Int?
    var goalCount: Int?
    var scheduleTime: String?
    var scheduleDate: String?
    var alarmTime: String?
    var mon: Bool?
    var tue: Bool?
    var wed: Bool?
    var thu: Bool?
    var fri: Bool?
    var sat: Bool?
    var sun: Bool?
}
