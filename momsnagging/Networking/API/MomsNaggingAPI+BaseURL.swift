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
            return "https://api.momsnagging.ml/api/vl"
        case .release:
            return "https://api.momsnagging.ml/api/vl"
        }
    }
}
