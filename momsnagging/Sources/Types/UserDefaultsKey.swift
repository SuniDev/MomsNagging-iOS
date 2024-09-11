//
//  UserDefaultsKey.swift
//  momsnagging
//
//  Created by suni on 9/12/24.
//

import Foundation

struct UserDefaultsKey<T> {
    let key: String
}

extension UserDefaultsKey: ExpressibleByStringLiteral {
    public init(unicodeScalarLiteral value: StringLiteralType) {
        self.init(key: value)
    }

    public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        self.init(key: value)
    }

    public init(stringLiteral value: StringLiteralType) {
        self.init(key: value)
    }
}
