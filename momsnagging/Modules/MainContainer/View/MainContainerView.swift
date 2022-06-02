//
//  MainContainerView.swift
//  momsnagging
//
//  Created by 전창평 on 2022/04/30.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

var globalTabOb = PublishSubject<Int>()
class MainContainerView: BaseViewController, Navigatable {
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setHomeView()
    }
    // MARK: - Init
    init(viewModel: MainContainerViewModel, navigator: Navigator) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.navigator = navigator
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Tabbar Child View
//    let tab0 = HomeView(viewModel: HomeViewModel(), navigator: Navigator())
    let homeViewModel = HomeViewModel()
    var tab0: UIViewController!
    var tab1: UIViewController!
    var tab2: UIViewController!
    // MARK: - Properties & Variable
    var disposedBag = DisposeBag()
    var navigator: Navigator!
    var viewModel: MainContainerViewModel!
    
    // MARK: - UI Properties
    var tabbarBtn1 = UIButton()
    var tabbarIc1 = UIImageView()
    var tabbarLbl1 = UILabel()
    var tabbarBtn2 = UIButton()
    var tabbarIc2 = UIImageView()
    var tabbarLbl2 = UILabel()
    var tabbarBtn3 = UIButton()
    var tabbarIc3 = UIImageView()
    var tabbarLbl3 = UILabel()
    var bottomTabbar = UIView()
    var inView = UIView()
    var containerView: UIContentContainer?
    // MARK: - InitUI
    override func initUI() {
//        view.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        view.backgroundColor = .clear
        let homeViewModel = HomeViewModel()
        let gardeViewModel = GradeViewModel(withService: SceneDelegate.appService, mainTabHandler: viewModel.tabHandler)
        let myViewModel = MyViewModel(withService: SceneDelegate.appService)
        tab0 = navigator.get(seque: .home(viewModel: homeViewModel))
        tab1 = navigator.get(seque: .grade(viewModel: gardeViewModel))
        tab2 = navigator.get(seque: .my(viewModel: myViewModel))
        bottomTabbar = tabbarLayout(tabButton1: tabbarBtn1, tabButton2: tabbarBtn2, tabButton3: tabbarBtn3, tabIcon1: tabbarIc1, tabIcon2: tabbarIc2, tabIcon3: tabbarIc3, tabLabel1: tabbarLbl1, tabLabel2: tabbarLbl2, tabLabel3: tabbarLbl3)
        bottomTabbar.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
    }
    // MARK: - LayoutSetting
    override func layoutSetting() {
        view.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        view.addSubview(bottomTabbar)
        bottomTabbar.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.snp.bottom)
        })
    }
    
    // MARK: Bind
    override func bind() {
        tabbarBtn1.rx.tap.bind(onNext: { _ in
            self.tabbarButtonBind(buttonTag: 0)
            globalTabOb.onNext(0)
            self.setHomeView()
        }).disposed(by: disposedBag)
        
        tabbarBtn2.rx.tap.bind(onNext: { _ in
            self.tabbarButtonBind(buttonTag: 1)
            globalTabOb.onNext(1)
            self.setReportCardView()
        }).disposed(by: disposedBag)
        
        tabbarBtn3.rx.tap.bind(onNext: { _ in
            self.tabbarButtonBind(buttonTag: 2)
            globalTabOb.onNext(2)
            self.setMyView()
        }).disposed(by: disposedBag)
    }
    
    /**
     # tabbarButtonBind
     - Authors : tavi
     - parameters:
        - buttonTag : 바텀 아이템 버튼의 태그 (홈: 0, 성적표: 1, 마이: 2)
     - Note : ClickEvent 시 buttonTag만 다르고 단순 반복되는 형태라 따로 생성한 함수. 2022.04.30
     */
    func tabbarButtonBind(buttonTag: Int) {
        guard let viewModel = viewModel else { return }
        lazy var input = MainContainerViewModel.Input(buttonTag: Observable.just(buttonTag))
        lazy var output = viewModel.transform(input: input)
        output.buttonLabelColorList[0].drive(onNext: { [weak self] in
            self?.tabbarIc1.tintColor = UIColor(asset: $0)
            self?.tabbarLbl1.textColor = UIColor(asset: $0)
        }).disposed(by: self.disposedBag)
        output.buttonLabelColorList[1].drive(onNext: { [weak self] in
            self?.tabbarIc2.tintColor = UIColor(asset: $0)
            self?.tabbarLbl2.textColor = UIColor(asset: $0)
        }).disposed(by: self.disposedBag)
        output.buttonLabelColorList[2].drive(onNext: { [weak self] in
            self?.tabbarIc3.tintColor = UIColor(asset: $0)
            self?.tabbarLbl3.textColor = UIColor(asset: $0)
        }).disposed(by: self.disposedBag)
    }
    
}

extension MainContainerView {
    
    /**
     # tabbarLayout
     - Authors : tavi
     - parameters:
        - tabButton : tabbar의 아이템 클릭 이벤트 담당하는 empty button
        - tabIcon : 아이템의 icon
        - tabLabel : 아이템의 label
     - Note : 하단 탭바 레이아웃 구성 함수 _ 상단에 놔두면 보기 불편해서 따로 빼놓은 겁니당
     */
    func tabbarLayout(tabButton1: UIButton, tabButton2: UIButton, tabButton3: UIButton, tabIcon1: UIImageView, tabIcon2: UIImageView, tabIcon3: UIImageView, tabLabel1: UILabel, tabLabel2: UILabel, tabLabel3: UILabel) -> UIView {
        let view = UIView()
        tabIcon1.image = UIImage(asset: Asset.Icon.home)?.withRenderingMode(.alwaysTemplate)
        tabIcon2.image = UIImage(asset: Asset.Icon.reportCard)?.withRenderingMode(.alwaysTemplate)
        tabIcon3.image = UIImage(asset: Asset.Icon.my)?.withRenderingMode(.alwaysTemplate)
        
        tabIcon1.tintColor = UIColor(asset: Asset.Color.priMain)
        tabIcon2.tintColor = UIColor(asset: Asset.Color.monoDark020)
        tabIcon3.tintColor = UIColor(asset: Asset.Color.monoDark020)
        
        tabLabel1.text = "홈"
        tabLabel1.textColor = UIColor(asset: Asset.Color.priMain)
        tabLabel1.font = FontFamily.Pretendard.bold.font(size: 10)
        tabLabel2.text = "성적표"
        tabLabel2.textColor = UIColor(asset: Asset.Color.monoDark020)
        tabLabel2.font = FontFamily.Pretendard.bold.font(size: 10)
        tabLabel3.text = "마이"
        tabLabel3.textColor = UIColor(asset: Asset.Color.monoDark020)
        tabLabel3.font = FontFamily.Pretendard.bold.font(size: 10)
        
        view.addSubview(tabIcon1)
        view.addSubview(tabIcon2)
        view.addSubview(tabIcon3)
        view.addSubview(tabLabel1)
        view.addSubview(tabLabel2)
        view.addSubview(tabLabel3)
        view.addSubview(tabButton1)
        view.addSubview(tabButton2)
        view.addSubview(tabButton3)
        
        tabButton2.snp.makeConstraints({
            $0.width.equalTo(UIScreen.main.bounds.width / 3)
            $0.centerX.equalTo(view.snp.centerX)
            $0.top.equalTo(view.snp.top)
            $0.bottom.equalTo(view.snp.bottom)
        })
        tabButton1.snp.makeConstraints({
            $0.top.equalTo(view.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(tabButton2.snp.leading)
            $0.bottom.equalTo(view.snp.bottom)
        })
        tabButton3.snp.makeConstraints({
            $0.top.equalTo(view.snp.top)
            $0.leading.equalTo(tabButton2.snp.trailing)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.snp.bottom)
        })
        
        tabIcon1.snp.makeConstraints({
            $0.top.equalTo(tabButton1.snp.top).offset(9)
            $0.centerX.equalTo(tabButton1.snp.centerX)
            $0.width.height.equalTo(26)
        })
        tabIcon2.snp.makeConstraints({
            $0.top.equalTo(tabButton2.snp.top).offset(9)
            $0.centerX.equalTo(tabButton2.snp.centerX)
            $0.width.height.equalTo(26)
        })
        tabIcon3.snp.makeConstraints({
            $0.top.equalTo(tabButton3.snp.top).offset(9)
            $0.centerX.equalTo(tabButton3.snp.centerX)
            $0.width.height.equalTo(26)
        })
        
        tabLabel1.snp.makeConstraints({
            $0.centerX.equalTo(tabButton1.snp.centerX)
            $0.top.equalTo(tabIcon1.snp.bottom).offset(5)
        })
        tabLabel2.snp.makeConstraints({
            $0.centerX.equalTo(tabButton2.snp.centerX)
            $0.top.equalTo(tabIcon2.snp.bottom).offset(5)
        })
        tabLabel3.snp.makeConstraints({
            $0.centerX.equalTo(tabButton3.snp.centerX)
            $0.top.equalTo(tabIcon3.snp.bottom).offset(5)
        })
        
        return view
    }
    /**
     # setMyView
     - Authors : tavi
     - Note : Container에있는 tab0(홈 페이지로 이동)
     */
    func setHomeView() {
        view.addSubview(tab0.view)
        tab0.view.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(bottomTabbar.snp.top)
        })
        tab0.didMove(toParent: self)
    }
    /**
     # setMyView
     - Authors : tavi
     - Note : Container에있는 tab1(성적표 페이지로 이동)
     */
    func setReportCardView() {
        view.addSubview(tab1.view)
        tab1.view.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(bottomTabbar.snp.top)
        })
        tab1.didMove(toParent: self)
        
    }
    /**
     # setMyView
     - Authors : tavi
     - Note : Container에있는 tab2(마이 페이지로 이동)
     */
    func setMyView() {
        view.addSubview(tab2.view)
        tab2.view.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(bottomTabbar.snp.top)
        })
        tab2.didMove(toParent: self)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
    }
    
}
