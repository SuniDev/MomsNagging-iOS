//
//  DetailHabitView.swift
//  momsnagging
//
//  Created by suni on 2022/05/06.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxKeyboard
import RxCocoa

class DetailHabitView: BaseViewController, Navigatable {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: DetailHabitViewModel?
    var navigator: Navigator!
    
    // MARK: - UI Properties
    lazy var viewHeader = UIView()
    lazy var btnBack = UIButton()
    lazy var btnDone = UIButton()
    lazy var btnMore = UIButton()
    lazy var lblTitle = UILabel().then({
        $0.text = "습관 상세"
    })
    
    lazy var scrollView = UIScrollView()
    lazy var viewContents = UIView()
    lazy var viewNameTitle = UIView()
    lazy var tfName = UITextField()
    lazy var divider1 = UIView()
    lazy var viewTimeTitle = UIView()
    lazy var viewTime = UIView()
    lazy var lblTime = UILabel().then({
        $0.text = "아직 정해지지 않았단다"
        $0.textColor = Asset.Color.monoDark030.color
        $0.font = FontFamily.Pretendard.regular.font(size: 14)
    })
    lazy var divider2 = UIView()
    lazy var viewCycleTitle = UIView()
    lazy var viewCycleType = UIView().then({
        $0.addBorder(color: Asset.Color.monoLight020.color, width: 1)
        $0.layer.cornerRadius = 8
    })
    lazy var btnCycleWeek = CommonButton().then({
        $0.layer.cornerRadius = 5
        $0.normalBackgroundColor = Asset.Color.monoWhite.color
        $0.highlightedBackgroundColor = .clear
        $0.selectedBackgroundColor = Asset.Color.priLight010.color
        $0.setTitle("요일", for: .normal)
        $0.setTitleColor(Asset.Color.monoDark030.color, for: .normal)
        $0.setTitleColor(Asset.Color.monoWhite.color, for: .selected)
    })
    lazy var btnCycleNumber = CommonButton().then({
        $0.layer.cornerRadius = 5
        $0.normalBackgroundColor = Asset.Color.monoWhite.color
        $0.highlightedBackgroundColor = .clear
        $0.selectedBackgroundColor = Asset.Color.priLight010.color
        $0.setTitle("N회", for: .normal)
        $0.setTitleColor(Asset.Color.monoDark030.color, for: .normal)
        $0.setTitleColor(Asset.Color.monoWhite.color, for: .selected)
    })
    
    // MARK: - init
    init(viewModel: DetailHabitViewModel, navigator: Navigator) {
        self.viewModel = viewModel
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - initUI
    override func initUI() {
        view.backgroundColor = Asset.Color.monoWhite.color
        
        viewHeader = CommonView.detailHeadFrame(btnBack: btnBack, lblTitle: lblTitle, btnDone: btnDone)
        scrollView = CommonView.scrollView(viewContents: viewContents, bounces: true)
        viewNameTitle = CommonView.requiredTitleFrame("습관 이름")
         
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
        view.addSubview(viewHeader)
        
    }
}
