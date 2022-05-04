//
//  MomsNaggingAPI+Task.swift
//  momsnagging
//
//  Created by suni on 2022/05/04.
//

import Moya

extension MomsNaggingAPI {
  func getTask() -> Task {
      /* example
       Body로 보내는 거면 하단 처럼 따로 설정.
       
       case .MAMAVoteSend(let bodyRequest):
       return Task.requestCompositeData(bodyData: bodyRequest.data(using:.utf8)!, urlParameters: [:])
       */
    switch self {
    case .getUserInfo(let request):
        return .requestParameters(parameters: request.toDictionary(), encoding: URLEncoding.queryString)
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
