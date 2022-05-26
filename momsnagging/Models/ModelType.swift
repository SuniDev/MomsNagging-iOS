//
//  ModelType.swift
//  momsnagging
//
//  Created by suni on 2022/05/04.
//

import Foundation
import SwiftyJSON
import RxSwift

public protocol ALSwiftyJSONAble {
    init?(jsonData: JSON)
}

public protocol ModelType: ALSwiftyJSONAble {
    associatedtype Event
}

private var streams: [String: Any] = [:]

extension ModelType {
  static var event: PublishSubject<Event> {
    let key = String(describing: self)
    if let stream = streams[key] as? PublishSubject<Event> {
      return stream
    }
    let stream = PublishSubject<Event>()
    streams[key] = stream
    return stream
  }
}
