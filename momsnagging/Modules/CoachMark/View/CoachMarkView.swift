//
//  CoachMarkView.swift
//  momsnagging
//
//  Created by suni on 2022/05/30.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class CoachMarkView: BaseViewController, Navigatable {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: CoachMarkViewModel?
    var navigator: Navigator!
    
    // MARK: - UI Properties
    
    // 디폴트 뷰
    lazy var viewBackgroundView = UIView()
    lazy var viewDefault = UIView().then({
        $0.backgroundColor = .clear
    })
    lazy var btnClose = UIButton().then({
        $0.setImage(Asset.Icon.xFloating.image, for: .normal)
    })
    lazy var btnNext = UIButton().then({
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = Asset.Color.monoWhite.color
        $0.setTitleColor(Asset.Color.priMain.color, for: .normal)
        $0.titleLabel?.font = FontFamily.Pretendard.semiBold.font(size: 20)
        $0.layer.cornerRadius = 28
        $0.addShadow(color: Asset.Color.monoDark010.color, alpha: 0.25, x: 0, y: 4, blur: 40, spread: 0)
    })
    
    lazy var viewCoachMark = UIView().then({
        $0.backgroundColor = .clear
    })
    
    // 코치마크 1 : 메인 플로팅 버튼
    lazy var viewCoachMark1 = UIView().then({
        $0.isHidden = true
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = false
    })
    lazy var viewDimCoachMark1 = UIView().then({
        $0.backgroundColor = Asset.Color.monoDark010.color
        $0.alpha = 0.6
    })
    lazy var imgvTip1 = UIImageView().then({
        $0.image = Asset.Assets.coachmarkTip1.image
    })
    
    lazy var vFloatingClose = UIView().then({
        $0.backgroundColor = Asset.Color.priMain.color
        $0.layer.cornerRadius = 28
    })
    lazy var imgvFloatingClose = UIImageView().then({
        $0.image = Asset.Icon.xFloating.image
    })
    
    lazy var vAddHabit = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
        $0.layer.cornerRadius = 28
    })
    lazy var imgvAddHabit = UIImageView().then({
        $0.image = Asset.Icon.habitAddFloating.image
    })
    
    lazy var vAddTodo = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
        $0.layer.cornerRadius = 28
    })
    lazy var imgvAddTodo = UIImageView().then({
        $0.image = Asset.Icon.todoAddFloating.image
    })
    
    // 코치마크 2 - 1 : 습관 추가
    lazy var viewDimCoachMark2Top = UIView().then({
        $0.backgroundColor = Asset.Color.monoDark010.color
        $0.alpha = 0.6
    })
    lazy var viewDimCoachMark2Bottom = UIView().then({
        $0.backgroundColor = Asset.Color.monoDark010.color
        $0.alpha = 0.6
    })
    lazy var viewCoachMark2 = UIView().then({
        $0.isHidden = true
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = false
    })
    lazy var imgvTip2A = UIImageView().then({
        $0.image = Asset.Assets.coachmarkTip2A.image
    })
    lazy var imgvTip2B = UIImageView().then({
        $0.image = Asset.Assets.coachmarkTip2B.image
    })
    
    // 코치마크 2 - 2 : 습관 상세
    lazy var viewDimCoachMark2CBottom = UIView().then({
        $0.isHidden = true
        $0.backgroundColor = Asset.Color.monoDark010.color
    })
    lazy var imgvTip2C = UIImageView().then({
        $0.isHidden = true
        $0.image = Asset.Assets.coachmarkTip2C.image
    })
    
    // 코치마크 3 - 1 : 홈 화면 습관 확인
    lazy var viewDimCoachMark3Top = UIView().then({
        $0.backgroundColor = Asset.Color.monoDark010.color
        $0.alpha = 0.6
    })
    lazy var viewDimCoachMark3Bottom = UIView().then({
        $0.backgroundColor = Asset.Color.monoDark010.color
        $0.alpha = 0.6
    })
    lazy var viewCoachMark3 = UIView().then({
        $0.isHidden = true
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = false
    })
    lazy var imgvTip3A = UIImageView().then({
        $0.image = Asset.Assets.coachmarkTip3A.image
    })
    lazy var vRoutinCell = UIView()
    lazy var imgvRoutineCheckBox = UIImageView().then({
        $0.image = Asset.Icon.todoNonSelect.image
    })
    lazy var btnRoutineTime = UIButton().then({
        $0.isUserInteractionEnabled = false
        $0.setTitle("6:00 AM", for: .normal)
        $0.setTitleColor(Asset.Color.monoDark010.color, for: .normal)
        $0.titleLabel?.font = FontFamily.Pretendard.regular.font(size: 12)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = Asset.Color.monoLight010.color
    })
    lazy var btnRoutineCount = UIButton().then({
        $0.isUserInteractionEnabled = false
        $0.setTitle("4회", for: .normal)
        $0.setTitleColor(Asset.Color.monoDark010.color, for: .normal)
        $0.titleLabel?.font = FontFamily.Pretendard.regular.font(size: 12)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = Asset.Color.subLight030.color
    })
    lazy var lblRoutineTitle = UILabel().then({
        $0.text = "명상하기"
        $0.font = FontFamily.Pretendard.semiBold.font(size: 14)
        $0.textColor = Asset.Color.monoDark010.color
    })
    lazy var imgvMore = UIImageView().then({
        $0.image = Asset.Icon.moreVertical.image
    })
    
    // 코치마크 3 - 2 : 홈 화면 습관 체크
    lazy var imgvTip3B = UIImageView().then({
        $0.isHidden = true
        $0.image = Asset.Assets.coachmarkTip3B.image
    })
    
    // 코치마크 3 - 3 : 홈 화면 더보기 팝업
    lazy var viewDimCoachMark3Full = UIView().then({
        $0.isHidden = true
        $0.backgroundColor = Asset.Color.monoDark010.color
    })
    lazy var imgvTip3C = UIImageView().then({
        $0.isHidden = true
        $0.image = Asset.Assets.coachmarkTip3C.image
    })
    lazy var imgvMorePopup = UIImageView().then({
        $0.isHidden = true
        $0.image = Asset.Assets.coachmarkMorePopuup.image
    })
    
    // 코치마크 마지막
    lazy var imgvTipLast = UIImageView().then({
        $0.isHidden = true
        $0.image = Asset.Assets.coachmarkTipLast.image
    })
    
    // MARK: - init
    init(viewModel: CoachMarkViewModel, navigator: Navigator) {
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
        // GA - 코치마크 화면
        CommonAnalytics.logScreenView(.coachmark)
        
        // GA - 코치마크 첫 화면
        CommonAnalytics.logEvent(.first_coachmark_view)
        
        view.backgroundColor = Asset.Color.monoWhite.color
    }
    
    // MARK: - initUI
    override func initUI() {
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
        let topPadding = Common.getTopPadding()
        let bottomPadding = Common.getBottomPadding()
        
        // 디폴트
        view.addSubview(viewBackgroundView)
        viewBackgroundView.snp.makeConstraints({
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        })
        
        view.addSubview(viewCoachMark)
        viewCoachMark.snp.makeConstraints({
            $0.leading.trailing.top.bottom.equalToSuperview()
        })
        
        view.addSubview(viewDefault)
        viewDefault.addSubview(btnClose)
        viewDefault.addSubview(btnNext)
        viewDefault.snp.makeConstraints({
            $0.leading.trailing.top.bottom.equalTo(view.safeAreaLayoutGuide)
        })
        btnClose.snp.makeConstraints({
            $0.height.width.equalTo(36)
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-20)
        })
        btnNext.snp.makeConstraints({
            $0.width.equalTo(100)
            $0.height.equalTo(56)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-32)
        })
        
        // 코치마크 1 : 메인 플로팅 버튼
        viewCoachMark.addSubview(viewCoachMark1)
        viewCoachMark1.snp.makeConstraints({
            $0.leading.trailing.top.bottom.equalToSuperview()
        })
        
        viewCoachMark1.addSubview(viewDimCoachMark1)
        viewDimCoachMark1.snp.makeConstraints({
            $0.top.bottom.leading.trailing.equalToSuperview()
        })
        
        viewCoachMark1.addSubview(imgvTip1)
        viewCoachMark1.addSubview(vFloatingClose)
        vFloatingClose.addSubview(imgvFloatingClose)
        viewCoachMark1.addSubview(vAddHabit)
        vAddHabit.addSubview(imgvAddHabit)
        viewCoachMark1.addSubview(vAddTodo)
        vAddTodo.addSubview(imgvAddTodo)
        vFloatingClose.snp.makeConstraints({
            $0.height.width.equalTo(56)
            $0.bottom.equalToSuperview().offset(-(83 + bottomPadding))
            $0.trailing.equalToSuperview().offset(-16)
        })
        imgvFloatingClose.snp.makeConstraints({
            $0.height.width.equalTo(30)
            $0.center.equalToSuperview()
        })
        vAddTodo.snp.makeConstraints({
            $0.height.width.equalTo(56)
            $0.bottom.equalTo(vFloatingClose.snp.top).offset(-24)
            $0.trailing.equalToSuperview().offset(-16)
        })
        imgvAddHabit.snp.makeConstraints({
            $0.height.width.equalTo(24)
            $0.center.equalToSuperview()
        })
        vAddHabit.snp.makeConstraints({
            $0.height.width.equalTo(56)
            $0.bottom.equalTo(vAddTodo.snp.top).offset(-24)
            $0.trailing.equalToSuperview().offset(-16)
        })
        imgvAddTodo.snp.makeConstraints({
            $0.height.width.equalTo(24)
            $0.center.equalToSuperview()
        })
        imgvTip1.snp.makeConstraints({
            $0.trailing.equalToSuperview().offset(-30)
            $0.bottom.equalTo(vAddHabit.snp.top).offset(-14)
        })
        
        // 코치마크 2 - 1: 습관 추가
        viewCoachMark.addSubview(viewCoachMark2)
        viewCoachMark2.snp.makeConstraints({
            $0.leading.trailing.top.bottom.equalToSuperview()
        })
        
        var dimTopHeight = topPadding + 76.0
        viewCoachMark2.addSubview(viewDimCoachMark2Top)
        viewDimCoachMark2Top.snp.makeConstraints({
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(dimTopHeight)
        })
        
        var dimBottomHeight = self.view.frame.height - 514.0 - dimTopHeight
        viewCoachMark2.addSubview(viewDimCoachMark2Bottom)
        viewDimCoachMark2Bottom.snp.makeConstraints({
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(dimBottomHeight)
        })
        
        viewCoachMark2.addSubview(imgvTip2A)
        viewCoachMark2.addSubview(imgvTip2B)
        imgvTip2A.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(30)
            $0.top.equalTo(viewDimCoachMark2Top.snp.bottom).offset(42)
        })
        imgvTip2B.snp.makeConstraints({
            $0.trailing.equalToSuperview().offset(-30)
            $0.top.equalTo(viewDimCoachMark2Top.snp.bottom).offset(286)
        })
        
        // 코치마크 2 - 2 : 습관 상세
//        viewCoachMark2.addSubview(viewDimCoachMark2CBottom)
        viewCoachMark2.addSubview(imgvTip2C)
        
//        dimBottomHeight = self.view.frame.height - 545.0 - dimTopHeight
//        viewDimCoachMark2CBottom.snp.makeConstraints({
//            $0.bottom.leading.trailing.equalToSuperview()
//            $0.height.equalTo(dimBottomHeight)
//        })
        imgvTip2C.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(viewDimCoachMark2Top.snp.bottom).offset(16)
        })
        
        // 코치마크 3 - 1 : 홈 화면 습관 확인
        viewCoachMark.addSubview(viewCoachMark3)
        viewCoachMark3.snp.makeConstraints({
            $0.leading.trailing.top.bottom.equalToSuperview()
        })
        
        dimTopHeight = topPadding + 144.0
        viewCoachMark3.addSubview(viewDimCoachMark3Top)
        viewDimCoachMark3Top.snp.makeConstraints({
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(dimTopHeight)
        })
        
        dimBottomHeight = self.view.frame.height - 60.0 - dimTopHeight
        viewCoachMark3.addSubview(viewDimCoachMark3Bottom)
        viewDimCoachMark3Bottom.snp.makeConstraints({
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(dimBottomHeight)
        })
        
        viewCoachMark3.addSubview(imgvTip3A)
        imgvTip3A.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(30)
            $0.top.equalTo(viewDimCoachMark3Bottom.snp.top).offset(16)
        })
        
        viewCoachMark3.addSubview(vRoutinCell)
        vRoutinCell.addSubview(imgvRoutineCheckBox)
        vRoutinCell.addSubview(btnRoutineTime)
        vRoutinCell.addSubview(btnRoutineCount)
        vRoutinCell.addSubview(lblRoutineTitle)
        vRoutinCell.addSubview(imgvMore)
        vRoutinCell.snp.makeConstraints({
            $0.height.equalTo(60)
            $0.top.equalTo(viewDimCoachMark3Top.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(viewDimCoachMark3Bottom.snp.top)
        })
        imgvRoutineCheckBox.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(24)
        })
        btnRoutineTime.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.width.equalTo(80)
            $0.height.equalTo(30)
            $0.leading.equalTo(imgvRoutineCheckBox.snp.trailing).offset(12)
        })
        btnRoutineCount.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
            $0.leading.equalTo(btnRoutineTime.snp.trailing).offset(12)
        })
        lblRoutineTitle.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(btnRoutineCount.snp.trailing).offset(8)
            $0.trailing.equalTo(imgvMore.snp.leading).offset(-12)
        })
        imgvMore.snp.makeConstraints({
            $0.width.height.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-12)
        })
        
        // 코치마크 3 - 2 : 홈 화면 습관 체크
        viewCoachMark3.addSubview(imgvTip3B)
        imgvTip3B.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(30)
            $0.top.equalTo(viewDimCoachMark3Bottom.snp.top).offset(16)
        })
        
        // 코치마크 3 - 3 : 홈 화면 더보기 팝업
        viewCoachMark3.addSubview(viewDimCoachMark3Full)
        viewCoachMark3.addSubview(imgvMorePopup)
        viewCoachMark3.addSubview(imgvTip3C)
        viewDimCoachMark3Full.snp.makeConstraints({
            $0.top.bottom.leading.trailing.equalToSuperview()
        })
        imgvMorePopup.snp.makeConstraints({
            $0.width.equalTo(110)
            $0.height.equalTo(150)
            $0.top.equalTo(vRoutinCell.snp.centerY)
            $0.trailing.equalToSuperview().offset(-30)
        })
        imgvTip3C.snp.makeConstraints({
            $0.trailing.equalToSuperview().offset(-30)
            $0.top.equalTo(imgvMorePopup.snp.bottom).offset(14)
        })
        
        // 코치마크 3 - 4 : 홈 화면 미룸
        viewCoachMark3.addSubview(imgvTipLast)
        imgvTipLast.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
        
    }
    
    // MARK: - Bind
    override func bind() {
        guard let viewModel = viewModel else { return }

        let input = CoachMarkViewModel.Input(willAppearView: self.rx.viewWillAppear.mapToVoid().asDriverOnErrorJustComplete(),
                                             btnCloseTapped: self.btnClose.rx.tap.asDriverOnErrorJustComplete(),
                                             btnNextTapped: self.btnNext.rx.tap.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.goToMain
            .drive(onNext: { viewModel in
                self.navigator.show(seque: .mainContainer(viewModel: viewModel), sender: nil, transition: .root)
            }).disposed(by: disposeBag)
        
        output.setCoachMarkView
            .drive(onNext: { index, viewModel in
                var view = UIView()
                
                switch index {
                case 0: // 코치마크 1
                    if let viewModel = viewModel as? MainContainerViewModel,
                       let vc = self.navigator.get(seque: .mainContainer(viewModel: viewModel)),
                       let v = vc.view {
                        view = v
                        self.viewCoachMark1.fadeIn()
                    }
                    
                case 1: // 코치마크 2 - 1
                    if let viewModel = viewModel as? AddHabitViewModel,
                       let vc = self.navigator.get(seque: .addHabit(viewModel: viewModel)),
                       let v = vc.view {
                        view = v
                        self.viewCoachMark1.fadeOut()
                        self.viewCoachMark2.fadeIn()
                    }
                    
                case 2: // 코치마크 2 - 2
                    if let viewModel = viewModel as? DetailHabitViewModel,
                       let vc = self.navigator.get(seque: .detailHabit(viewModel: viewModel)),
                       let v = vc.view {
                        view = v
//                        self.viewDimCoachMark2Bottom.fadeOut()
                        self.imgvTip2A.fadeOut()
                        self.imgvTip2B.fadeOut()
//                        self.viewDimCoachMark2CBottom.fadeIn(alpha: 0.6)
                        self.imgvTip2C.fadeIn()
                    }
                    
                case 3: // 코차마크 3 - 1
                    if let viewModel = viewModel as? MainContainerViewModel,
                       let vc = self.navigator.get(seque: .mainContainer(viewModel: viewModel)),
                       let v = vc.view {
                        view = v
                        self.viewDimCoachMark2Top.fadeOut()
                        self.viewDimCoachMark2Bottom.fadeOut()
                        self.viewCoachMark2.fadeOut()
                        self.viewDimCoachMark3Top.fadeIn(alpha: 0.6)
                        self.viewDimCoachMark3Bottom.fadeIn(alpha: 0.6)
                        self.viewCoachMark3.fadeIn()
                    }
                    
                default:
                    break
                }
                
                self.viewBackgroundView.addSubview(view)
                view.snp.makeConstraints({
                    $0.top.bottom.leading.trailing.equalToSuperview()
                })
            }).disposed(by: disposeBag)
        
        output.setCoachMarkIndex
            .filter({ $0 > 3 })
            .drive(onNext: { index in
                switch index {
                case 4:
                    self.imgvRoutineCheckBox.image = Asset.Icon.todoSelect.image
                    self.btnRoutineTime.backgroundColor = Asset.Color.monoLight030.color
                    self.btnRoutineTime.setTitleColor(Asset.Color.monoDark020.color, for: .normal)
                    self.btnRoutineCount.backgroundColor = Asset.Color.monoLight030.color
                    self.btnRoutineCount.setTitleColor(Asset.Color.monoDark020.color, for: .normal)
                    self.lblRoutineTitle.textColor = Asset.Color.monoDark020.color
                    
                    self.imgvTip3A.fadeOut()
                    self.imgvTip3B.fadeIn()
                    
                case 5:
                    self.imgvRoutineCheckBox.image = Asset.Icon.todoNonSelect.image
                    self.btnRoutineTime.backgroundColor = Asset.Color.monoLight010.color
                    self.btnRoutineTime.setTitleColor(Asset.Color.monoDark010.color, for: .normal)
                    self.btnRoutineCount.backgroundColor = Asset.Color.monoLight030.color
                    self.btnRoutineCount.setTitleColor(Asset.Color.monoDark010.color, for: .normal)
                    
                    self.viewDimCoachMark3Top.fadeOut()
                    self.viewDimCoachMark3Bottom.fadeOut()
                    self.imgvTip3B.fadeOut()
                    self.viewDimCoachMark3Full.fadeIn(alpha: 0.6)
                    self.imgvTip3C.fadeIn()
                    self.imgvMorePopup.fadeIn()
                    
                case 6:
                    self.btnNext.setTitle("마침", for: .normal)
                    
                    self.vRoutinCell.fadeOut()
                    self.btnClose.fadeOut()
                    self.imgvTip3C.fadeOut()
                    self.imgvMorePopup.fadeOut()
                    self.imgvTipLast.fadeIn()
                    
                default:
                    break
                }
                
            }).disposed(by: disposeBag)
    }
}
extension CoachMarkView {
    
}
