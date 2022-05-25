//
//  MomsNaggingAPI+Headers.swift
//  momsnagging
//
//  Created by suni on 2022/05/25.
//

import Moya

extension MomsNaggingAPI {
    func getHeaders() -> [String: String]? {
        switch self {
        case .login:
            return ["Content-Type": "application/json"]
        case .getUserInfo:
            if let token: String = TestUser.authorization {
                return ["Content-Type": "application/json", "Authorization": token]
            }
            return ["Content-Type": "application/json"]
        }
    }
}
