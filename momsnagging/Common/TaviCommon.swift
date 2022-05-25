//
//  TaviCommon.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/22.
//

import Foundation

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
}
