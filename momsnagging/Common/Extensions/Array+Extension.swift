// swiftlint:disable all
//  Array+Extension.swift
//  momsnagging
//
//  Created by suni on 2022/05/13.
//

import Foundation

extension Array {
    /**
     # contains<T>
     - Author: suni
     - Returns: Bool
     - Note: obj값을 현재 Array에서 포함하는지 여부를 반환
    */
    func contains<T>(obj: T) -> Bool where T: Equatable {
        return self.filter({ $0 as? T == obj }).count > 0
    }
}

extension Array where Element: Equatable {
    
    /**
     # removed
     - Author: suni
     - Parameters:
        - item: Array의 Element
     - Returns: Bool
     - Note: item을 제거한 배열을 반환
    */
    public func removed(_ item: Element) -> [Element] {
        return self.filter({ $0 != item })
    }
}
