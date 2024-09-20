// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// 알럿 문구
  internal static let cancel = L10n.tr("Localizable", "cancel", fallback: "취소")
  /// 닫기
  internal static let close = L10n.tr("Localizable", "close", fallback: "닫기")
  /// 네, 삭제할게요
  internal static let delete = L10n.tr("Localizable", "delete", fallback: "네, 삭제할게요")
  /// 설정
  internal static let deleteAccount = L10n.tr("Localizable", "delete_account", fallback: "정말로 탈퇴하시겠습니까?")
  /// 지금 나가면 일기가 저장되지 않는단다.
  /// 그래도 나가겠니?
  internal static let diaryBack = L10n.tr("Localizable", "diary_back", fallback: "지금 나가면 일기가 저장되지 않는단다.\n그래도 나가겠니?")
  /// 일기를 삭제하면 되돌릴 수 없단다.
  /// 그래도 삭제하겠니?
  internal static let diaryDelete = L10n.tr("Localizable", "diary_delete", fallback: "일기를 삭제하면 되돌릴 수 없단다.\n그래도 삭제하겠니?")
  /// 확인
  internal static let done = L10n.tr("Localizable", "done", fallback: "확인")
  /// 뒤로가기
  internal static let habitBack = L10n.tr("Localizable", "habit_back", fallback: "지금 나가면 습관이 저장되지 않는단다.\n그래도 나가겠니?")
  /// 삭제
  internal static let habitDelete = L10n.tr("Localizable", "habit_delete", fallback: "습관을 삭제하면 되돌릴 수 없단다.\n그래도 삭제하겠니?")
  /// 로그아웃 할꺼니?
  internal static let logout = L10n.tr("Localizable", "logout", fallback: "로그아웃 할꺼니?")
  /// 네트워크
  internal static let networkErrorMessage = L10n.tr("Localizable", "network_error_message", fallback: "네트워크 연결이 실패했단다.\n다시 시도 해주겠니?")
  /// 우리
  internal static let nicknameConfirm = L10n.tr("Localizable", "nickname_confirm", fallback: "우리")
  /// 네 엄마!
  internal static let nicknameDoneTitle = L10n.tr("Localizable", "nickname_done_title", fallback: "네 엄마!")
  /// 띄어쓰기 포함 한/영/숫자 1-10글자
  internal static let nicknamePlaceholder = L10n.tr("Localizable", "nickname_placeholder", fallback: "띄어쓰기 포함 한/영/숫자 1-10글자")
  /// 이렇게요!
  internal static let nicknameSettingDone = L10n.tr("Localizable", "nickname_setting_done", fallback: "이렇게요!")
  /// 다른 이름을 생각해보겠니?
  internal static let nicknameSettingError = L10n.tr("Localizable", "nickname_setting_error", fallback: "다른 이름을 생각해보겠니?")
  /// 띄어쓰기 포함 한/영/숫자 10글자 이내
  internal static let nicknameSettingPlaceholder = L10n.tr("Localizable", "nickname_setting_placeholder", fallback: "띄어쓰기 포함 한/영/숫자 10글자 이내")
  /// 엄마가 뭐라고 불러줄까?
  internal static let nicknameSettingTitle = L10n.tr("Localizable", "nickname_setting_title", fallback: "엄마가 뭐라고 불러줄까?")
  /// 호칭 설정
  internal static let nicknameSuccess = L10n.tr("Localizable", "nickname_success", fallback: "굿 네이밍^^\n참고로 호칭 변경은 '마이'에서 가능하단다.")
  /// 아니요
  internal static let no = L10n.tr("Localizable", "no", fallback: "아니요")
  /// 온보딩
  internal static let onboardingTitle1 = L10n.tr("Localizable", "onboarding_title1", fallback: "1. 습관/할일 추가")
  /// 2. 추천 습관
  internal static let onboardingTitle2 = L10n.tr("Localizable", "onboarding_title2", fallback: "2. 추천 습관")
  /// 3. 엄마가 잔소리 해주는 PUSH 알림
  internal static let onboardingTitle3 = L10n.tr("Localizable", "onboarding_title3", fallback: "3. 엄마가 잔소리 해주는 PUSH 알림")
  /// 4. 3가지 타입의 잔소리 성격 설정
  internal static let onboardingTitle4 = L10n.tr("Localizable", "onboarding_title4", fallback: "4. 3가지 타입의 잔소리 성격 설정")
  /// 5. 기타 기능
  internal static let onboardingTitle5 = L10n.tr("Localizable", "onboarding_title5", fallback: "5. 기타 기능")
  /// 마이
  internal static let statusmsgDefault = L10n.tr("Localizable", "statusmsg_default", fallback: "오늘 하루도 파이팅 🔥")
  /// 이렇게 할게요!
  internal static let statusmsgModifyDone = L10n.tr("Localizable", "statusmsg_modify_done", fallback: "이렇게 할게요!")
  /// 다른 각오를 생각해보겠니?
  internal static let statusmsgModifyError = L10n.tr("Localizable", "statusmsg_modify_error", fallback: "다른 각오를 생각해보겠니?")
  /// 띄어쓰기 포함 한/영/특수문자 30글자 이내
  internal static let statusmsgModifyPlaceholder = L10n.tr("Localizable", "statusmsg_modify_placeholder", fallback: "띄어쓰기 포함 한/영/특수문자 30글자 이내")
  /// 각오 한마디 적어볼래?
  internal static let statusmsgModifyTitle = L10n.tr("Localizable", "statusmsg_modify_title", fallback: "각오 한마디 적어볼래?")
  /// 주신 의견을 반영하여 더 나은 엄마의 잔소리가 되겠습니다.
  /// 감사합니다!
  internal static let successAccount = L10n.tr("Localizable", "success_account", fallback: "주신 의견을 반영하여 더 나은 엄마의 잔소리가 되겠습니다.\n감사합니다!")
  /// 지금 나가면 할일이 저장되지 않는단다.
  /// 그래도 나가겠니?
  internal static let todoBack = L10n.tr("Localizable", "todo_back", fallback: "지금 나가면 할일이 저장되지 않는단다.\n그래도 나가겠니?")
  /// 할일을 삭제하면 되돌릴 수 없단다.
  /// 그래도 삭제하겠니?
  internal static let todoDelete = L10n.tr("Localizable", "todo_delete", fallback: "할일을 삭제하면 되돌릴 수 없단다.\n그래도 삭제하겠니?")
  /// 다음에 할게요
  internal static let updateCancel = L10n.tr("Localizable", "update_cancel", fallback: "다음에 할게요")
  /// 업데이트 안내
  internal static let updateDone = L10n.tr("Localizable", "update_done", fallback: "업데이트")
  /// 우리 아들, 딸들의 의견을 반영해서
  /// 사용성을 개선했는데
  /// 지금 바로 업데이트 해보겠니~?
  internal static let updateMessage = L10n.tr("Localizable", "update_message", fallback: "우리 아들, 딸들의 의견을 반영해서\n사용성을 개선했는데\n지금 바로 업데이트 해보겠니~?")
  /// 새로운 버전이 업데이트 되었단다!
  internal static let updateTitle = L10n.tr("Localizable", "update_title", fallback: "새로운 버전이 업데이트 되었단다!")
  /// 네
  internal static let yes = L10n.tr("Localizable", "yes", fallback: "네")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
