//
//  MomsNaggingAPI+Method.swift
//  momsnagging
//
//  Created by suni on 2022/05/04.
//

import Moya

// MARK: Method
// 각 case의 메소드 타입 get / post
extension MomsNaggingAPI {
    func getMethod() -> Moya.Method {
        switch self {
        case .login:
            return .get
        case .getUserInfo:
            return .post
        }
    }
}
