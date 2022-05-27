//
//  MomsNaggingAPI.swift
//  momsnagging
//
//  Created by suni on 2022/05/04.
//

import Moya
import RxSwift
import SwiftyJSON

/**
 # (E) MomsNaggingAPI.swift
 - Author: suni
 - Note: 사용할 API enum으로 관리.
 */
enum MomsNaggingAPI {
    // 로그인
    case login(LoginRequest)
    // 회원 검색 아이디 중복 확인
    case validateID(ValidateIDRequest)
    // 회원 가입
    case join(JoinRequest)
    //
    // 회원 정보 조회
//    case getUser(GetUserRequest)
}

extension MomsNaggingAPI: TargetType, AccessTokenAuthorizable {
    
    static func baseUrl() -> String {
        switch Common.getDeployPhase() {
        case .debug:
            return "https://api.momsnagging.ml/api/v1"
        case .release:
            return "https://api.momsnagging.ml/api/v1"
        }
    }
    
    // 각 case의 도메인
    var baseURL: URL {
        switch self {
        default:
            return URL(string: MomsNaggingAPI.baseUrl())!
        }
    }
    
    // 각 case의 URL Path
    var path: String {
        switch self {
        case .login(let request):
            return "/auth/authentication/\(request.provider)"
        case .validateID(let request):
            return "/auth/validate/\(request.id)"
        case .join(let request):
            return "/auth/\(request.provider)"
        }
    }
    
    var task: Task {
        /* example
         Body로 보내는 거면 하단 처럼 따로 설정.
         
         case .MAMAVoteSend(let bodyRequest):
         return Task.requestCompositeData(bodyData: bodyRequest.data(using:.utf8)!, urlParameters: [:])
         */
      switch self {
      case .login:
          return .requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
      case .validateID:
          return .requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
      case .join(let request):
          return .requestJSONEncodable(["code":request.code, "device":request.device, "email":request.email, "id":request.id, "nickname":request.nickname])
//          return .requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
      }
    }
    
    // 각 case의 메소드 타입 get / post
    var method: Moya.Method {
        switch self {
        case .login, .validateID:
            return .get
        case .join:
            return .post
        }
    }
    
    // 헤더에 추가할 내용 정의
    var headers: [String: String]? {
        switch self {
        case .login, .validateID, .join:
            return ["Content-Type": "application/json"]
//        case .getUser:
//            if let token: String = CommonUser.authorization {
//                return ["Content-Type": "application/json", "Authorization": token]
//            }
//            return ["Content-Type": "application/json"]
        }
    }
    
    var authorizationType: AuthorizationType? {
        /*
         Header 사용 여부. bearer, basic 방식으로 보낼 수 있음.
         case .MwaveVoteSend:
         return .bearer
         */
        switch self {
        default:
            return .bearer
        }
    }
    
    // 파라미터
    /**
     e.g.)
     // GET으로 보낼 경우.
     case .VoteDetail(let showLoCd, let langCd, let voteSeq):
     parameters = ["showLoCd":showLoCd, "langCd":langCd, "voteSeq":voteSeq]
     break
     
     // POST로 보낼 경우.
     case .VoteSend(let bodyRequest):
     return Task.requestCompositeData(bodyData: bodyRequest.data(using:.utf8)!, urlParameters: [:])
     
     */
    var parameters: [String: Any]? {
        switch self {
        case .login(let request):
            return request.toDictionary()
        case .join(let request):
            return request.toDictionary()
        default:
            return [:]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        /* 아래와 같이도 사용 가능.
         case .sendChatData:
         return URLEncoding.httpBody
         */
        switch self {
        default:
            return URLEncoding.default
        }
    }
}

extension Encodable {
  func toDictionary() -> [String: Any] {
    do {
      let jsonEncoder = JSONEncoder()
      let encodedData = try jsonEncoder.encode(self)
      
      let dictionaryData = try JSONSerialization.jsonObject(
        with: encodedData,
        options: .allowFragments
      ) as? [String: Any]
      return dictionaryData ?? [:]
    } catch {
      return [:]
    }
  }
}
