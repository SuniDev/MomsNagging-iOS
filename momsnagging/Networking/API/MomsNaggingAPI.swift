//
//  MomsNaggingAPI.swift
//  momsnagging
//
//  Created by suni on 2022/05/04.
//

import Moya

/**
 # (E) MomsNaggingAPI.swift
 - Author: suni
 - Note: 사용할 API enum으로 관리.
 */
enum MomsNaggingAPI {
    // 로그인
    case login(LoginRequest)
    case getUserInfo(UserInfoRequest)
}

// MARK: MomsNaggingAPI+TargetType
extension MomsNaggingAPI: Moya.TargetType {
    var baseURL: URL { self.getBaseURL() }
    var path: String { self.getPath() }
    var method: Moya.Method { self.getMethod() }
    var sampleData: Data { Data() }
    var task: Task { self.getTask() }
    var headers: [String: String]? { ["Content-Type": "application/json"] }
    var authorizationType: AuthorizationType? { .basic }
}
