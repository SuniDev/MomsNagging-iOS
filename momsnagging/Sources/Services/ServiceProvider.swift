//
//  ServiceProvider.swift
//  momsnagging
//
//  Created by suni on 8/31/24.
//

protocol ServiceProviderType: AnyObject {
    var userDefaultsService: UserDefaultsService { get }
    var appUpdateService: AppUpdateService { get }
}

final class ServiceProvider: ServiceProviderType {
    lazy var userDefaultsService: UserDefaultsService = UserDefaultsService(provider: self)
    lazy var appUpdateService: AppUpdateService = AppUpdateService(provider: self)
}
