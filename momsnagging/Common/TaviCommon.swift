//
//  TaviCommon.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/22.
//

import Foundation
import UIKit
import Then
import SnapKit

/*
 동시작업시 Common의 충돌 방지를 위해서 여기서 작성 후 병합 후 하나씩 Common으로 옮기겠습니당 :) 참고부탁드릴께요
 */
class TaviCommon {
    // 현재 앱의 버전을 가져오는 함수
    static func getVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
                let version = dictionary["CFBundleShortVersionString"] as? String,
                let _ = dictionary["CFBundleVersion"] as? String else { return "nil" }
        let versionAndBuild: String = "\(version)"
        return versionAndBuild
    }
    
    static func alarmTimeDateToStringFormatHHMM(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    static func alarmTimeStringToDateToString(stringData: String) -> String {
        var date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        date = dateFormatter.date(from: stringData) ?? date
        print("date!!!! : \(date)")
        let toStringFormatter = DateFormatter()
        toStringFormatter.locale = Locale(identifier: "ko_KR")
        toStringFormatter.dateFormat = "hh:mm a"
        return toStringFormatter.string(from: date)
    }
    
}

extension UIViewController {
    func showToast(message : String) {
        let frameView = UIView().then({
            $0.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            $0.alpha = 0.8
            $0.layer.cornerRadius = 6
        })
        let imageView = UIImageView().then({
            $0.image = UIImage(asset: Asset.Assets.emojiDefault)
        })
        let toastLabel = UILabel()
        toastLabel.textColor = UIColor(named:"white")
        toastLabel.font = FontFamily.Pretendard.bold.font(size: 16)
        toastLabel.text = message
        
        view.addSubview(frameView)
        frameView.addSubview(toastLabel)
        frameView.addSubview(imageView)
        frameView.snp.makeConstraints({
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            $0.centerX.equalTo(view.snp.centerX)
            $0.leading.equalTo(view.snp.leading).offset(12)
            $0.trailing.equalTo(view.snp.trailing).offset(-12)
            $0.height.equalTo(52)
        })
        imageView.snp.makeConstraints({
            $0.width.equalTo(28)
            $0.height.equalTo(26)
            $0.leading.equalTo(frameView.snp.leading).offset(12)
            $0.centerY.equalTo(frameView.snp.centerY)
        })
        toastLabel.snp.makeConstraints({
            $0.centerY.equalTo(frameView.snp.centerY)
            $0.leading.equalTo(imageView.snp.trailing).offset(16)
        })
        UIView.animate(withDuration: 1.5, delay: 1.5, options: .curveEaseOut, animations: { frameView.alpha = 0.0 }, completion: { isCompleted in
            frameView.removeFromSuperview()
        })}
}
