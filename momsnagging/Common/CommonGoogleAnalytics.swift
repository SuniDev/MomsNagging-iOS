//
//  CommonGoogleAnalytics.swift
//  momsnagging
//
//  Created by suni on 2022/08/03.
//

import Foundation
import FirebaseAnalytics

struct CommonAnalyticsParam: Equatable {
    var SCREEN_NAME: String?
    var USER_NAME: String?
    var SNS_TYPE: String?
}

class CommonAnalytics: NSObject {
    
    static func setUserId() {
        if let authorization = CommonUser.authorization {
            Analytics.setUserID(authorization)
        } else {
            Analytics.setUserID("unknown")
        }
    }
    
    enum eventId: CustomStringConvertible {
        case SCREEN_VIEW                // 화면
        case SIGN_UP                    // 회원 가입
        // FIRST
        case FIRST_APP_ENTRY
        case FIRST_ONBOARD_VIEW
        case FIRST_LOGIN_VIEW
        case FIRST_ID_VIEW
        case FIRST_COACHMARK_VIEW
        case FIRST_HOME_VIEW
        // TAP
        /// 코치마크
        case TAP_COACHMARK_SKIP
        /// 홈
        case TAP_HOME_PLUS_BUTTON
        case TAP_HOME_CHECKBOX_HABIT
        case TAP_HOME_CHECKBOX_TODO
        case TAP_HOME_MONTHLY_CALENDAR
        case TAP_HOME_DIARY
        /// 탭
        case TAP_TAB_HOME
        case TAP_TAB_GRADECARD
        case TAP_TAB_MY
        /// 일기장
        case TAP_DIARY_WRITE
        
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
            get {
                switch self {
                case .SCREEN_VIEW:
                    return "screen_view"
                case .SIGN_UP:
                    return "sign_up"
                case .FIRST_APP_ENTRY:
                    return "first_app_entry"
                case .FIRST_ONBOARD_VIEW:
                    return "first_onboard_view"
                case .FIRST_LOGIN_VIEW:
                    return "first_login_view"
                case .FIRST_ID_VIEW:
                    return "first_id_view"
                case .FIRST_COACHMARK_VIEW:
                    return "first_coachmark_view"
                case .FIRST_HOME_VIEW:
                    return "first_home_view"
                case .TAP_COACHMARK_SKIP:
                    return "tap_coachmark_skip"
                case .TAP_HOME_PLUS_BUTTON:
                    return "tap_home_plus_button"
                case .TAP_HOME_CHECKBOX_HABIT:
                    return "tap_home_checkbox_habit"
                case .TAP_HOME_CHECKBOX_TODO:
                    return "tap_home_checkbox_todo"
                case .TAP_HOME_MONTHLY_CALENDAR:
                    return "tap_home_monthly_calendar"
                case .TAP_HOME_DIARY:
                    return "tap_home_diary"
                case .TAP_TAB_HOME:
                    return "tap_tab_home"
                case .TAP_TAB_GRADECARD:
                    return "tap_tab_gradecard"
                case .TAP_TAB_MY:
                    return "tap_tab_my"
                case .TAP_DIARY_WRITE:
                    return "tap_diary_write"
                }
        }
        
    }
        
    enum 
    
    static func logEvent(_ eventId: eventId) {
        
        let eventName = eventId.description
        var parameters: [String: Any] = [:]
        let param = eventId.param
        
        Log.debug("로그 GA : \(eventName)")
        
        DispatchQueue.main.async {
            switch eventId {
                
            case .SCREEN_VIEW:
                parameters[AnalyticsParameterScreenName] = param?.SCREEN_NAME
                Analytics.logEvent(eventName, parameters: parameters)
        }
    }
}
