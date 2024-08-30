//
//  BaseService.swift
//  momsnagging
//
//  Created by suni on 8/31/24.
//

import Foundation

class BaseService {
  unowned let provider: ServiceProviderType

  init(provider: ServiceProviderType) {
    self.provider = provider
  }
}
