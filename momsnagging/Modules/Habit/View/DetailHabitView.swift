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
    lazy var lblTime = UILabel()
    
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
        tfName = CommonView.textField()
        
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
        view.addSubview(viewHeader)
        
    }
}
