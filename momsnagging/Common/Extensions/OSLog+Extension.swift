//
//  OSLog+Extension.swift
//  momsnagging
//
//  Created by suni on 2022/04/01.
//

import Foundation
import os.log

extension OSLog {
    static let subsystem = Bundle.main.bundleIdentifier!
    static let network = OSLog(subsystem: subsystem, category: "Network")
    static let debug = OSLog(subsystem: subsystem, category: "Debug")
    static let info = OSLog(subsystem: subsystem, category: "Info")
    static let error = OSLog(subsystem: subsystem, category: "Error")
}

struct Log {
    /**
     # (e) Level
     - Authors : suni
     - debug : 디버깅 모드 로그
     - info : 상세 오류
     - network : 네트워크 정보
     - error : 간단한 오류
     - custom(category: String) : 커스텀 디버깅 로그
     */
    enum Level {
        /// 디버깅 로그
        case debug
        /// 상세 Error
        case info
        /// 네트워크 로그
        case network
        /// 간단 Error
        case error
        case custom(category: String)
        
        fileprivate var category: String {
            switch self {
            case .debug:
                return "🟡 DEBUG"
            case .info:
                return "🟠 INFO"
            case .network:
                return "🔵 NETWORK"
            case .error:
                return "🔴 ERROR"
            case .custom(let category):
                return "🟢 \(category)"
            }
        }
        
        fileprivate var osLog: OSLog {
            switch self {
            case .debug:
                return OSLog.debug
            case .info:
                return OSLog.info
            case .network:
                return OSLog.network
            case .error:
                return OSLog.error
            case .custom:
                return OSLog.debug
            }
        }
        
        fileprivate var osLogType: OSLogType {
            switch self {
            case .debug:
                return .debug
            case .info:
                return .info
            case .network:
                return .default
            case .error:
                return .error
            case .custom:
                return .debug
            }
        }
    }
    
    static private func log(_ message: Any, _ arguments: [Any], level: Level) {
        #if DEBUG
        if #available(iOS 14.0, *) {
            let extraMessage: String = arguments.map({ String(describing: $0) }).joined(separator: " ")
            let logger = Logger(subsystem: OSLog.subsystem, category: level.category)
            let logMessage = "\(message) \(extraMessage)"
            switch level {
            case .debug,
                 .custom:
                logger.debug("\(logMessage, privacy: .public)")
            case .info:
                logger.info("\(logMessage, privacy: .public)")
            case .network:
                logger.log("\(logMessage, privacy: .public)")
            case .error:
                logger.error("\(logMessage, privacy: .public)")
            }
        } else {
            let extraMessage: String = arguments.map({ String(describing: $0) }).joined(separator: " ")
            os_log("%{public}@", log: level.osLog, type: level.osLogType, "\(message) \(extraMessage)")
        }
        #endif
    }
}

// MARK: - utils
extension Log {
    /**
     # debug
     - Authors : suni
     - Note : 개발 환경에서의 간단한 로깅
     */
    static func debug(_ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .debug)
    }

    /**
     # info
     - Authors : suni
     - Note : 상세한 오류
     */
    static func info(_ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .info)
    }

    /**
     # network
     - Authors : suni
     - Note : 네트워크 정보
     */
    static func network(_ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .network)
    }

    /**
     # error
     - Authors : suni
     - Note : 간단한 오류
     */
    static func error(_ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .network)
    }

    /**
     # custom
     - Authors : suni
     - Note : 커스텀 디버깅 로그
     */
    static func custom(category: String, _ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .custom(category: category))
    }
}
