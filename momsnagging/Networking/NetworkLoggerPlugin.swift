//
//  NetworkLoggerPlugin.swift
//  momsnagging
//
//  Created by suni on 2022/05/26.
//

import Moya

/**
   # (C) NetworkLoggerPlugin
 - Authors: suni
 - Note: API 통신 간의 커스텀 로깅을 위한 클래스
   */
final class NetworkLoggerPlugin: PluginType {
    
    /**
     # willSend
     - Parameters:
         - request : Request 타입 (URLRequest)
         - target : Target 타입 (MomsNaggingAPI에 정의된 내용)
     - Returns:
     - Note: API를 보내기 직전에 호출 - URL, header, path등
     */
    func willSend(_ request: RequestType, target: TargetType) {
        let headers = request.request?.allHTTPHeaderFields ?? [:]
        let urlStr = request.request?.url?.absoluteString ?? "nil"
        let path = urlStr.replacingOccurrences(of: "\(MomsNaggingAPI.baseUrl())", with: "")
        if let body = request.request?.httpBody {
            let bodyString = String(bytes: body, encoding: .utf8) ?? "nil"
            let message: String = """
                                    
            ---------- HTTP REQUEST ----------
            <target - \(target)>
            path: \(path) - \(Date().debugDescription)
            url: \(urlStr)
            headers: \(headers)
            body: \(bodyString)
            --------------------------------
            
            """
            Log.network(message)
        } else {
            let message: String = """
                        
            ---------- HTTP REQUEST ----------
            <target - \(target)>
            path: \(path) - \(Date().debugDescription)
            url: \(urlStr)
            headers: \(headers)
            body: nil
            --------------------------------
            
            """
            Log.network(message)
        }
    }
    
    /**
     # didReceive
     - Authors: suni\
     - Parameters:
         - result : Network 통신 결과 response값
         - target : Target 타입 (MomsNaggingAPI에 정의된 내용)
     - Returns:
     - Note: API를 통해 받은 데이터 처리
     */
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        
        switch result {
        case let .success(response):
            onSuceed(response, target: target, isFromError: false)
        case let .failure(error):
            onFail(error, target: target)
        }
    }
    
    func onSuceed(_ response: Response, target: TargetType, isFromError: Bool) {
        let request = response.request
        let urlStr = request?.url?.absoluteString ?? "nil"
        let method = request?.httpMethod ?? "nil"
        let statusCode = response.statusCode
        var bodyString = "nil"
        if let data = request?.httpBody,
           let string = String(bytes: data, encoding: .utf8) {
            bodyString = string
        }
        
        var responseString = "nil"
        let data = response.data
       if let responseStr = String(bytes: data, encoding: .utf8) {
        responseString = responseStr
       }

        let message: String = """
        
        ---------- HTTP RESPONSE ----------
        <target - \(target)>
        method : \(method)
        statusCode: \(statusCode)
        url: \(urlStr)
        body: \(bodyString)
        response: \(responseString)
        --------------------------------
        """
        Log.network(message)
    }
    
    func onFail(_ error: MoyaError, target: TargetType) {
        if let response = error.response {
           onSuceed(response, target: target, isFromError: true)
           return
       }
        let message: String = """
        
        ---------- HTTP ERROR ----------
        <target - \(target)>
        errorCode: \(error.errorCode)
        errorMessage : \(error.failureReason ?? error.errorDescription ?? "unknown erro")
        --------------------------------
        
        """
        Log.network(message)
    }
}
