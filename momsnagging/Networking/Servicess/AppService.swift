//
//  AppService.swift
//  momsnagging
//
//  Created by suni on 2022/05/26.
//

import Foundation

/**
 # (S) AppServices
 - Author: suni
 - Note: 앱에서 사용될 서비스를 관리하는 구조체
*/
struct AppServices: AppAuthService, AppUserService, AppDiaryService, AppGradeService {
    let authService: AuthService
    let userService: UserService
    let diaryService: DiaryService
    let gradeService: GradeService
}
