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
    lazy private(set) var className: String = {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()
    
    deinit {
        Log.info("DEINIT: \(self.className)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUI()
        self.initLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true)
   }
    
    /**
     # initUI
     - Authors: suni
     - Note: UI 초기 설정하는 Override용 함수
     */
    func initUI() { }
    
    /**
     # initLayout
     - Authors: suni
     - Note: layout 관련 설정하는 Override용 함수
     */
    func initLayout() { }
    
    /**
     # reloadData
     - Authors: suni
     - Note: reload할 데이터를 설정하는 Override용 함수
     */
    func reloadData() { }
}
