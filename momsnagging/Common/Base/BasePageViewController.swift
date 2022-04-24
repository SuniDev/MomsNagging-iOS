//
//  BasePageViewController.swift
//  momsnagging
//
//  Created by suni on 2022/04/24.
//

import UIKit

/**
 # (C) BasePageViewController
 - Authors: suni
 - Note: 모든 PageVC의 Base, 모든 UIPageViewController의 기본 기능 정의.
 */
class BasePageViewController: UIPageViewController {

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
