//
//  QuestionService.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/29.
//

import Foundation
import Moya

enum QuestionService {
    case createQuestion(param: QuestionRequestModel)
}

extension QuestionService: TargetType {
    var baseURL: URL {
        return URL(string: Common.getBaseUrl())!
    }
    
    var path: String {
        switch self {
        case .createQuestion:
            return "question"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createQuestion:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .createQuestion(param: let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .createQuestion:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(CommonUser.authorization ?? "")"]
        }
    }

}
