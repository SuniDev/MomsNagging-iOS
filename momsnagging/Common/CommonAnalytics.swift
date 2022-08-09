//
//  CommonAnalytics.swift
//  momsnagging
//
//  Created by suni on 2022/08/03.
//

import Foundation
import FirebaseAnalytics

struct CommonAnalyticsParam: Equatable {
    var screen_name: String?
    var user_name: String?
    var sns_type: String?
}

class CommonAnalytics: NSObject {
    
    static func setUserId() {
        if let authorization = CommonUser.authorization {
            Analytics.setUserID(authorization)
        } else {
            Analytics.setUserID("unknown")
        }
    }
    
    enum EventId: CustomStringConvertible {
        case screen_view                // 화면
        case sign_up                    // 회원 가입
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
                case .screen_view:
                    return "screen_view"
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
        case ONBOARD
        case LOGIN
        case ID
        case COACHMARK
        case HOME
        case HABIT_DETAIL
        case HABIT_ADD
        case HABIT_ADD_OWN
        case HABIT_ADD_RECOMMEND
        case TODO_DETAIL
        case TODO_ADD
        case DIARY_WRITE
        case GRADECARD_STATISTICS
        case GRADECARD_CALENDAR
        case MY
                
        var description: String {
            switch self {
            case .ONBOARD:
                return "onboard"
            case .LOGIN:
                return "login"
            case .ID:
                return "id"
            case .COACHMARK:
                return "coachmark"
            case .HOME:
                return "home"
            case .HABIT_DETAIL:
                return "habit_detail"
            case .HABIT_ADD:
                return "habit_add"
            case .HABIT_ADD_OWN:
                return "habit_add_own"
            case .HABIT_ADD_RECOMMEND:
                return "habit_add_recommend"
            case .TODO_DETAIL:
                return "todo_detail"
            case .TODO_ADD:
                return "todo_add"
            case .DIARY_WRITE:
                return "diary_write"
            case .GRADECARD_STATISTICS:
                return "gradecard_statistics"
            case .GRADECARD_CALENDAR:
                return "gradecard_calendar"
            case .MY:
                return "my"
            }
        }
    }
    
    static func logEvent(_ eventId: EventId) {
        
        let eventName = eventId.description
        var parameters: [String: Any] = [:]
        let param = eventId.param
        
        Log.debug("GA Log Event : \(eventName)")
        
        DispatchQueue.main.async {
            switch eventId {
            case .screen_view:
                parameters[AnalyticsParameterScreenName] = param?.screen_name
                Analytics.logEvent(eventName, parameters: parameters)
            case .sign_up:
                parameters["user_name"] = param?.user_name
                parameters["sns_type"] = param?.sns_type
                Analytics.logEvent(eventName, parameters: parameters)
            case .first_app_entry, .first_onboard_view, .first_login_view, .first_id_view, .first_coachmark_view, .first_home_view:
                Analytics.logEvent(eventName, parameters: parameters)
            case .tap_coachmark_skip, .tap_home_plus_button, .tap_home_checkbox_habit, .tap_home_checkbox_todo, .tap_home_monthly_calendar, .tap_home_diary, .tap_tab_home, .tap_tab_gradecard, .tap_tab_my, .tap_diary_write:
                Analytics.logEvent(eventName, parameters: parameters)
            }
        }
        
    }
}
