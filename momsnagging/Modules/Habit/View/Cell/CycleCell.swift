//
//  CycleCell.swift
//  momsnagging
//
//  Created by suni on 2022/05/09.
//

import UIKit
import Then
import SnapKit

class CycleCell: BaseCollectionViewCell {
        
    override func initView() {
        normalBackgroundColor = Asset.Color.monoWhite.color
        normalTitleColor = Asset.Color.monoDark010.color
        
        selectedBackgroundColor = Asset.Color.priLight030.color
        selectedTitleColor = Asset.Color.monoDark010.color
        
        lblTitle.font = FontFamily.Pretendard.regular.font(size: 12)
        
        contentView.layer.cornerRadius = contentView.bounds.height / 2
        contentView.addBorder(color: Asset.Color.monoLight020.color, width: 1)
        
        
        contentView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
    }
    
    override func select() {
        self.contentView.layer.borderWidth = 0
    }
    
    override func deSelect() {
        self.contentView.addBorder(color: Asset.Color.monoLight020.color, width: 1)
    }
}
