//
//  CalendarDayCell.swift
//  momsnagging
//
//  Created by 전창평 on 2022/03/26.
//

import UIKit
import Then
import SnapKit

class CalendarDayCell: UICollectionViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        setUI()
    }
    lazy var number = UILabel().then({
        $0.textColor = UIColor.white
        $0.font = .systemFont(ofSize: 15, weight: .regular)
    })
    lazy var emoji = UIButton().then({
        $0.setTitle("😊", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .regular)
    })
}
extension CalendarDayCell {
    private func setUI(){
        contentView.addSubview(number)
        contentView.addSubview(emoji)
        number.snp.makeConstraints({
            $0.center.equalTo(contentView.snp.center)
        })
        emoji.snp.makeConstraints({
            $0.top.equalTo(number.snp.bottom).offset(15)
            $0.centerX.equalTo(number.snp.centerX)
        })
    }
}
