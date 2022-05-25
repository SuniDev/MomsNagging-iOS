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
        case .login(let request):
            return "/users/authentication/\(String(describing: request.provider))"
        case .getUserInfo:
            return "/getUserInfo"
        }
    }
}
