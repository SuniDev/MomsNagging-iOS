//
//  API+Path.swift
//  momsnagging
//
//  Created by suni on 2022/05/04.
//

import Moya

// MARK: Path
extension MomsNaggingAPI {
    func getPath() -> String {
        switch self {
        case .getUserInfo:
            return "/getUserInfo"
        }
    }
}
