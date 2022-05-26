////
////  Users.swift
////  momsnagging
////
////  Created by KBIZ on 2022/05/26.
////
//
//// MARK: GetUser Rseponse 모델
//struct GetUser: ModelType {
//    let id: Int
//    let email: String           // 이메일
//    let provider: String        // 소셜로그인 플랫폼
//    let nickName: String        // 호칭
//    let personId: String
//    let naggingLevel: Int       // 잔소리 강도
//    let device: String          // 디바이스 타입
//    let allowGeneralNotice: Bool
//    let allowTodoNotice: Bool
//    let allowRoutineNotice: Bool
//    let allowWeeklyNotice: Bool
//    let allowOtherNotice: Bool
//
//    required init(jsonData: JSON) {
//        token = jsonData["token"].string
//    }
//}
