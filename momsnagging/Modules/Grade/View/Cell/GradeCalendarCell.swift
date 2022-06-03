//
//  GradeCalendarCell.swift
//  momsnagging
//
//  Created by suni on 2022/06/02.
//

import UIKit
import Then
import SnapKit

class GradeCalendarCell: UICollectionViewCell {
    
    var normalBackgroundColor: UIColor = Asset.Color.monoWhite.color {
        didSet {
            self.viewBackground.backgroundColor = normalBackgroundColor
        }
    }
    var normalBorderColor: UIColor = .clear {
        didSet {
            self.viewBackground.addBorder(color: .clear, width: 1.5)
        }
    }
    var normalTitleColor: UIColor = Asset.Color.monoDark010.color {
        didSet {
            self.number.textColor = normalTitleColor
        }
    }
    
    let selectedBorderColor: UIColor = Asset.Color.monoDark040.color
    
    let disabledTitleColor: UIColor = Asset.Color.monoDark040.color
    let disabledBorderColor: UIColor = .clear
    
    let todayBackgroundColor: UIColor = Asset.Color.monoLight030.color
    let todayBorderColor: UIColor = Asset.Color.monoLight030.color
    let todayTitleColor: UIColor = Asset.Color.monoDark010.color
    
    let sundayTitleColor: UIColor = Asset.Color.error.color
    
    override var isSelected: Bool {
        didSet {
            if isEnabled {
                configure()
            }
        }
    }
    // MARK: - Variable
    var avg: Int? // 달성도
    var isToday = false // 오늘인지 아닌지 여부
    var isSunday = false
    var isEnabled = false
    var isFuture = false // 미래 날짜
        
    // MARK: - UI Properties
    lazy var viewBackground = UIView().then({
        $0.layer.cornerRadius = 8
        $0.backgroundColor = normalBackgroundColor
        $0.addBorder(color: normalBorderColor, width: 1.5)
    })
    lazy var number = UILabel().then({
        $0.textAlignment = .center
        $0.textColor = normalTitleColor
        $0.font = FontFamily.Pretendard.regular.font(size: 10)
    })
    lazy var emoji = UIImageView().then({
        $0.image = Asset.Assets.emojiDefault.image
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
        if let avg = avg {
            self.emoji.image = self.getEmoji(avg: avg, isEnabled: isEnabled)
        }
        
        if isEnabled {
            if self.isFuture || self.avg == nil {
                self.emoji.isHidden = true
                self.isUserInteractionEnabled = false
            } else {
                self.emoji.isHidden = false
                self.isUserInteractionEnabled = true
            }
            
            if isToday {
                self.viewBackground.backgroundColor = todayBackgroundColor
                self.viewBackground.addBorder(color: todayBorderColor, width: 1.5)
                self.number.textColor = todayTitleColor
            } else {
                self.viewBackground.backgroundColor = normalBackgroundColor
                self.viewBackground.addBorder(color: isSelected ? selectedBorderColor : normalBorderColor, width: 1.5)
                self.number.textColor = isSunday ? sundayTitleColor : normalTitleColor
            }
        } else {
            // TODO: 이전달, 다음달 미리보기 사용할지 논의 필요.
            self.emoji.isHidden = true
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
extension GradeCalendarCell {
    private func getEmoji(avg: Int, isEnabled: Bool) -> UIImage {
        if avg == 0 {
            return isEnabled ? Asset.Assets.emojiAngry.image : Asset.Assets.emojiAngryDis.image
        } else if avg > 0 && avg < 100 {
            return isEnabled ? Asset.Assets.emojiDefault.image : Asset.Assets.emojiDefaultDis.image
        } else if avg == 100 {
            return isEnabled ? Asset.Assets.emojiHappy.image : Asset.Assets.emojiHappyDis.image
        }
        return isEnabled ? Asset.Assets.emojiHappy.image : Asset.Assets.emojiHappyDis.image
    }
    
    private func initUI() {
        contentView.addSubview(viewBackground)
        contentView.addSubview(number)
        contentView.addSubview(emoji)
        
        viewBackground.snp.makeConstraints({
            $0.height.equalTo(58)
            $0.top.equalToSuperview().offset(1)
            $0.bottom.equalToSuperview().offset(-1)
            $0.leading.equalToSuperview().offset(4)
            $0.trailing.equalToSuperview().offset(-4)
        })
        number.snp.makeConstraints({
            $0.top.equalTo(viewBackground).offset(-1)
            $0.leading.trailing.equalTo(viewBackground)
            $0.height.equalTo(12)
        })
        emoji.snp.makeConstraints({
            $0.width.height.equalTo(36)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(number.snp.bottom).offset(4)
        })
    }
}
