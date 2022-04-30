//
//  ReportCardView.swift
//  momsnagging
//
//  Created by 전창평 on 2022/04/30.
//

import UIKit
import Then
import SnapKit
import RxSwift

class ReportCardView: BaseViewController, Navigatable {
    var navigator: Navigator!
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        testLabel()
    }
    // MARK: - Temp
    func testLabel() {
        view.addSubview(lbl)
        lbl.snp.makeConstraints({
            $0.center.equalTo(view.snp.center)
        })
    }
    let lbl = UILabel().then({
        $0.text = "성적표!!!!"
        $0.textColor = UIColor(asset: Asset.Color.black)
        $0.font = FontFamily.Pretendard.bold.font(size: 20)
    })
    
    // MARK: - Init
    // MARK: - Properties & Variable
    // MARK: - UI Properties
    // MARK: - InitUI
    // MARK: - LayoutSetting
    // MARK: - Bind _ Output
    // MARK: - Action Bind _ Input
    // MARK: - Other
}
