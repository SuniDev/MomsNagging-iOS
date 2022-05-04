//
//  UserInfoRequest.swift
//  momsnagging
//
//  Created by suni on 2022/05/04.
//

// MARK: Request 모델
// query parameter에 들어갈 값
struct UserInfoRequest: ModelType {
    var authId: String?
    var snsType: String?
}
