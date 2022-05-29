//
//  DetailDiaryCalendarCell.swift
//  momsnagging
//
//  Created by suni on 2022/05/29.
//

import UIKit
import Then
import SnapKit

class DetailDiaryCalendarCell: UICollectionViewCell {
    
    var normalBackgroundColor: UIColor = Asset.Color.monoWhite.color {
        didSet {
            self.viewBackground.backgroundColor = normalBackgroundColor
        }
    }
    var normalBorderColor: UIColor = .clear {
        didSet {
            self.viewBackground.addBorder(color: .clear, width: 1)
        }
    }
    var normalTitleColor: UIColor = Asset.Color.monoDark010.color {
        didSet {
            self.number.textColor = normalTitleColor
        }
    }
    
    let selectedBorderColor: UIColor = Asset.Color.priMain.color
    
    let disabledTitleColor: UIColor = Asset.Color.monoDark040.color
    let disabledBorderColor: UIColor = Asset.Color.monoWhite.color
    
    let todayBackgroundColor: UIColor = Asset.Color.priMain.color
    let todayBorderColor: UIColor = Asset.Color.priMain.color
    let todayTitleColor: UIColor = Asset.Color.monoWhite.color
    
    let sundayTitleColor: UIColor = Asset.Color.error.color
    
    override var isSelected: Bool {
        didSet {
            if isEnabled {
                configure()
            }
        }
    }
    // MARK: - Variable
    var isToday = false// 오늘인지 아닌지 여부
    var isSunday = false
    var isWroteDiary = false// 일기 씀 여부
    var isEnabled = false
        
    // MARK: - UI Properties
    lazy var viewBackground = UIView().then({
        $0.layer.cornerRadius = 14
        $0.backgroundColor = normalBackgroundColor
        $0.addBorder(color: normalBorderColor, width: 1)
    })
    lazy var number = UILabel().then({
        $0.textColor = normalTitleColor
        $0.font = FontFamily.Pretendard.regular.font(size: 14)
    })
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func configure() {
        if isEnabled {
            self.isUserInteractionEnabled = true
            if isToday {
                self.viewBackground.backgroundColor = todayBackgroundColor
                self.viewBackground.addBorder(color: todayBorderColor, width: 1)
                self.number.textColor = todayTitleColor
            } else {
                self.viewBackground.backgroundColor = normalBackgroundColor
                self.viewBackground.addBorder(color: isSelected ? selectedBorderColor : normalBorderColor, width: 1)
                self.number.textColor = isSunday ? sundayTitleColor : normalTitleColor
            }
        } else {
            self.isUserInteractionEnabled = false
            self.viewBackground.backgroundColor = normalBackgroundColor
            self.viewBackground.addBorder(color: disabledBorderColor, width: 0)
            self.number.textColor = disabledTitleColor
            
            if isSunday {
                self.number.alpha = 0.4
            }
        }
    }
    
}
extension DetailDiaryCalendarCell {
    private func initUI() {
        contentView.addSubview(viewBackground)
        contentView.addSubview(number)
        
        viewBackground.snp.makeConstraints({
            $0.center.equalTo(contentView.snp.center)
            $0.width.height.equalTo(28)
        })
        number.snp.makeConstraints({
            $0.center.equalTo(contentView.snp.center)
        })
    }
}
