//
//  ServiceProvider.swift
//  momsnagging
//
//  Created by suni on 8/31/24.
//

protocol ServiceProviderType: AnyObject {
    var userService: UserService { get }
    var appUpdateService: AppUpdateService { get }
}

final class ServiceProvider: ServiceProviderType {
    lazy var userService: UserService = UserService(provider: self)
    lazy var appUpdateService: AppUpdateService = AppUpdateService(provider: self)
}
