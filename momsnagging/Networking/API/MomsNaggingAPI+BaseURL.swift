//
//  MomsNaggingAPI+BaseURL.swift
//  momsnagging
//
//  Created by suni on 2022/05/04.
//

import Moya

// MARK: Base URL
extension MomsNaggingAPI {
    func getBaseURL() -> URL {
        switch self {
        default:
            return URL(string: baseUrl())!
        }
    }
    
    func baseUrl() -> String {
        switch Common.getDeployPhase() {
        case .debug:
            return "테스트서버주소"
        case .release:
            return "실서버주소"
        }
    }
}
