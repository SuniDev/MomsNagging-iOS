//
//  Moya+NetworkError.swift
//  momsnagging
//
//  Created by suni on 2022/05/04.
//

import Alamofire
import Moya

// Error 처리 시 사용되는 공통 기능 정의
extension TargetType {
    static func converToURLError(_ error: Error) -> URLError? {
      switch error {
//      case let MoyaError.underlying(afError as AFError, _):
//        fallthrough
      case let afError as AFError:
        return afError.underlyingError as? URLError
//      case let MoyaError.underlying(urlError as URLError, _):
//        fallthrough
      case let urlError as URLError:
        return urlError
      default:
        return nil
      }
    }
    static func isNotConnection(error: Error) -> Bool {
      Self.converToURLError(error)?.code == .notConnectedToInternet
    }
    
    static func isLostConnection(error: Error) -> Bool {
      switch error {
      case let AFError.sessionTaskFailed(error: posixError as POSIXError)
        where posixError.code == .ECONNABORTED: // eConnAboarted: Software caused connection abort.
        break
//      case let MoyaError.underlying(urlError as URLError, _):
//        fallthrough
//      case let urlError as URLError:
//        guard urlError.code == URLError.networkConnectionLost else { fallthrough } // A client or server connection was severed in the middle of an in-progress load.
      default:
        return false
      }
      return true
    }
}
