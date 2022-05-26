//
//  Networking.swift
//  momsnagging
//
//  Created by suni on 2022/05/26.
//

import Moya
import RxSwift


typealias AppNetworking = Networking<MomsNaggingAPI>

/**
 # (C) Networking
 - Authors: suni
 - Note: Moya Provider를 이용해 request 통신을 담당하는 클래스
 */
final class Networking<Target: TargetType>: MoyaProvider<Target> {
    
    /**
     # request
     - Author: suni
     - Date: 20.07.16
     - parameters:
     - target : Call API에 정의한 enum 케이스 중에서 현재 요청할 API
     - returns: Single<Response>
     - Note: Moya request를 커스텀하여 결과값 로그 및 네트워크 상태 코드가 정상인 경우만 필터해서 받는 Single 생성.
     */
    func request(_ target: Target) -> Single<Response> {
        let requestString = "\(target.method.rawValue) \(target.path)"
        return self.rx.request(target)
            .do(
                onSuccess: { value in
                    let message = "📡 SUCCESS: \(requestString) (\(value.statusCode))"
                    Log.network(message)
                },
                onError: { error in
                    if let response = (error as? MoyaError)?.response {
                        if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
                            let message = "📡 FAILURE: \(requestString) (\(response.statusCode))\n\(jsonObject)"
                            Log.network(message)
                        } else if let rawString = String(data: response.data, encoding: .utf8) {
                            let message = "📡 FAILURE: \(requestString) (\(response.statusCode))\n\(rawString)"
                            Log.network(message)
                        } else {
                            let message = "📡 FAILURE: \(requestString) (\(response.statusCode))"
                            Log.network(message)
                        }
                    } else {
                        let message = "📡 FAILURE: \(requestString)\n\(error)"
                        Log.network(message)
                    }
                },
                onSubscribed: {
                    let message = "📡 REQUEST: \(requestString)"
                    Log.network(message)
                }
            )
    }
}
