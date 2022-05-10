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
    
    override var isSelected: Bool {
        didSet {
            if oldValue == false && isSelected {
                select()
                setSelected(true)
            } else if oldValue == true && !isSelected {
                deSelect()
                setSelected(false)
            }
        }
    }
        
    override func initView() {
        normalBackgroundColor = Asset.Color.monoWhite.color
        normalTitleColor = Asset.Color.monoDark010.color
        
        selectedBackgroundColor = Asset.Color.priLight030.color
        selectedTitleColor = Asset.Color.monoDark010.color
        
        lblTitle.font = FontFamily.Pretendard.regular.font(size: 12)
        
        contentView.layer.cornerRadius = contentView.bounds.height / 2
        self.setSelected(false)
        
        contentView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
    }
    
    func setSelected(_ isSelected: Bool) {
        self.contentView.addBorder(color: isSelected ? Asset.Color.priLight030.color : Asset.Color.monoLight020.color, width: 1)
    }
}
