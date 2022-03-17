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
    
    //MARK: - Properties & Variable
    var disposedBag = DisposeBag()
    var viewModel = IntroViewModel()
    //MARK: - UI Properties
    var backgroundFrame = UIView().then({
        $0.backgroundColor = Asset.white.color
    })
    var introLabel = UILabel().then({
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = Asset.black.color
        $0.text = ""
    })
    var button = UIButton().then({
        $0.backgroundColor = Asset.white.color
        $0.setTitle("눌러봐여!", for: .normal)
        $0.setTitleColor(Asset.black.color, for: .normal)
        $0.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Asset.black.color.cgColor
    })

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSetting()
    }
    //MARK: - attributed Set
    //MARK: - layout Set
    func layoutSetting(){
        view.addSubview(backgroundFrame)
        backgroundFrame.addSubview(introLabel)
        backgroundFrame.addSubview(button)
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
