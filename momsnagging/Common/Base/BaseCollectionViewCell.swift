//
//  BaseCollectionViewCell.swift
//  momsnagging
//
//  Created by suni on 2022/05/08.
//

import UIKit

/**
 # (C) BaseCollectionViewCell
 - Authors: suni
 - Note: UICollectionViewCell의 Base 클래스, highlight Color 효과
 */
class BaseCollectionViewCell: UICollectionViewCell {
    // MARK: - Variable
    var selectDuration: TimeInterval = 0.1
    var normalDuration: TimeInterval = 0.1
    
    // MARK: - UI Properties
    lazy var lblTitle = UILabel()
    
    @IBInspectable var normalBackgroundColor: UIColor = Asset.Color.priMain.color {
        didSet {
            self.contentView.backgroundColor = normalBackgroundColor
        }
    }
    @IBInspectable var normalTitleColor: UIColor = Asset.Color.monoDark020.color {
        didSet {
            self.lblTitle.textColor = normalTitleColor
        }
    }
    
    func normal() {
        animateColor(backgroundColor: normalBackgroundColor, titleColor: normalTitleColor, duration: normalDuration)
    }
    
    @IBInspectable var selectedBackgroundColor: UIColor = Asset.Color.priDark020.color
    @IBInspectable var selectedTitleColor: UIColor = Asset.Color.monoWhite.color
    
    override var isSelected: Bool {
        didSet {
            if oldValue == false && isSelected {
                select()
            } else if oldValue == true && !isSelected {
                deSelect()
            }
        }
    }
    
    func select() {
        animateColor(backgroundColor: selectedBackgroundColor, titleColor: selectedTitleColor, duration: selectDuration)
    }
    
    func deSelect() {
        animateColor(backgroundColor: normalBackgroundColor, titleColor: normalTitleColor, duration: selectDuration)

    }

    private func animateColor(backgroundColor: UIColor?, titleColor: UIColor?, duration: TimeInterval) {
        guard let backgroundColor = backgroundColor, let titleColor = titleColor else { return }
        UIView.animate(withDuration: duration) {
            self.contentView.backgroundColor = backgroundColor
            self.lblTitle.textColor = titleColor
        }
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    func initView() {
    }
}
