//
//  UserDefaultsService.swift
//  momsnagging
//
//  Created by suni on 9/12/24.
//
import Foundation

import RxSwift

extension UserDefaultsKey {
    static var isFirstLaunch: UserDefaultsKey<Bool> { return "isFirstLaunch" }
}

protocol UserDefaultsServiceType {
    func value<T>(forKey key: UserDefaultsKey<T>) -> Single<T?>
    func set<T>(value: T?, forKey key: UserDefaultsKey<T>) -> Completable
}

final class UserDefaultsService: BaseService, UserDefaultsServiceType {
    
    private var defaults: UserDefaults {
        return UserDefaults.standard
    }

    // 값을 비동기적으로 가져오는 메서드
    func value<T>(forKey key: UserDefaultsKey<T>) -> Single<T?> {
        return Single.create { single in
            let value = self.defaults.value(forKey: key.key) as? T
            single(.success(value))  // 성공적으로 값을 반환
            return Disposables.create()  // 리소스 해제 시 동작
        }
    }

    // 값을 비동기적으로 설정하는 메서드
    func set<T>(value: T?, forKey key: UserDefaultsKey<T>) -> Completable {
        return Completable.create { completable in
            self.defaults.set(value, forKey: key.key)
            self.defaults.synchronize()
            completable(.completed)  // 작업 완료
            return Disposables.create()  // 리소스 해제 시 동작
        }
    }
}
