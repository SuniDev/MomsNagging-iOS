//
//  UserInfo.swift
//  momsnagging
//
//  Created by suni on 2022/05/04.
//

// MARK: Response 모델
struct UserInfo: ModelType {
    let nickName: String
    let email: String
    let snsType: String
    let userID: String
    
    enum ConfigKey: String, CodingKey {
        case nickName
        case email
        case snsType
        case userID
    }
}
