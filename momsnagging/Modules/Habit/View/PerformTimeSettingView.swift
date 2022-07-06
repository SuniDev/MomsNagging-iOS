//
//  PerformTimeSettingView.swift
//  momsnagging
//
//  Created by suni on 2022/05/10.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxKeyboard
import RxCocoa
import SwiftyJSON

class PerformTimeSettingView: BaseViewController, Navigatable {
    
    // MARK: - Properties & Variable
    private var disposeBag = DisposeBag()
    var viewModel: PerformTimeSettingViewModel?
    var navigator: Navigator!
    
    private let timeGuideCellSpacing: CGFloat = 8
    private let timeGuideLineSpacing: CGFloat = 11
    private var timeGuideCellHeight: CGFloat = 36
    private let timeGuideIdentifier = "PerformTimeGuideCell"
    
    // MARK: - UI Properties
    lazy var viewHeader = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
    })
    lazy var btnCancel = UIButton().then({
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(Asset.Color.monoDark020.color, for: .normal)
        $0.titleLabel?.font = FontFamily.Pretendard.regular.font(size: 16)
    })
    lazy var btnSave = UIButton().then({
        $0.setTitle("저장", for: .normal)
        $0.setTitleColor(Asset.Color.success.color, for: .normal)
        $0.setTitleColor(Asset.Color.monoDark040.color, for: .disabled)
        $0.titleLabel?.font = FontFamily.Pretendard.bold.font(size: 16)
        $0.isEnabled = false
    })
    lazy var lblHeadTitle = UILabel().then({
        $0.textColor = Asset.Color.monoDark010.color
        $0.text = "수행 시간 설정"
        $0.font = FontFamily.Pretendard.semiBold.font(size: 20)
    })
    
    lazy var viewBackground = UIView().then({
        $0.backgroundColor = Asset.Color.monoWhite.color
    })
    
    lazy var lblTitle = UILabel().then({
        $0.textColor = Asset.Color.monoDark010.color
        $0.text = "수행 시간"
        $0.font = FontFamily.Pretendard.bold.font(size: 16)
    })
    
    lazy var viewHintTextField = UIView()
    lazy var tfPerformTime = CommonTextField().then({
        $0.normalBorderColor = Asset.Color.monoLight030.color
        $0.placeholder = "밥 먹고 난 후, 씻고 나서, 아침 7:00"
        $0.returnKeyType = .done
        $0.clearButtonMode = .whileEditing
    })
    lazy var lblHint = CommonHintLabel()
    lazy var lblTextCount = UILabel().then({
        $0.font = FontFamily.Pretendard.regular.font(size: 14)
        $0.textColor = Asset.Color.monoDark020.color
        $0.text = "0/11"
    })
    
    lazy var timeGuideCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: timeGuideCellLayout())
        collectionView.register(PerformTimeGuideCell.self, forCellWithReuseIdentifier: timeGuideIdentifier)
        collectionView.backgroundColor = Asset.Color.monoWhite.color
        collectionView.contentInset = .zero
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private func timeGuideCellLayout() -> UICollectionViewFlowLayout {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.sectionInset = .zero
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = timeGuideCellSpacing
        layout.minimumLineSpacing = timeGuideLineSpacing
        return layout
    }
    
    // MARK: - init
    init(viewModel: PerformTimeSettingViewModel, navigator: Navigator) {
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
        
    }
    
    // MARK: - initUI
    override func initUI() {
        view.backgroundColor = Asset.Color.monoWhite.color
        viewHintTextField = CommonView.hintTextFieldFrame(tf: tfPerformTime, lblHint: lblHint)
    }
    
    // MARK: - layoutSetting
    override func layoutSetting() {
        view.addSubview(viewHeader)
        viewHeader.addSubview(btnCancel)
        viewHeader.addSubview(lblHeadTitle)
        viewHeader.addSubview(btnSave)
        
        view.addSubview(viewBackground)
        viewBackground.addSubview(lblTitle)
        viewBackground.addSubview(viewHintTextField)
        viewHintTextField.addSubview(lblTextCount)
        
        viewBackground.addSubview(timeGuideCollectionView)
        
        viewHeader.snp.makeConstraints({
            $0.height.equalTo(60)
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        })
        btnCancel.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        })
        lblHeadTitle.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
        btnSave.snp.makeConstraints({
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        })
        
        viewBackground.snp.makeConstraints({
            $0.top.equalTo(viewHeader.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        })
        
        lblTitle.snp.makeConstraints({
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(16)
        })
        viewHintTextField.snp.makeConstraints({
            $0.height.equalTo(76)
            $0.top.equalTo(lblTitle.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        })
        lblTextCount.snp.makeConstraints({
            $0.trailing.bottom.equalToSuperview()
        })
        
        timeGuideCollectionView.snp.makeConstraints({
            $0.width.equalTo(300)
            $0.top.equalTo(viewHintTextField.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
        })
    }
    
    // MARK: - bind
    override func bind() {
        guard let viewModel = viewModel else { return }
        
        let input = PerformTimeSettingViewModel.Input(
            willAppearPerformTimeSetting: self.rx.viewWillAppear.mapToVoid().asDriverOnErrorJustComplete(),
            btnCacelTapped: self.btnCancel.rx.tap.asDriverOnErrorJustComplete(),
            textTime: self.tfPerformTime.rx.text.orEmpty.distinctUntilChanged().asDriverOnErrorJustComplete(),
            editingDidBeginTime: self.tfPerformTime.rx.controlEvent(.editingDidBegin).asDriverOnErrorJustComplete(),
            editingDidEndTime: self.tfPerformTime.rx.controlEvent(.editingDidEnd).asDriverOnErrorJustComplete(),
            timeGuideItemSelected: self.timeGuideCollectionView.rx.itemSelected.asDriver(),
            btnSaveTapped: self.btnSave.rx.tap.asDriverOnErrorJustComplete())
        
        let output = viewModel.transform(input: input)
        
        output.goToBack
            .drive(onNext: {
                self.navigator.pop(sender: self)
            }).disposed(by: disposeBag)
        
        /// 수행 시간
        output.isEditingTime
            .drive(onNext: { isEditing in
                if isEditing {
                    self.tfPerformTime.edit()
                } else {
                    self.tfPerformTime.normal()
                }
            }).disposed(by: disposeBag)
        
        output.textHint
            .drive(onNext: { type in
                switch type {
                case .none:
                    self.lblHint.normal()
                    self.tfPerformTime.normal()
                case .invalid:
                    self.lblHint.error(type.rawValue)
                    self.lblHint.text = type.rawValue
                    self.tfPerformTime.error()
                }
            }).disposed(by: disposeBag)
        
        output.textConunt
            .drive(onNext: { count in
                if count > 11 {
                    self.lblTextCount.text = "11/11"
                } else {
                    self.lblTextCount.text = "\(count)/11"
                }
            }).disposed(by: disposeBag)
        
        output.cntTimeGuide
            .drive(onNext: { count in
                let line = ( count / 3 ) + ( count % 3 )
                var height = line * Int(self.timeGuideCellHeight)
                height += Int(self.timeGuideLineSpacing) * (line - 1)
                self.timeGuideCollectionView.snp.makeConstraints({
                    $0.height.equalTo(height)
                })
            }).disposed(by: disposeBag)
        
        output.timeGuideItems
            .bind(to: timeGuideCollectionView.rx.items(cellIdentifier: timeGuideIdentifier, cellType: PerformTimeGuideCell.self)) { _, item, cell in
                cell.lblTitle.text = item
                cell.lblTitle.sizeToFit()
            }.disposed(by: disposeBag)
        
        timeGuideCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        output.setTextTime
            .drive(onNext: { text in
                self.tfPerformTime.text = text
            }).disposed(by: disposeBag)
        
        output.canBeSave
            .drive(onNext: { isCanBeSave in
                self.btnSave.isEnabled = isCanBeSave
            }).disposed(by: disposeBag)
        
        tfPerformTime.rx.text.subscribe(onNext: { text in
            if text!.count > 11 {
                self.tfPerformTime.text?.removeLast()
            }
        }).disposed(by: disposeBag)
    }
}
extension PerformTimeSettingView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = viewModel?.timeGuideItems.value[indexPath.row]
        
        let label = UILabel().then {
               $0.font = FontFamily.Pretendard.regular.font(size: 14)
               $0.text = item
               $0.sizeToFit()
        }
        let size = label.frame.size
        
        return CGSize(width: size.width + 32, height: self.timeGuideCellHeight)
    }
}
