//
//  PerformTimeGuideCell.swift
//  momsnagging
//
//  Created by suni on 2022/05/11.
//

import UIKit

class PerformTimeGuideCell: BaseCollectionViewCell {
    
    override func initView() {
        normalBackgroundColor = Asset.Color.subLight010.color
        normalTitleColor = Asset.Color.monoDark010.color
        
        selectedBackgroundColor = Asset.Color.subLight030.color
        selectedTitleColor = Asset.Color.monoDark010.color
        
        lblTitle.font = FontFamily.Pretendard.regular.font(size: 14)
        
        contentView.layer.cornerRadius = contentView.bounds.height / 2
        
        contentView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
    }

}
