//
//  Common.swift
//  momsnagging
//
//  Created by 전창평 on 2022/03/26.
//

import Foundation
import Photos
import UIKit

class Common {
    static func checkPhotoLibraryPermission(view:UIViewController){
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: { status in
                switch status {
                case .notDetermined:
                    print("아직 선택하지 않음 notDetermined 14")
                case .restricted:
                    print("아직 선택하지 않음 restricted 14")
                case .denied: //권한 거부 상태
                    DispatchQueue.main.async {
                        let doneAction = UIAlertAction(title: "네", style: .default, handler: { _ in
                            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        })
                        CommonView.systemAlert(view: view, type: .twoButton, title: "앨범 권한", message: "앨범 사용을 위해 권한이 필요합니다.\n설정으로 이동할까요?", doneAction: doneAction,cancelTitle: "아니요")
                    }
                case .authorized: //권한 허용 상태
                    DispatchQueue.main.async {
                        let imagePickerController = UIImagePickerController()
                        imagePickerController.sourceType = .photoLibrary
                        imagePickerController.delegate = view.self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                        view.present(imagePickerController, animated: true, completion: nil)
                    }
                case .limited: //선택한 사진에 대해서만 허용 상태
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
                case .denied://권한 거부 상태
                    DispatchQueue.main.async {
                        let doneAction = UIAlertAction(title: "네", style: .default, handler: { _ in
                            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        })
                        CommonView.systemAlert(view: view, type: .twoButton, title: "앨범 권한", message: "앨범 사용을 위해 권한이 필요합니다.\n설정으로 이동할까요?", doneAction: doneAction,cancelTitle: "아니요")
                    }
                case .authorized://권한 허용 상태
                    DispatchQueue.main.async {
                        let imagePickerController = UIImagePickerController()
                        imagePickerController.sourceType = .photoLibrary
                        imagePickerController.delegate = view.self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                        view.present(imagePickerController, animated: true, completion: nil)
                    }
                case .limited: //선택한 사진에 대해서만 허용 상태
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
}
