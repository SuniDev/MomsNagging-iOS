//
//  Common.swift
//  momsnagging
//
//  Created by 전창평 on 2022/03/26.
//

import Foundation
import Photos
import UIKit
import StoreKit
import SwiftKeychainWrapper

class Common {
    private static let configKey = "DeployPhase"
    
    enum DeployType: String {
        case debug
        case release
    }
    
    static func getDeployPhase() -> DeployType {
        guard let configValue = Bundle.main.object(forInfoDictionaryKey: configKey) as? String,
                let phase = DeployType(rawValue: configValue) else {
            return DeployType.release
        }
        
        return phase
    }
    
    /**
     # getBaseUrl
     - Note: baseURL 을 반환 하는 함수
    */
    static func getBaseUrl() -> String {
        switch Common.getDeployPhase() {
        case .debug:
            return "https://api.momsnagging.ml/api/v1/"
        case .release:
            return "https://api.momsnagging.ml/api/v1/"
        }
    }
    
    static func checkPhotoLibraryPermission(view: UIViewController) {
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: { status in
                switch status {
                case .notDetermined:
                    print("아직 선택하지 않음 notDetermined 14")
                case .restricted:
                    print("아직 선택하지 않음 restricted 14")
                case .denied: // 권한 거부 상태
                    // 220422 suni. Alert 함수 변경에 맞게 수정.
                    CommonView.showAlert(vc: view, type: .twoBtn, title: "앨범 권한", message: "앨범 사용을 위해 권한이 필요합니다.\n설정으로 이동할까요?", cancelTitle: "아니요", doneTitle: "네") {
                        
                    } doneHandler: {
                        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
//                    DispatchQueue.main.async {
//                        let doneAction = UIAlertAction(title: "네", style: .default, handler: { _ in
//                            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
//                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                        })
//                        CommonView.systemAlert(view: view, type: .twoButton, title: "앨범 권한", message: "앨범 사용을 위해 권한이 필요합니다.\n설정으로 이동할까요?", doneAction: doneAction, cancelTitle: "아니요")
//                    }
                case .authorized: // 권한 허용 상태
                    DispatchQueue.main.async {
                        let imagePickerController = UIImagePickerController()
                        imagePickerController.sourceType = .photoLibrary
                        imagePickerController.delegate = view.self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                        view.present(imagePickerController, animated: true, completion: nil)
                    }
                case .limited: // 선택한 사진에 대해서만 허용 상태
                    DispatchQueue.main.async {
                        let imagePickerController = UIImagePickerController()
                        imagePickerController.sourceType = .photoLibrary
                        imagePickerController.delegate = view.self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                        view.present(imagePickerController, animated: true, completion: nil)
                    }
                default :
                    break
                }
            })
        } else {
            PHPhotoLibrary.requestAuthorization({ status in
                switch status {
                case .notDetermined:
                    print("아직 선택하지 않음 notDetermined")
                case .restricted:
                    print("아직 선택하지 않음 restricted")
                case .denied:// 권한 거부 상태
                    // 220422 suni. Alert 함수 변경에 맞게 수정.
                    CommonView.showAlert(vc: view, type: .twoBtn, title: "앨범 권한", message: "앨범 사용을 위해 권한이 필요합니다.\n설정으로 이동할까요?", cancelTitle: "아니요", doneTitle: "네") {
                        
                    } doneHandler: {
                        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
//                    DispatchQueue.main.async {
//                        let doneAction = UIAlertAction(title: "네", style: .default, handler: { _ in
//                            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
//                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                        })
//                        CommonView.systemAlert(view: view, type: .twoButton, title: "앨범 권한", message: "앨범 사용을 위해 권한이 필요합니다.\n설정으로 이동할까요?", doneAction: doneAction, cancelTitle: "아니요")
//                    }
                case .authorized: // 권한 허용 상태
                    DispatchQueue.main.async {
                        let imagePickerController = UIImagePickerController()
                        imagePickerController.sourceType = .photoLibrary
                        imagePickerController.delegate = view.self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                        view.present(imagePickerController, animated: true, completion: nil)
                    }
                case .limited: // 선택한 사진에 대해서만 허용 상태
                    DispatchQueue.main.async {
                        let imagePickerController = UIImagePickerController()
                        imagePickerController.sourceType = .photoLibrary
                        imagePickerController.delegate = view.self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                        view.present(imagePickerController, animated: true, completion: nil)
                    }
                default :
                    break
                }
            })
        }
    }
    
    // MARK: - Badge
    /**
     # setBadgeNumber
     - Authors: suni
     - parameters:
        - count : 설정할 Badge 개수
     - Note: badge number를 설정하는 공용 함수.
     */
    static func setBadgeNumber(count: Int) {
        UIApplication.shared.applicationIconBadgeNumber = count
    }
    
    /**
     # getBadgeNumber
     - Authors: suni
     - returns : Badge 개수
     - Note: badge number를 가져오는 공용 함수.
     */
    static func getBadgeNumber() -> Int {
        return UIApplication.shared.applicationIconBadgeNumber
    }
    
    /**
     # removeBadgeNumber
     - Authors: suni
     - Note: badge number를 지우는 함수.
     */
    static func removeBadgeNumber() {
        setBadgeNumber(count: 0)
    }
    
    // MARK: - Store Review
    /**
     # requestStoreReview
     - Authors: suni
     - Note: App Store 리뷰를 요청하는 공용 함수.
     */
    static func requestStoreReview() {
        SKStoreReviewController.requestReview()
    }
    
    // MARK: - User Defaults
    /**
     # (E) UserDefaultsKey
     - Authors: suni
     */
    enum UserDefaultsKey: String {
        case isFirstEntryApp
        case isAutoLogin
        case dateLastCheckEvaluation
    }
    
    /**
     # getUserDefaultsObject
     - parameters:
        - defaultsKey : 반환할 value의 UserDefaults Key - (E) Common.UserDefaultsKey
     - Authors: suni
     - Note: UserDefaults 값을 반환하는 공용 함수
     */
    static func getUserDefaultsObject(forKey defaultsKey: UserDefaultsKey) -> Any? {
        let defaults = UserDefaults.standard
        if let object = defaults.object(forKey: defaultsKey.rawValue) {
            return object
        } else {
            return nil
        }
    }
    
    /**
     # setUserDefaults
     - parameters:
        - value : 저장할 값
        - defaultsKey : 저장할 value의 UserDefaults Key - (E) Common.UserDefaultsKey
     - Authors: suni
     - Note: UserDefaults 값을 저장하는 공용 함수
     */
    static func setUserDefaults(_ value: Any?, forKey defaultsKey: UserDefaultsKey) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: defaultsKey.rawValue)
    }
    
    // MARK: - Keychain
    
    /**
     # (E) KeychainKey
     - Authors: suni
     */
    enum KeychainKey: String {
        case authorization
    }
    
    /**
     # setKeychain
     - parameters:
        - value : 저장할 값
        - keychainKey : 저장할 value의  Key - (E) Common.KeychainKey
     - Authors: suni
     - Note: 키체인에 값을 저장하는 공용 함수
     */
    static func setKeychain(_ value: String, forKey keychainKey: KeychainKey) {
        KeychainWrapper.standard.set(value, forKey: keychainKey.rawValue)
    }
    
    /**
     # removeKeychain
     - parameters:
        - keychainKey : 삭제할 value의  Key - (E) Common.KeychainKey
     - Authors: suni
     - Note: 키체인 값을 삭제하는 공용 함수
     */
    static func removeKeychain(forKey keychainKey: KeychainKey) {
        KeychainWrapper.standard.removeObject(forKey: keychainKey.rawValue)
    }
    
    /**
     # getKeychainValue
     - parameters:
        - keychainKey : 반환할 value의 Key - (E) Common.KeychainKey
     - Authors: suni
     - Note: 키체인 값을 반환하는 공용 함수
     */
    static func getKeychainValue(forKey keychainKey: KeychainKey) -> String? {
        return KeychainWrapper.standard.string(forKey: keychainKey.rawValue)
    }
    
    /**
     # getSafeareaHeight
     - Authors: suni
     - Note:디바이스 Safe Area 영역 높이를 반환하는 공용 함수
    */
    static func getSafeareaHeight() -> CGFloat {
        let height = UIScreen.main.bounds.height
        let window = UIApplication.shared.windows.first
        guard let topPadding = window?.safeAreaInsets.top else { return 0 }
        guard let bottomPadding = window?.safeAreaInsets.bottom else { return 0 }
        
        return height - topPadding - bottomPadding
    }
    
    /**
     # getTopPadding
     - Authors: suni
     - Parameters:
     - Returns: CGFloat
     - Note: 현재 디바이스의 탑 영역 값을 리턴하는 함수
     */
    static func getTopPadding() -> CGFloat {
        let window = UIApplication.shared.windows.first
        guard let topPadding = window?.safeAreaInsets.top else { return 0 }
        return topPadding
   }
    
    /**
     # getBottomPadding
     - Authors: suni
     - Parameters:
     - Returns: CGFloat
     - Note: 현재 디바이스의 바텀 영역 값을 리턴하는 함수
     */
    static func getBottomPadding() -> CGFloat {
        let window = UIApplication.shared.windows.first
        guard let bottomPadding = window?.safeAreaInsets.bottom else { return 0 }
        return bottomPadding
   }
    
    static func getNaggingEmoji(naggingLevel: NaggingLevel) -> UIImage {
        switch naggingLevel {
        case .fondMom:
            return Asset.Assets.emojiDefault.image
        case .coolMom:
            return Asset.Assets.emojiCool.image
        case .angryMom:
            return Asset.Assets.emojiAngry.image
        }
    }
    
    static func getNaggingTip(naggingLevel: NaggingLevel) -> UIImage {
        switch naggingLevel {
        case .fondMom:
            return Asset.Assets.myTipFondMom.image
        case .coolMom:
            return Asset.Assets.myTipCoolMom.image
        case .angryMom:
            return Asset.Assets.myTipAngryMom.image
        }
    }
}
