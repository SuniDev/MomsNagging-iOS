// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Assets {
    internal static let accentColor = ColorAsset(name: "AccentColor")
    internal static let addhabitTip = ImageAsset(name: "addhabit_tip")
    internal static let awardDisable1 = ImageAsset(name: "awardDisable1")
    internal static let awardDisable2 = ImageAsset(name: "awardDisable2")
    internal static let awardDisable3 = ImageAsset(name: "awardDisable3")
    internal static let awardDisable4 = ImageAsset(name: "awardDisable4")
    internal static let awardEnable1 = ImageAsset(name: "awardEnable1")
    internal static let awardEnable2 = ImageAsset(name: "awardEnable2")
    internal static let awardEnable3 = ImageAsset(name: "awardEnable3")
    internal static let awardEnable4 = ImageAsset(name: "awardEnable4")
    internal static let coachmarkMorePopuup = ImageAsset(name: "coachmark_more_popuup")
    internal static let coachmarkTip1 = ImageAsset(name: "coachmark_tip_1")
    internal static let coachmarkTip2A = ImageAsset(name: "coachmark_tip_2_a")
    internal static let coachmarkTip2B = ImageAsset(name: "coachmark_tip_2_b")
    internal static let coachmarkTip2C = ImageAsset(name: "coachmark_tip_2_c")
    internal static let coachmarkTip3A = ImageAsset(name: "coachmark_tip_3_a")
    internal static let coachmarkTip3B = ImageAsset(name: "coachmark_tip_3_b")
    internal static let coachmarkTip3C = ImageAsset(name: "coachmark_tip_3_c")
    internal static let coachmarkTip3D = ImageAsset(name: "coachmark_tip_3_d")
    internal static let contactUs = ImageAsset(name: "contactUs")
    internal static let defautImage = ImageAsset(name: "defautImage")
    internal static let emojiAngry = ImageAsset(name: "emoji_angry")
    internal static let emojiAngryDis = ImageAsset(name: "emoji_angry_dis")
    internal static let emojiCool = ImageAsset(name: "emoji_cool")
    internal static let emojiDaughter = ImageAsset(name: "emoji_daughter")
    internal static let emojiDefault = ImageAsset(name: "emoji_default")
    internal static let emojiDefaultDis = ImageAsset(name: "emoji_default_dis")
    internal static let emojiEmpty = ImageAsset(name: "emoji_empty")
    internal static let emojiEtc = ImageAsset(name: "emoji_etc")
    internal static let emojiHappy = ImageAsset(name: "emoji_happy")
    internal static let emojiHappyDis = ImageAsset(name: "emoji_happy_dis")
    internal static let emojiSon = ImageAsset(name: "emoji_son")
    internal static let emojiWink = ImageAsset(name: "emoji_wink")
    internal static let gradeTipArrow = ImageAsset(name: "grade_tip_arrow")
    internal static let recommendHabit1 = ImageAsset(name: "recommend_habit_1")
    internal static let recommendHabit2 = ImageAsset(name: "recommend_habit_2")
    internal static let recommendHabit3 = ImageAsset(name: "recommend_habit_3")
    internal static let recommendHabit4 = ImageAsset(name: "recommend_habit_4")
    internal static let recommendHabit5 = ImageAsset(name: "recommend_habit_5")
    internal static let recommendHabit6 = ImageAsset(name: "recommend_habit_6")
    internal static let introLogo = ImageAsset(name: "intro_logo")
    internal static let idsettingConfirm = ImageAsset(name: "idsetting_Confirm")
    internal static let idsettingAnswer = ImageAsset(name: "idsetting_answer")
    internal static let idsettingConfirmDis = ImageAsset(name: "idsetting_confirm_dis")
    internal static let idsettingQuestion = ImageAsset(name: "idsetting_question")
    internal static let namesettingAnswer = ImageAsset(name: "namesetting_answer")
    internal static let namesettingAnswerEtc = ImageAsset(name: "namesetting_answer_etc")
    internal static let namesettingConfirmL = ImageAsset(name: "namesetting_confirm_l")
    internal static let namesettingConfirmM = ImageAsset(name: "namesetting_confirm_m")
    internal static let namesettingConfirmS = ImageAsset(name: "namesetting_confirm_s")
    internal static let namesettingDaughter = ImageAsset(name: "namesetting_daughter")
    internal static let namesettingDaughterDis = ImageAsset(name: "namesetting_daughter_dis")
    internal static let namesettingEtc = ImageAsset(name: "namesetting_etc")
    internal static let namesettingEtcDis = ImageAsset(name: "namesetting_etc_dis")
    internal static let namesettingQuestion = ImageAsset(name: "namesetting_question")
    internal static let namesettingSon = ImageAsset(name: "namesetting_son")
    internal static let namesettingSonDis = ImageAsset(name: "namesetting_son_dis")
    internal static let loading1 = ImageAsset(name: "loading1")
    internal static let loading11 = ImageAsset(name: "loading11")
    internal static let loading12 = ImageAsset(name: "loading12")
    internal static let loading13 = ImageAsset(name: "loading13")
    internal static let loading2 = ImageAsset(name: "loading2")
    internal static let loading3 = ImageAsset(name: "loading3")
    internal static let loginApple = ImageAsset(name: "login_apple")
    internal static let loginGoogle = ImageAsset(name: "login_google")
    internal static let loginGoogleHighlight = ImageAsset(name: "login_google_highlight")
    internal static let loginKakao = ImageAsset(name: "login_kakao")
    internal static let loginKakaoHighlight = ImageAsset(name: "login_kakao_highlight")
    internal static let logo = ImageAsset(name: "logo")
    internal static let mainEmptyImage = ImageAsset(name: "mainEmptyImage")
    internal static let myTipAngryMom = ImageAsset(name: "my_tip_angryMom")
    internal static let myTipArrow = ImageAsset(name: "my_tip_arrow")
    internal static let myTipCoolMom = ImageAsset(name: "my_tip_coolMom")
    internal static let myTipFondMom = ImageAsset(name: "my_tip_fondMom")
    internal static let onboardingEmoji1 = ImageAsset(name: "onboarding_emoji1")
    internal static let onboardingEmoji2 = ImageAsset(name: "onboarding_emoji2")
    internal static let onboardingEmoji3 = ImageAsset(name: "onboarding_emoji3")
    internal static let onboardingEmoji4 = ImageAsset(name: "onboarding_emoji4")
    internal static let onboardingEmoji5 = ImageAsset(name: "onboarding_emoji5")
    internal static let onboardingImage1 = ImageAsset(name: "onboarding_image_1")
    internal static let onboardingImage2 = ImageAsset(name: "onboarding_image_2")
    internal static let onboardingImage3 = ImageAsset(name: "onboarding_image_3")
    internal static let onboardingImage4 = ImageAsset(name: "onboarding_image_4")
    internal static let onboardingImage5 = ImageAsset(name: "onboarding_image_5")
    internal static let pagecontrol1 = ImageAsset(name: "pagecontrol1")
    internal static let pagecontrol2 = ImageAsset(name: "pagecontrol2")
    internal static let pagecontrol3 = ImageAsset(name: "pagecontrol3")
    internal static let pagecontrol4 = ImageAsset(name: "pagecontrol4")
    internal static let pagecontrol5 = ImageAsset(name: "pagecontrol5")
    internal static let todoBottomEmptyImage = ImageAsset(name: "todoBottomEmptyImage")
    internal static let gradeLevel1 = ImageAsset(name: "grade_level_1")
    internal static let gradeLevel2 = ImageAsset(name: "grade_level_2")
    internal static let gradeLevel3 = ImageAsset(name: "grade_level_3")
    internal static let gradeLevel4 = ImageAsset(name: "grade_level_4")
    internal static let gradeLevel5 = ImageAsset(name: "grade_level_5")
  }
  internal enum Color {
    internal static let black = ColorAsset(name: "black")
    internal static let error = ColorAsset(name: "error")
    internal static let monoDark010 = ColorAsset(name: "mono_dark_010")
    internal static let monoDark020 = ColorAsset(name: "mono_dark_020")
    internal static let monoDark030 = ColorAsset(name: "mono_dark_030")
    internal static let monoDark040 = ColorAsset(name: "mono_dark_040")
    internal static let monoLight010 = ColorAsset(name: "mono_light_010")
    internal static let monoLight020 = ColorAsset(name: "mono_light_020")
    internal static let monoLight030 = ColorAsset(name: "mono_light_030")
    internal static let monoWhite = ColorAsset(name: "mono_white")
    internal static let priDark010 = ColorAsset(name: "pri_dark_010")
    internal static let priDark020 = ColorAsset(name: "pri_dark_020")
    internal static let priLight010 = ColorAsset(name: "pri_light_010")
    internal static let priLight018Dis = ColorAsset(name: "pri_light_018_dis")
    internal static let priLight020 = ColorAsset(name: "pri_light_020")
    internal static let priLight030 = ColorAsset(name: "pri_light_030")
    internal static let priMain = ColorAsset(name: "pri_main")
    internal static let selected = ColorAsset(name: "selected")
    internal static let skyblue = ColorAsset(name: "skyblue")
    internal static let subDark010 = ColorAsset(name: "sub_dark_010")
    internal static let subDark020 = ColorAsset(name: "sub_dark_020")
    internal static let subLight010 = ColorAsset(name: "sub_light_010")
    internal static let subLight020 = ColorAsset(name: "sub_light_020")
    internal static let subLight030 = ColorAsset(name: "sub_light_030")
    internal static let subLight040 = ColorAsset(name: "sub_light_040")
    internal static let subMain = ColorAsset(name: "sub_main")
    internal static let success = ColorAsset(name: "success")
  }
  internal enum Icon {
    internal static let book = ImageAsset(name: "book")
    internal static let cancel = ImageAsset(name: "cancel")
    internal static let chevronDown = ImageAsset(name: "chevron_down")
    internal static let chevronLeft = ImageAsset(name: "chevron_left")
    internal static let chevronRight = ImageAsset(name: "chevron_right")
    internal static let chevronUp = ImageAsset(name: "chevron_up")
    internal static let clock = ImageAsset(name: "clock")
    internal static let clockDark040 = ImageAsset(name: "clock_dark040")
    internal static let curveRight = ImageAsset(name: "curveRight")
    internal static let delay = ImageAsset(name: "delay")
    internal static let delete = ImageAsset(name: "delete")
    internal static let deleteRed = ImageAsset(name: "delete_red")
    internal static let diary = ImageAsset(name: "diary")
    internal static let diaryWrite = ImageAsset(name: "diaryWrite")
    internal static let edit = ImageAsset(name: "edit")
    internal static let editMessage = ImageAsset(name: "edit_message")
    internal static let floatingPlus = ImageAsset(name: "floatingPlus")
    internal static let habitAddFloating = ImageAsset(name: "habitAddFloating")
    internal static let home = ImageAsset(name: "home")
    internal static let list = ImageAsset(name: "list")
    internal static let listSortIc = ImageAsset(name: "listSortIc")
    internal static let medal = ImageAsset(name: "medal")
    internal static let more = ImageAsset(name: "more")
    internal static let moreVertical = ImageAsset(name: "moreVertical")
    internal static let my = ImageAsset(name: "my")
    internal static let plus = ImageAsset(name: "plus")
    internal static let plusFill = ImageAsset(name: "plus_fill")
    internal static let postpone = ImageAsset(name: "postpone")
    internal static let radioDefault = ImageAsset(name: "radio_default")
    internal static let radioSelected = ImageAsset(name: "radio_selected")
    internal static let reportCard = ImageAsset(name: "reportCard")
    internal static let settings = ImageAsset(name: "settings")
    internal static let sliders = ImageAsset(name: "sliders")
    internal static let straightLeft = ImageAsset(name: "straight_left")
    internal static let tip = ImageAsset(name: "tip")
    internal static let tipGray = ImageAsset(name: "tip_gray")
    internal static let todoAddFloating = ImageAsset(name: "todoAddFloating")
    internal static let todoNonSelect = ImageAsset(name: "todoNonSelect")
    internal static let todoSelect = ImageAsset(name: "todoSelect")
    internal static let x = ImageAsset(name: "x")
    internal static let xFloating = ImageAsset(name: "xFloating")
    internal static let xCircle = ImageAsset(name: "x_circle")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
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
