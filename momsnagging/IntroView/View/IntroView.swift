//
//  ViewController.swift
//  momsnagging
//
//  Created by 전창평 on 2022/03/09.
//

import UIKit
import SnapKit
import Then
import RxSwift

class IntroView: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var introLabel : UILabel!
    @IBOutlet weak var backgroundFrame : UIView!
    @IBOutlet weak var button : UIButton!
    
    //MARK: - Properties
    var disposedBag = DisposeBag()
    var viewModel = IntroViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributed()
        layoutSetting()
    }
    //MARK: - attributed Set
    func setAttributed(){
        backgroundFrame.then({
            $0.backgroundColor = UIColor(named: "white")
        })
        introLabel.then({
            $0.font = .systemFont(ofSize: 20, weight: .bold)
            $0.textColor = UIColor(named: "black")
            $0.text = ""
        })
        button.then({
            $0.backgroundColor = UIColor(named: "white")
            $0.setTitle("눌러봐여!", for: .normal)
            $0.setTitleColor(UIColor(named: "black"), for: .normal)
            $0.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
            $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(named: "black")?.cgColor
        })
    }
    //MARK: - layout Set
    func layoutSetting(){
        backgroundFrame.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        introLabel.snp.makeConstraints({
            $0.center.equalTo(backgroundFrame.snp.center)
        })
        button.snp.makeConstraints({
            $0.top.equalTo(introLabel.snp.bottom).offset(50)
            $0.centerX.equalTo(backgroundFrame.snp.centerX)
            $0.height.equalTo(48)
            $0.width.equalTo(100)
        })
    }
}

//MARK: action
extension IntroView {
    @objc func btnAction(){
        viewModel.nameUpdate()
        viewModel.nameOb?.subscribe(onNext: { st in
            self.introLabel.text = st
        }).disposed(by: disposedBag)
    }
}
