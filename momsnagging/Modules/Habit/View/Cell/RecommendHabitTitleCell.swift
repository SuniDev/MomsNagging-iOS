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
    
    override func initUI() {
        contentView.layer.cornerRadius = 12
        contentView.addSubview(lblTitle)
        
        lblTitle.snp.makeConstraints({
            $0.top.equalToSuperview().offset(13)
            $0.leading.equalToSuperview().offset(16)
        })
    }
}
