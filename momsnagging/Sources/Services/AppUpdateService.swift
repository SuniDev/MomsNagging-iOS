//
//  AppUpdateService.swift
//  momsnagging
//
//  Created by suni on 8/31/24.
//

import Foundation

import RxSwift
import FirebaseRemoteConfig

protocol AppUpdateServiceType {
    func fetchAppUpdateStatus() -> Observable<AppUpdateStatus>
}

/**
 # (C) AppUpdateService
 - Authors: suni
 - Note: 앱 업데이트  관련 서비스 클래스.
 */
final class AppUpdateService: BaseService, AppUpdateServiceType {
    func fetchAppUpdateStatus() -> Observable<AppUpdateStatus> {
        return Observable<AppUpdateStatus>.create { observer -> Disposable in
            let remoteConfig = RemoteConfig.remoteConfig()
            let setting = RemoteConfigSettings()
            setting.minimumFetchInterval = 0
            remoteConfig.configSettings = setting
            remoteConfig.setDefaults(fromPlist: "AppUpdateVersion")
            
            remoteConfig.fetch { status, _ in
                guard status == .success else {
                    Log.error("AppUpdateVersion Remote Config Error")
                    observer.onNext(.error)
                    observer.onCompleted()
                    return
                }
                
                remoteConfig.activate(completion: nil)
                
                let lastVersion = remoteConfig["latestUpdateVersion_iOS"].stringValue
                let forceVersion = remoteConfig["forceUpdateVersion_iOS"].stringValue
                
                Log.debug(lastVersion, forceVersion)
                
                if self.isInvalidVersion(forceVersion) || self.isInvalidVersion(lastVersion) {
                    observer.onNext(.error)
                    observer.onCompleted()
                    return
                }
                
                if self.isOldVersion(latest: forceVersion, current: Constants.appVersion) {
                    observer.onNext(.forceUpdate)
                } else if self.isOldVersion(latest: lastVersion, current: Constants.appVersion) {
                    observer.onNext(.selectUpdate)
                } else {
                    observer.onNext(.latestVersion)
                }
                
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    private func isInvalidVersion(_ version: String) -> Bool {
        return version.split(separator: ".").count != 3
    }
    
    private func isOldVersion(latest: String, current: String) -> Bool {
        let latestVersionComponents = latest.split(separator: ".").compactMap { Int($0) }
        let currentVersionComponents = current.split(separator: ".").compactMap { Int($0) }
        
        for (latest, current) in zip(latestVersionComponents, currentVersionComponents) {
            if latest > current {
                return true
            } else if latest < current {
                return false
            }
        }
        return latestVersionComponents.count > currentVersionComponents.count
    }
}
