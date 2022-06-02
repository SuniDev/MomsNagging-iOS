//
//  GradeTodoCell.swift
//  momsnagging
//
//  Created by suni on 2022/06/02.
//

import UIKit
import Then
import SnapKit

class GradeTodoCell: UITableViewCell {
        
    // MARK: UI Properties
    lazy var icToggle = UIButton().then({
        $0.setImage(Asset.Icon.todoNonSelect.image, for: .normal)
    })
    lazy var btnTime = UIButton().then({
        $0.isUserInteractionEnabled = false
        $0.setTitleColor(Asset.Color.monoDark010.color, for: .normal)
        $0.titleLabel?.font = FontFamily.Pretendard.regular.font(size: 12)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = Asset.Color.monoLight010.color
    })
    lazy var viewPrefix = UIView().then({
        $0.layer.cornerRadius = 5
    })
    lazy var lblPrefix = UILabel().then({
        $0.textColor = Asset.Color.monoDark020.color
        $0.font = FontFamily.Pretendard.regular.font(size: 12)
    })
    lazy var lblTitle = UILabel().then({
        $0.numberOfLines = 2
        $0.textColor = Asset.Color.monoDark010.color
        $0.font = FontFamily.Pretendard.semiBold.font(size: 14)
    })
    lazy var divider = UIView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
    }
}
extension GradeTodoCell {
    private func initUI() {
        selectionStyle = .none
        divider = CommonView.divider()
        
        contentView.addSubview(icToggle)
        contentView.addSubview(btnTime)
        contentView.addSubview(viewPrefix)
        contentView.addSubview(lblPrefix)
        contentView.addSubview(lblTitle)
        
        icToggle.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(24)
        })
        btnTime.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(icToggle.snp.trailing).offset(12)
            $0.width.equalTo(80)
            $0.height.equalTo(30)
        })
        viewPrefix.snp.makeConstraints({
            $0.height.width.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(btnTime.snp.trailing).offset(12)
        })
        lblPrefix.snp.makeConstraints({
            $0.center.equalTo(viewPrefix)
        })
        
        lblTitle.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(viewPrefix.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-20)
        })
    }
    
    func unperform(scheduleType: ScheduleType, goalCount: Int?) {
        self.contentView.backgroundColor = Asset.Color.monoWhite.color
        
        icToggle.setImage(Asset.Icon.todoNonSelect.image, for: .normal)
        btnTime.setTitleColor(Asset.Color.monoDark010.color, for: .normal)
        btnTime.backgroundColor = Asset.Color.monoLight010.color
        lblTitle.textColor = Asset.Color.monoDark010.color
        
        if scheduleType == .todo {
            lblPrefix.text = "할일"
            lblPrefix.textColor = Asset.Color.monoWhite.color
            
            viewPrefix.backgroundColor = Asset.Color.priMain.color
            
            setPrefix(false)
        } else {
            if let cnt = goalCount, cnt > 0 {
                lblPrefix.text = "\(cnt)회"
                lblPrefix.textColor = Asset.Color.monoDark010.color
                
                viewPrefix.backgroundColor = Asset.Color.subLight030.color
                setPrefix(false)
            } else {
                setPrefix(true)
            }
        }
    }
    
    func complete(scheduleType: ScheduleType, goalCount: Int?) {
        self.contentView.backgroundColor = Asset.Color.monoLight010.color
        
        icToggle.setImage(Asset.Icon.todoSelect.image, for: .normal)
        btnTime.setTitleColor(Asset.Color.monoDark020.color, for: .normal)
        btnTime.backgroundColor = Asset.Color.monoLight030.color
        lblTitle.textColor = Asset.Color.monoDark020.color
        
        lblPrefix.textColor = Asset.Color.monoDark020.color
        viewPrefix.backgroundColor = Asset.Color.monoLight030.color
        
        if scheduleType == .todo {
            lblPrefix.text = "할일"
            setPrefix(false)
        } else {
            if let cnt = goalCount, cnt > 0 {
                lblPrefix.text = "\(cnt)회"
                setPrefix(false)
            } else {
                setPrefix(true)
            }
        }
    }
    
    func skip(scheduleType: ScheduleType, goalCount: Int?) {
        self.contentView.backgroundColor = Asset.Color.subLight010.color
        
        icToggle.setImage(Asset.Icon.delay.image, for: .normal)
        btnTime.setTitleColor(Asset.Color.monoDark010.color, for: .normal)
        btnTime.backgroundColor = Asset.Color.subLight020.color
        lblTitle.textColor = Asset.Color.monoDark010.color
        
        lblPrefix.textColor = Asset.Color.monoDark010.color
        viewPrefix.backgroundColor = Asset.Color.subLight020.color
        
        if scheduleType == .todo {
            lblPrefix.text = "할일"
            setPrefix(false)
        } else {
            if let cnt = goalCount, cnt > 0 {
                lblPrefix.text = "\(cnt)회"
                setPrefix(false)
            } else {
                setPrefix(true)
            }
        }
    }
    
    private func setPrefix(_ isHidden: Bool) {
        if isHidden {
            lblPrefix.text = ""
            
            viewPrefix.isHidden = true
            lblPrefix.isHidden = true
            
            viewPrefix.snp.updateConstraints({
                $0.width.equalTo(0)
                $0.leading.equalTo(btnTime.snp.trailing).offset(0)
            })
            
            lblTitle.snp.updateConstraints({
                $0.leading.equalTo(viewPrefix.snp.trailing).offset(12)
            })
                
        } else {
            viewPrefix.isHidden = false
            lblPrefix.isHidden = false
            
            viewPrefix.snp.updateConstraints({
                $0.height.width.equalTo(24)
                $0.leading.equalTo(btnTime.snp.trailing).offset(12)
            })
            
            lblTitle.snp.updateConstraints({
                $0.leading.equalTo(viewPrefix.snp.trailing).offset(8)
            })
        }
    }
}

enum ScheduleType: String {
    case routine = "ROUTINE"
    case todo = "TODO"
}

enum ScheduleSatus: Int {
    case unperform = 0
    case complete = 1
    case skip = 2
}
