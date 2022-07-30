//
//  StatisticsPerformRateCell.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/21.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class StatisticsPerformRateCell: UITableViewCell {
    
    var disposedBag = DisposeBag()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectionStyle = .none
        setUI()
    }
    
    lazy var titleLbl = UILabel().then({
        $0.textColor = UIColor(asset: Asset.Color.monoDark020)
        $0.font = FontFamily.Pretendard.semiBold.font(size: 14)
    })
    lazy var dataLbl = UILabel().then({
        $0.textColor = UIColor(asset: Asset.Color.priMain)
        $0.font = FontFamily.Pretendard.bold.font(size: 16)
    })
    lazy var suffixLbl = UILabel().then({
        $0.textAlignment = .right
        $0.textColor = UIColor(asset: Asset.Color.monoDark010)
        $0.font = FontFamily.Pretendard.bold.font(size: 16)
    })
    lazy var btnTip = UIButton().then({
        $0.setImage(Asset.Icon.tipGray.image, for: .normal)
    })
    lazy var imgvTip = UIImageView().then({
        $0.isHidden = true
    })
}

extension StatisticsPerformRateCell {
    private func setUI() {
        contentView.addSubview(titleLbl)
        contentView.addSubview(dataLbl)
        contentView.addSubview(suffixLbl)
        contentView.addSubview(btnTip)
        contentView.addSubview(imgvTip)
        
        titleLbl.snp.makeConstraints({
            $0.leading.centerY.equalToSuperview()
            $0.height.equalTo(25)
            $0.leading.top.equalToSuperview()
        })
        btnTip.snp.makeConstraints({
            $0.leading.equalTo(titleLbl.snp.trailing).offset(4)
            $0.centerY.equalTo(titleLbl)
        })
        imgvTip.snp.makeConstraints({
            $0.top.equalTo(btnTip.snp.bottom).offset(4)
            $0.leading.equalTo(btnTip).offset(-9)
        })
        dataLbl.snp.makeConstraints({
            $0.centerY.equalTo(titleLbl)
            $0.trailing.equalTo(suffixLbl.snp.leading).offset(-10)
        })
        suffixLbl.snp.makeConstraints({
            $0.width.equalTo(16)
            $0.centerY.equalTo(titleLbl)
            $0.trailing.equalToSuperview()
        })
        
        self.bind()
    }
    
    private func bind() {
        
//        self.btnTip.rx.tap
//            .asObservable()
//            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
//            .bind(onNext : { _, _ in
//                Log.debug("throttlethrottlethrottle")
////                if self.imgvTip.isHidden {
////                    self.imgvTip.fadeIn()
////                } else {
////                    self.imgvTip.fadeOut()
////                }
//            }).disposed(by: disposedBag)
//
//        if let vc = UIApplication.shared.keyWindow?.visibleViewController as? UIViewController {
//            vc.view.rx.tapGesture()
//                .mapToVoid()
//                .subscribe(onNext: { [weak self] in
//                    guard let self = self else { return }
//
//                    if !self.imgvTip.isHidden {
//                        self.imgvTip.fadeOut()
//                    }
//                }).disposed(by: self.disposedBag)
//        }
        
    }
}
