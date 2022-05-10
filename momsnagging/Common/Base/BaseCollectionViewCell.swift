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
 - Note: UICollectionViewCell의 Base 클래스, Select Color 효과
 */
class BaseCollectionViewCell: UICollectionViewCell {
    
    var selectDuration: TimeInterval = 0.1
    var normalDuration: TimeInterval = 0.1
    
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
    
    /**
     # normal
     - Authors: suni
     - Note: 디폴트 (.normal) 상태 호출 함수
     */
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
    
    /**
     # select
     - Authors: suni
     - Note: isSelected = true 일때 호출되는 함수
     */
    func select() {
        animateColor(backgroundColor: selectedBackgroundColor, titleColor: selectedTitleColor, duration: selectDuration)
    }
    
    /**
     # deSelect
     - Authors: suni
     - Note: isSelected = false 일때 호출되는 함수
     */
    func deSelect() {
        animateColor(backgroundColor: normalBackgroundColor, titleColor: normalTitleColor, duration: selectDuration)
    }
    
    /**
     # animateColor
     - Parameters:
        - backgroundColor:배경 색상
        - titleColor:타이틀 색상
        - duration:애니메이션 시간
     - Authors: suni
     - Note: 배경, 타이틀 색상 변경 애니메이션 함수
     */
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
    
    /**
     # initView
     - Authors: suni
     - Note: 뷰를 초기화 하는 Override용 함수
     */
    func initView() { }
}
