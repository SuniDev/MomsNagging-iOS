//
//  ServiceProvider.swift
//  momsnagging
//
//  Created by suni on 8/31/24.
//

protocol ServiceProviderType: AnyObject {
    var userService: UserService { get }
}

final class ServiceProvider: ServiceProviderType {
    lazy var userService: UserService = UserService(provider: self)
}
