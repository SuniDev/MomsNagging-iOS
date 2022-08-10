//
//  CommonAnalytics.swift
//  momsnagging
//
//  Created by suni on 2022/08/03.
//

import Foundation
import FirebaseAnalytics

struct CommonAnalyticsParam: Equatable {
    var nick_name: String?
    var sns_type: String?
}

class CommonAnalytics: NSObject {
    
    static var isFirstLogin: Bool = false    // 신규 사용자
    static var isFirstId: Bool = false    // 신규 사용자
    static var isFirst: Bool = false    // 신규
    
    static func setUserId() {
        
        if let authorization = CommonUser.authorization {
            Log.info("GA Log setUserId : \(authorization)")
            Analytics.setUserID(authorization)
        } else {
            Log.info("GA Log setUserId : unknown")
            Analytics.setUserID("unknown")
        }
    }
    
    enum EventId: CustomStringConvertible {
        case sign_up(CommonAnalyticsParam)  // 회원 가입
        // FIRST
        case first_app_entry
        case first_onboard_view
        case first_login_view
        case first_id_view
        case first_coachmark_view
        case first_home_view
        // TAP
        /// 코치마크
        case tap_coachmark_skip
        /// 홈
        case tap_home_plus_button
        case tap_home_checkbox_habit
        case tap_home_checkbox_todo
        case tap_home_monthly_calendar
        case tap_home_diary
        /// 탭
        case tap_tab_home
        case tap_tab_gradecard
        case tap_tab_my
        /// 일기장
        case tap_diary_write
        
        var param: CommonAnalyticsParam? {
            let mirror = Mirror(reflecting: self)
            for case let (_, analys) in mirror.children {
                if let v = analys as? CommonAnalyticsParam {
                    return v
                } else {
                    return nil
                }
            }
            return nil
        }
        
        var description: String {
                switch self {
                case .sign_up:
                    return "sign_up"
                case .first_app_entry:
                    return "first_app_entry"
                case .first_onboard_view:
                    return "first_onboard_view"
                case .first_login_view:
                    return "first_login_view"
                case .first_id_view:
                    return "first_id_view"
                case .first_coachmark_view:
                    return "first_coachmark_view"
                case .first_home_view:
                    return "first_home_view"
                case .tap_coachmark_skip:
                    return "tap_coachmark_skip"
                case .tap_home_plus_button:
                    return "tap_home_plus_button"
                case .tap_home_checkbox_habit:
                    return "tap_home_checkbox_habit"
                case .tap_home_checkbox_todo:
                    return "tap_home_checkbox_todo"
                case .tap_home_monthly_calendar:
                    return "tap_home_monthly_calendar"
                case .tap_home_diary:
                    return "tap_home_diary"
                case .tap_tab_home:
                    return "tap_tab_home"
                case .tap_tab_gradecard:
                    return "tap_tab_gradecard"
                case .tap_tab_my:
                    return "tap_tab_my"
                case .tap_diary_write:
                    return "tap_diary_write"
                }
        }
    }
        
    enum ScreenName: CustomStringConvertible {
        case onboard
        case login
        case id
        case coachmark
        case home
        case habit_add
        case habit_add_own
        case habit_add_recommend
        case habit_modify
        case todo_add
        case todo_modify
        case diary_detail
        case diary_write
        case gradecard_statistics
        case gradecard_calendar
        case my
                
        var description: String {
            switch self {
            case .onboard:
                return "onboard"
            case .login:
                return "login"
            case .id:
                return "id"
            case .coachmark:
                return "coachmark"
            case .home:
                return "home"
            case .habit_add:
                return "habit_add"
            case .habit_add_own:
                return "habit_add_own"
            case .habit_add_recommend:
                return "habit_add_recommend"
            case .habit_modify:
                return "habit_modify"
            case .todo_add:
                return "todo_add"
            case .todo_modify:
                return "todo_modify"
            case .diary_detail:
                return "diary_detail"
            case .diary_write:
                return "diary_write"
            case .gradecard_statistics:
                return "gradecard_statistics"
            case .gradecard_calendar:
                return "gradecard_calendar"
            case .my:
                return "my"
            }
        }
    }
    
    static func logEvent(_ eventId: EventId) {
        
        let eventName = eventId.description
        var parameters: [String: Any] = [:]
        let param = eventId.param
        
        Log.info("GA Log Event : \(eventName)")
        
        DispatchQueue.main.async {
            switch eventId {
            case .sign_up:
                parameters["nick_name"] = param?.nick_name
                parameters["sns_type"] = param?.sns_type
                Analytics.logEvent(eventName, parameters: parameters)
            case .first_app_entry:
                CommonAnalytics.isFirst = true
                CommonAnalytics.isFirstLogin = true
                CommonAnalytics.isFirstId = true
            case .first_login_view:
                CommonAnalytics.isFirstLogin = false
            case .first_id_view:
                CommonAnalytics.isFirstId = false
            case .first_home_view:
                CommonAnalytics.isFirst = false
            case .first_onboard_view, .first_coachmark_view:
                Analytics.logEvent(eventName, parameters: parameters)
            case .tap_coachmark_skip, .tap_home_plus_button, .tap_home_checkbox_habit, .tap_home_checkbox_todo, .tap_home_monthly_calendar, .tap_home_diary, .tap_tab_home, .tap_tab_gradecard, .tap_tab_my, .tap_diary_write:
                Analytics.logEvent(eventName, parameters: parameters)
            }
        }
    }
    
    static func logScreenView(_ screenName: ScreenName) {
        Log.info("GA Log ScreenView : \(screenName.description)")
        
        DispatchQueue.main.async {
            Analytics.logEvent(AnalyticsEventScreenView, parameters: [AnalyticsParameterScreenName: screenName.description])
        }
    }
}
