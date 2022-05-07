//
//  HomeTodoListCell.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/07.
//

import UIKit
import Then
import SnapKit

class HomeTodoListCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUI()
        selectionStyle = .none
    }
    // MARK: Properties & Variable
    
    // MARK: UI Properties
    lazy var toggleIcon = UIButton().then({
        $0.setImage(UIImage(asset: <#T##ImageAsset#>), for: .normal)
    })
}

extension HomeTodoListCell {
    func setUI(){
        
    }
}
