//
//  DiaryCalendarCell.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/06.
//

import UIKit
import Then
import SnapKit

class DiaryCalendarCell: UICollectionViewCell {
    
    // MARK: - Diary 디테일 작업 수정
    var normalBackgroundColor: UIColor = Asset.Color.monoWhite.color {
        didSet {
            self.viewBackground.backgroundColor = normalBackgroundColor
        }
    }
    var normalBorderColor: UIColor = Asset.Color.monoLight030.color {
        didSet {
            self.viewBackground.addBorder(color: normalBorderColor, width: 1)
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
    
    let wroteBackgroundColor: UIColor = Asset.Color.subLight030.color
    let wroteBorderColor: UIColor = Asset.Color.subLight030.color
    
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
        $0.layer.cornerRadius = 20
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
            if isToday {
                self.viewBackground.backgroundColor = todayBackgroundColor
                self.viewBackground.addBorder(color: todayBorderColor, width: 1)
                self.number.textColor = todayTitleColor
            } else {
                if isWroteDiary {
                    self.viewBackground.backgroundColor = wroteBackgroundColor
                    self.viewBackground.addBorder(color: isSelected ? selectedBorderColor : wroteBorderColor, width: 1)
                    self.number.textColor = isSunday ? sundayTitleColor : normalTitleColor
                } else {
                    self.viewBackground.backgroundColor = normalBackgroundColor
                    self.viewBackground.addBorder(color: isSelected ? selectedBorderColor : normalBorderColor, width: 1)
                    self.number.textColor = isSunday ? sundayTitleColor : normalTitleColor
                }
            }
        } else {
            self.viewBackground.backgroundColor = normalBackgroundColor
            self.viewBackground.addBorder(color: disabledBorderColor, width: 0)
            self.number.textColor = disabledTitleColor
            
            if isSunday {
                self.number.alpha = 0.4
            }
        }
    }
    
}
extension DiaryCalendarCell {
    private func initUI() {
        contentView.addSubview(viewBackground)
        contentView.addSubview(number)
        
        viewBackground.snp.makeConstraints({
            $0.center.equalTo(contentView.snp.center)
            $0.width.height.equalTo(40)
        })
        number.snp.makeConstraints({
            $0.center.equalTo(contentView.snp.center)
        })
    }
}
