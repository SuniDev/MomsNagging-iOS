//
//  HomeModel.swift
//  momsnagging
//
//  Created by 전창평 on 2022/04/30.
//

import Foundation

// API 나와있지 않은 상황이라 임의로 작성한 부분입니당 :)
struct TodoListModel {
    var seqNumber: Int?
    var scheduleType: String?
    var scheduleName: String?
    var naggingId: Int?
    var scheduleTime: String?
    var done: Bool?
    var id: Int?
    var goalCount: Int?
    var originalId: Int?
}

struct ScheduleArrayModel: Encodable{
    var oneOriginalId: Int
    var theOtherOriginalId: Int
}
