//
//  AppMoyaProvider.swift
//  momsnagging
//
//  Created by suni on 2022/05/26.
//

import Moya
import RxSwift

/**
 # (C) AppMoyaProvider
 - Authors: suni
 - Note: Moya 네트워크 통신을 담당하는 Provider를 커스터마이징한 클래스.
 */

class AppMoyaProvider<T: TargetType>: MoyaProvider<T> {
   // StubClosure => Unit Test에서 주로 사용되며, 클로저를 추가할 경우, API를 타지 않고 sample data에서 json을 꺼내와서 사용할 수 있음.
   init(stubClosure: @escaping StubClosure = MoyaProvider.neverStub) {
       // Network 시작 / 종료에 관한 처리를 하는 클로저
       let networkClosure = { (_ change: NetworkActivityChangeType, _ target: TargetType) in
           switch change {
           case .began:
               break
           case .ended:
               break
           }
       }
       super.init(stubClosure: stubClosure,
                  session: Session(),
                  plugins: [NetworkLoggerPlugin(),
                            NetworkActivityPlugin(networkActivityClosure: networkClosure)])
   }
}

