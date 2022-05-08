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
    var highlightDuration: TimeInterval = 0.15
    
    // MARK: - UI Properties
    @IBInspectable var normalBackgroundColor: UIColor = Asset.Color.priMain.color {
        didSet {
            self.contentView.backgroundColor = normalBackgroundColor
        }
    }
    @IBInspectable var highlightedBackgroundColor: UIColor = Asset.Color.priDark020.color
    @IBInspectable var normalTitleColor: UIColor = Asset.Color.monoDark020.color {
        didSet {
            self.lblTitle.textColor = normalTitleColor
        }
    }
    @IBInspectable var highlightedTitleColor: UIColor = Asset.Color.monoWhite.color
    
    override var isHighlighted: Bool {
        didSet {
            if oldValue == false && isHighlighted {
                highlight()
            } else if oldValue == true && !isHighlighted {
                unHighlight()
            }
        }
    }
    
    lazy var lblTitle = UILabel().then({
        $0.font = FontFamily.Pretendard.bold.font(size: 16)
        $0.textColor = normalTitleColor
    })
    
    func highlight() {
        animateColor(backgroundColor: highlightedBackgroundColor, titleColor: highlightedTitleColor, duration: highlightDuration)
    }

    func unHighlight() {
        animateColor(backgroundColor: normalBackgroundColor, titleColor: normalTitleColor, duration: highlightDuration)
    }

    private func animateColor(backgroundColor: UIColor?, titleColor: UIColor?, duration: TimeInterval) {
        guard let backgroundColor = backgroundColor, let titleColor = titleColor else { return }
        UIView.animate(withDuration: duration) {
            self.contentView.backgroundColor = backgroundColor
            self.lblTitle.textColor = titleColor
        }
    }
    
    // MARK: - init
    override func layoutSubviews() {
        super.layoutSubviews()
        initUI()
    }
    
    func initUI() { }
}
