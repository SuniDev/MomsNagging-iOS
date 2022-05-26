//
//  RoutineCell.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/26.
//

import UIKit
import Then
import SnapKit

class RoutineCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUI()
        selectionStyle = .none
    }
    // MARK: Properties & Variable
    var todoIsSelected: Bool = false // 투두리스트 완료,선택 여부
    var count: Int = 0 // 반복횟수
//    var cellType: TodoCellType = .normal
    // MARK: UI Properties
    lazy var toggleIc = UIButton().then({
        if todoIsSelected {
            $0.setImage(UIImage(asset: Asset.Icon.todoSelect), for: .normal)
        } else {
            $0.setImage(UIImage(asset: Asset.Icon.todoNonSelect), for: .normal)
        }
    })
    lazy var timeBtn = UIButton().then({
        $0.setTitleColor(UIColor(asset: Asset.Color.monoDark010), for: .normal)
        $0.titleLabel?.font = FontFamily.Pretendard.regular.font(size: 12)
        $0.backgroundColor = UIColor(asset: Asset.Color.monoLight010)
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    })
    lazy var prefixView = UIView()
    lazy var prefixLbl = UILabel()
    lazy var titleLbl = UILabel().then({
        $0.numberOfLines = 2
        $0.textColor = UIColor(asset: Asset.Color.monoDark010)
        $0.font = FontFamily.Pretendard.semiBold.font(size: 14)
    })
    lazy var moreIc = UIButton().then({
        $0.setImage(UIImage(asset: Asset.Icon.moreVertical), for: .normal)
    })
    lazy var sortIc = UIButton().then({
        $0.isUserInteractionEnabled = false
        $0.setImage(UIImage(asset: Asset.Icon.listSortIc), for: .normal)
        $0.isHidden = true
    })
    lazy var bottomDivider = UIView().then({
        $0.backgroundColor = UIColor(asset: Asset.Color.monoLight010)
    })
}

extension RoutineCell {
    func setUI() {
        contentView.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        contentView.addSubview(toggleIc)
        contentView.addSubview(timeBtn)
        contentView.addSubview(titleLbl)
        contentView.addSubview(moreIc)
        contentView.addSubview(sortIc)
        contentView.addSubview(bottomDivider)
        
        toggleIc.snp.makeConstraints({
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.leading.equalTo(contentView.snp.leading).offset(20)
            $0.width.height.equalTo(24)
        })
        timeBtn.snp.makeConstraints({
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.width.equalTo(80)
            $0.height.equalTo(30)
            $0.leading.equalTo(toggleIc.snp.trailing).offset(12)
        })
        bottomDivider.snp.makeConstraints({
            $0.bottom.equalTo(contentView.snp.bottom)
            $0.leading.equalTo(contentView.snp.leading)
            $0.trailing.equalTo(contentView.snp.trailing)
            $0.height.equalTo(1)
        })
        titleLbl.snp.makeConstraints({
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.leading.equalTo(timeBtn.snp.trailing).offset(12)
            $0.trailing.equalTo(moreIc.snp.leading).offset(-16)
        })
        
        moreIc.snp.makeConstraints({
            $0.width.height.equalTo(24)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-12)
        })
        
        sortIc.snp.makeConstraints({
            $0.width.height.equalTo(24)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-12)
        })
    }
}
