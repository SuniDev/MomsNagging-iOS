//
//  MomsNaggingAPI+Request.swift
//  momsnagging
//
//  Created by suni on 2022/05/04.
//

import RxSwift
import Moya
import Alamofire
import Then

// MARK: Error Type
// MoyaProvider인스턴를 이용하여 request하는 기능 정의 + Error Handleing "MomsNaggingAPIError+Request"
enum MomsNaggingAPIError: Error {
  case empty
  case requestTimeout(Error)
  case internetConnection(Error)
  case restError(Error, statusCode: Int? = nil, errorCode: String? = nil)
  
  var statusCode: Int? {
    switch self {
    case let .restError(_, statusCode, _):
      return statusCode
    default:
      return nil
    }
  }
  var errorCodes: [String] {
    switch self {
    case let .restError(_, _, errorCode):
      return [errorCode].compactMap { $0 }
    default:
      return []
    }
  }
  var isNoNetwork: Bool {
    switch self {
//    case let .requestTimeout(error):
//      fallthrough
    case let .restError(error, _, _):
      return MomsNaggingAPI.isNotConnection(error: error) || MomsNaggingAPI.isLostConnection(error: error)
    case .internetConnection:
      return true
    default:
      return false
    }
  }
}
// MARK: Moya Wrapper
// 해당 부분에서 PluginType을 삽입
extension MomsNaggingAPI {
  struct Wrapper: TargetType {
    let base: MomsNaggingAPI
    
    var baseURL: URL { self.base.baseURL }
    var path: String { self.base.path }
    var method: Moya.Method { self.base.method }
    var sampleData: Data { self.base.sampleData }
    var task: Task { self.base.task }
    var headers: [String: String]? { self.base.headers }
  }
  
  private enum MoyaWrapper {
    struct Plugins {
      var plugins: [PluginType]
      
      init(plugins: [PluginType] = []) {
        self.plugins = plugins
      }
      
      func callAsFunction() -> [PluginType] { self.plugins }
    }
    
    static var provider: MoyaProvider<MomsNaggingAPI.Wrapper> {
      let plugins = Plugins(plugins: [])
      
      let configuration = URLSessionConfiguration.default
      configuration.timeoutIntervalForRequest = 30
      configuration.urlCredentialStorage = nil
      let session = Session(configuration: configuration)
      
      return MoyaProvider<MomsNaggingAPI.Wrapper>(
        endpointClosure: { target in
          MoyaProvider.defaultEndpointMapping(for: target)
        },
        session: session,
        plugins: plugins()
      )
    }
  }
}

// MARK: Error Handling
// 인터넷 연결 에러, TimeOut 에러, 일반 에러를 처리하는 메소드 정의
// (request의 응답값에서 해당 에러처리 메소드를 부르도록 설계)
extension MomsNaggingAPI {
  private func handleInternetConnection<T: Any>(error: Error) throws -> Single<T> {
    guard
      let urlError = Self.converToURLError(error),
      Self.isNotConnection(error: error)
    else { throw error }
    throw MomsNaggingAPIError.internetConnection(urlError)
  }
    
    private func handleTimeOut<T: Any>(error: Error) throws -> Single<T> {
      guard
        let urlError = Self.converToURLError(error),
        urlError.code == .timedOut
      else { throw error }
      throw MomsNaggingAPIError.requestTimeout(urlError)
    }
  
  private func handleREST<T: Any>(error: Error) throws -> Single<T> {
    guard error is MomsNaggingAPIError else {
      throw MomsNaggingAPIError.restError(
        error,
        statusCode: (error as? MoyaError)?.response?.statusCode,
        errorCode: (try? (error as? MoyaError)?.response?.mapJSON() as? [String: Any])?["code"] as? String
      )
    }
    throw error
  }
}

// MARK: Moya Request
// request하는 메소드 정의
// log를 해당 부분에서 출력
extension MomsNaggingAPI {
  static let moya = MoyaWrapper.provider
  
  static var jsonDecoder: JSONDecoder {
    let decoder = JSONDecoder()
    return decoder
  }
  
  func request(
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
  ) -> Single<Response> {
    
    let endpoint = MomsNaggingAPI.Wrapper(base: self)
    let requestString = "\(endpoint.method) \(endpoint.baseURL) \(endpoint.path)"

    return Self.moya.rx.request(endpoint)
      .filterSuccessfulStatusCodes()
      .catch(self.handleInternetConnection)
      .catch(self.handleTimeOut)
      .catch(self.handleREST)
      .do(
        onSuccess: { response in
          let requestContent = "🛰 SUCCESS: \(requestString) (\(response.statusCode))"
            Log.network(requestContent, file, function, line)
        },
        onError: { rawError in
          switch rawError {
          case MomsNaggingAPIError.requestTimeout:
              Log.network("TODO: alert MomsNaggingAPIError.requestTimeout")
          case MomsNaggingAPIError.internetConnection:
              Log.network("TODO: alert MomsNaggingAPIError.internetConnection")
          case let MomsNaggingAPIError.restError(error, _, _):
            guard let response = (error as? MoyaError)?.response else { break }
            if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
              let errorDictionary = jsonObject as? [String: Any]
              guard let key = errorDictionary?.first?.key else { return }
              let message: String
              if let description = errorDictionary?[key] as? String {
                message = "🛰 FAILURE: \(requestString) (\(response.statusCode)\n\(key): \(description)"
              } else if let description = (errorDictionary?[key] as? [String]) {
                message = "🛰 FAILURE: \(requestString) (\(response.statusCode))\n\(key): \(description)"
              } else if let rawString = String(data: response.data, encoding: .utf8) {
                message = "🛰 FAILURE: \(requestString) (\(response.statusCode))\n\(rawString)"
              } else {
                message = "🛰 FAILURE: \(requestString) (\(response.statusCode)"
              }
                Log.network(message)
            }
          default:
            break
          }
        },
        onSubscribe: {
          let message = "REQUEST: \(requestString)"
            Log.network(message, file, function, line)
        }
      )
  }
}
