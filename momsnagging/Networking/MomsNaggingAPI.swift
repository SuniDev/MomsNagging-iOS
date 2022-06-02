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
    // 회원 정보 조회
    case getUser(GetUserRequest)
    // 회원 정보 수정
    case putUser(PutUserRequest)
    // 회원 탈퇴
    case deleteUser(DeleteUserRequest)
    // 월간 달력 일기장 조회
    case diaryCalendar(DiaryCalendarRequest)
    // 일기장 조회
    case getDiary(GetDiaryReqeust)
    // 일기장 수정
    case putDiary(PutDiaryReqeust)
    // 상장 등급 조회
    case gradeAwards(GradeAwardsRequest)
    // 월간 달력 성적표 조회
    case gradeCalendar(GradeCalendarRequest)
    // 직전 주의 주간평가 조회
    case gradeLastWeek(GradeLastWeekRequest)
    // 월간 주간평가 조회
    case gradeMonthly(StatisticsMonthlyRequest)
    // 성적표 통계 조회
    case gradeStatistics(GradeStatisticsRequest)
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
        case .getUser, .putUser, .deleteUser:
            return "/users"
        case .diaryCalendar:
            return "/diary/calendar"
        case .getDiary, .putDiary:
            return "/diary"
        case .gradeAwards:
            return "/grades/awards"
        case .gradeCalendar:
            return "/grades/calendar"
        case .gradeLastWeek:
            return "/grades/lastWeek"
        case .gradeMonthly:
            return "/grades/monthly"
        case .gradeStatistics:
            return "/grades/statistics"
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
      case .join:
          return .requestCompositeData(bodyData: Data(), urlParameters: parameters ?? [:])
      case .getUser:
          return .requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
      case .putUser(let request):
          return .requestJSONEncodable(request)
      case .deleteUser:
          return .requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
      case .diaryCalendar:
          return .requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
      case .getDiary:
          return .requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
      case .putDiary(let request):
          return .requestJSONEncodable(request)
      case .gradeAwards(_):
          return .requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
      case .gradeCalendar(_):
          return .requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
      case .gradeLastWeek(_):
          return .requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
      case .gradeMonthly(_):
          return .requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
      case .gradeStatistics(_):
          return .requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
      }
    }
    
    // 각 case의 메소드 타입 get / post
    var method: Moya.Method {
        switch self {
        case .login, .validateID, .diaryCalendar, .getDiary, .getUser, .gradeAwards, .gradeMonthly, .gradeCalendar, .gradeStatistics, .gradeLastWeek:
            return .get
        case .join:
            return .post
        case .putDiary, .putUser:
            return .put
        case .deleteUser:
            return .delete
        }
    }
    
    // 헤더에 추가할 내용 정의
    var headers: [String: String]? {
        switch self {
        case .login, .validateID, .join:
            return ["Content-Type": "application/json"]
        case .diaryCalendar, .getDiary, .putDiary, .getUser, .putUser, .deleteUser, .gradeAwards, .gradeMonthly, .gradeCalendar, .gradeStatistics, .gradeLastWeek:
            if let token: String = CommonUser.authorization {
                return ["Content-Type": "application/json", "Authorization": "Bearer \(token)"]
            }
            return ["Content-Type": "application/json"]
        }
    }
    
    var authorizationType: AuthorizationType? {
            return .bearer
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
        case .getUser(let request):
            return request.toDictionary()
        case .putUser(let request):
            return request.toDictionary()
        case .deleteUser(let request):
            return request.toDictionary()
        case .diaryCalendar(let request):
            return request.toDictionary()
        case .getDiary(let request):
            return request.toDictionary()
        case .putDiary(let request):
            return request.toDictionary()
        case .gradeAwards(let request):
            return request.toDictionary()
        case .gradeMonthly(let request):
            return request.toDictionary()
        case .gradeCalendar(let request):
            return request.toDictionary()
        case .gradeStatistics(let request):
            return request.toDictionary()
        case .gradeLastWeek(let request):
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
