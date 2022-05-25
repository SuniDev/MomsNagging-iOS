//
//  PrivacyPolicyViewModel.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/22.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import SwiftyJSON

class PrivacyPolicyViewModel: BaseViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    override init() {
    }
    // MARK: - Input
    struct Input {
    }
    // MARK: - Output
    struct Output {
        var privacyPolicyListData: Driver<[PrivacyPolicyModel]>?
    }
    
    func transform(input: Input) -> Output {
        return Output(privacyPolicyListData: privacyPolicyList())
    }
    func privacyPolicyList() -> Driver<[PrivacyPolicyModel]> {
        let returnList = BehaviorRelay<[PrivacyPolicyModel]>(value: [])
        var list: [PrivacyPolicyModel] = []
        let titleList = ["1. 개인정보 처리방침", "2. 개인정보 수집 목적", "3. 수집하는 개인정보의 항목", "4. 개인정보의 처리 및 보유 기간", "5. 개인정보 파기"]
        for i in 0..<4 {
           var model = PrivacyPolicyModel()
            model.title = titleList[i]
            model.contents = "회사는 엄마의잔소리 서비스 제공을 위해 회원가입 시 또는 서비스 이용과정에서다음의 개인정보 항목을 수집 및 처리하고 있습니다. 1) 필수 항목: 이름, 로그인 ID, 비밀번호, 휴대전화번호, 이메일, 서비스 이용 기록, 접속 로그, 쿠키, 접속 IP 정보, 결제기록, 불량이용기록 2) 선택 항목: 생년월일, 성별, 자택주소, 자택전화번호, 은행계좌정보, 신용카드정보, 직업, 회사명, 부서, 직책, 회사전화번호, 결혼여부, 기념일, 취미, 신체정보, 학력, 종교, 주민등록번호 모바일 서비스 특성상 단말기에 관한 정보(단말기 모델, 이동통신사정보, 하드웨어ID, 서비스 이용에 대한 기본 통계)가 수집될 수 있습니다. 그러나 이는 개인을 식별할 수 없는 형태이며 회사는 수집된 단말기 정보로 특정 개인을 식별하지 않습니다. 단말기에 관한 정보 이외에 추가적으로 챌린저스 어플리케이션 정보 등이 수집될 수 있습니다. 3) 소득세법 제 127조에 따라 회사는 기타소득에 대한 원천징수의무가 있으며, 상금 지급을 위한 본인확인과 원천세 징수를 목적으로 회원의 이름, 주민등록번호, 입금 계좌정보(예금주, 은행명,"
            list.append(model)
        }
        returnList.accept(list)
        return returnList.asDriver()
    }
}
// MARK: - API
extension PrivacyPolicyViewModel {
    
}
