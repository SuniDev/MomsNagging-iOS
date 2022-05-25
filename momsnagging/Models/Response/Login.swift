//
//  Login.swift
//  momsnagging
//
//  Created by suni on 2022/05/25.
//

// MARK: Login Rseponse 모델
struct Login: ModelType {
    let token: String
    
    enum ConfigKey: String, CodingKey {
        case token
    }
}
