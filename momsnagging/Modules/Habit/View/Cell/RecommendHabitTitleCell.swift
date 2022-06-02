//
//  RecommendHabitTitleCell.swift
//  momsnagging
//
//  Created by suni on 2022/05/08.
//

import UIKit
import Then
import SnapKit

class RecommendHabitTitleCell: BaseCollectionViewCell {
    
    lazy var image = UIImageView()
    
    override func initView() {
        normalTitleColor = Asset.Color.monoDark020.color
        selectedTitleColor = Asset.Color.monoWhite.color
        
        lblTitle.font = FontFamily.Pretendard.bold.font(size: 16)
        
        contentView.layer.cornerRadius = 12
        contentView.addSubview(lblTitle)
        contentView.addSubview(image)
        
        lblTitle.snp.makeConstraints({
            $0.top.equalToSuperview().offset(13)
            $0.leading.equalToSuperview().offset(16)
        })
        
        image.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-6)
            $0.trailing.equalToSuperview().offset(-10.5)
        })
    }
}
