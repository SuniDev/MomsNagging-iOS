//
//  HomeModel.swift
//  momsnagging
//
//  Created by 전창평 on 2022/04/30.
//

import Foundation

// API 나와있지 않은 상황이라 임의로 작성한 부분입니당 :)
struct TodoListModel {
    var isSelected: Bool?
    var time: String?
    var title: String?
    var prefix: String?
    var type: TodoCellType?
}
enum TodoCellType {
    case normal
    case todo
    case count
}
