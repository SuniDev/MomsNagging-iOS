//
//  GetUserRequest.swift
//  momsnagging
//
//  Created by suni on 2022/05/29.
//

import Foundation

/**
 # (S) GetUserRequest
 - Authors: suni
 - Note: 회원 정보 조회 Request 모델
 */
struct GetUserRequest: RequestModelType { }

/**
 # (S) PutUserRequest
 - Authors: suni
 - Note: 회원 정보 수정 Request 모델
 */
struct PutUserRequest: RequestModelType, Encodable {
    var nickName: String?
    var naggingLevel: Int?
    var allowGeneralNotice: Bool?
    var allowTodoNotice: Bool?
    var allowRoutineNotice: Bool?
    var allowWeeklyNotice: Bool?
    var allowOtherNotice: Bool?
}

/**
 # (S) DeleteUserRequest
 - Authors: suni
 - Note: 회원 탈퇴  Request 모델
 */
struct DeleteUserRequest: RequestModelType { }
