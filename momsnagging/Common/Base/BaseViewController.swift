//
//  BaseViewController.swift
//  momsnagging
//
//  Created by suni on 2022/03/27.
//

import UIKit

/**
 # (C) BaseViewController
 - Authors: suni
 - Note: 모든 VC의 Base, 모든 ViewController의 기본 기능 정의.
 */
class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUI()
        self.layoutSetting()
        self.bind()
    }
    
    /**
     # initUI
     - Authors: suni
     - Note: UI 초기 설정하는 Override용 함수
     */
    func initUI() { }
    
    /**
     # layoutSetting
     - Authors: suni
     - Note: layout 관련 설정하는 Override용 함수
     */
    func layoutSetting() { }
    
    /**
     # bind
     - Authors: suni
     - Note: binding 관련 설정하는 Override용 함수
     */
    func bind() { }
    
}
