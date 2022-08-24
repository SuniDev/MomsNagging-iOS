//
//  ContactUsView.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import RxKeyboard

class ContactUsView: BaseViewController, Navigatable {
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Init
    init(viewModel: ContactUsViewModel, navigator: Navigator) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.navigator = navigator
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Properties & Variable
    var disposedBag = DisposeBag()
    var navigator: Navigator!
    var viewModel: ContactUsViewModel!
    // MARK: - UI Properties
    var backBtn = UIButton()
    var headFrame = UIView()
    
    var scrollView = UIScrollView().then({
        $0.showsVerticalScrollIndicator = false
    })
    var backgroundFrame = UIView()
    
    var mainImg = UIImageView().then({
        $0.image = UIImage(asset: Asset.Assets.contactUs)
    })
    var mainTitleLbl = UILabel().then({
        $0.textAlignment = .center
        $0.textColor = UIColor(asset: Asset.Color.monoDark020)
        $0.font = FontFamily.Pretendard.regular.font(size: 18)
        $0.numberOfLines = 0
        let text = "엄마의 잔소리에게\n하고 싶은 말을 전해주세요!"
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.font, value: FontFamily.Pretendard.bold.font(size: 18), range: (text as NSString).range(of: "엄마의 잔소리"))
        attributeString.addAttribute(.font, value: FontFamily.Pretendard.bold.font(size: 18), range: (text as NSString).range(of: "하고 싶은 말"))
        $0.attributedText = attributeString
    })
    var divider = UIView().then({
        $0.backgroundColor = UIColor(asset: Asset.Color.monoLight020)
    })
    var contentsTitleLbl = UILabel().then({
        $0.text = "문의내용"
        $0.font = FontFamily.Pretendard.regular.font(size: 16)
        $0.textColor = UIColor(asset: Asset.Color.monoDark010)
    })
    var contentsFrame = UIView().then({
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(asset: Asset.Color.monoLight030)?.cgColor
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
    })
    var placeHolderLbl = UILabel().then({
        $0.text = "작은 의견도 경청하며 발전하는 엄마의 잔소리가 되겠습니다."
        $0.textColor = UIColor(asset: Asset.Color.monoDark030)
        $0.font = FontFamily.Pretendard.regular.font(size: 14)
    })
    var contentsTextView = UITextView().then({
        $0.textColor = UIColor(asset: Asset.Color.monoDark010)
        $0.font = FontFamily.Pretendard.semiBold.font(size: 14)
        $0.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
    })
    var bottomBtn = UIButton().then({
        $0.setTitle("문의하기", for: .normal)
        $0.setTitleColor(UIColor(asset: Asset.Color.monoWhite), for: .normal)
        $0.titleLabel?.font = FontFamily.Pretendard.bold.font(size: 20)
        $0.backgroundColor = UIColor(asset: Asset.Color.priLight018Dis)
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
    })
    // MARK: - InitUI
    override func initUI() {
        view.backgroundColor = UIColor(asset: Asset.Color.monoWhite)
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        
        view.addGestureRecognizer(singleTapGestureRecognizer)
        headFrame = CommonView.defaultHeadFrame(leftIcBtn: backBtn, headTitle: "문의하기")
        contentsTextView.delegate = self
        
    }
    // MARK: - LayoutSetting
    override func layoutSetting() {
        view.addSubview(headFrame)
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundFrame)
        backgroundFrame.addSubview(mainImg)
        backgroundFrame.addSubview(mainTitleLbl)
        backgroundFrame.addSubview(divider)
        backgroundFrame.addSubview(contentsTitleLbl)
        backgroundFrame.addSubview(contentsFrame)
        contentsFrame.addSubview(contentsTextView)
        contentsFrame.addSubview(placeHolderLbl)
        backgroundFrame.addSubview(bottomBtn)
        
        headFrame.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(60)
        })
        scrollView.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        backgroundFrame.snp.makeConstraints({
            $0.top.equalTo(scrollView.snp.top)
            $0.leading.equalTo(scrollView.snp.leading)
            $0.trailing.equalTo(scrollView.snp.trailing)
            $0.bottom.equalTo(scrollView.snp.bottom)
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(676)
        })
        mainImg.snp.makeConstraints({
            $0.top.equalTo(backgroundFrame.snp.top).offset(20)
            $0.width.equalTo(80)
            $0.height.equalTo(70)
            $0.centerX.equalTo(backgroundFrame.snp.centerX)
        })
        mainTitleLbl.snp.makeConstraints({
            $0.top.equalTo(mainImg.snp.bottom).offset(14)
            $0.centerX.equalTo(backgroundFrame.snp.centerX)
        })
        divider.snp.makeConstraints({
            $0.top.equalTo(mainTitleLbl.snp.bottom).offset(24)
            $0.height.equalTo(1)
            $0.leading.equalTo(backgroundFrame.snp.leading).offset(16)
            $0.trailing.equalTo(backgroundFrame.snp.trailing).offset(-16)
        })
        contentsTitleLbl.snp.makeConstraints({
            $0.top.equalTo(divider.snp.bottom).offset(21)
            $0.leading.equalTo(backgroundFrame.snp.leading).offset(16)
        })
        contentsFrame.snp.makeConstraints({
            $0.top.equalTo(contentsTitleLbl.snp.bottom).offset(16)
            $0.leading.equalTo(backgroundFrame.snp.leading).offset(16)
            $0.trailing.equalTo(backgroundFrame.snp.trailing).offset(-16)
            $0.height.equalTo(248)
        })
        placeHolderLbl.snp.makeConstraints({
            $0.top.equalTo(contentsFrame.snp.top).offset(16)
            $0.centerX.equalTo(contentsFrame.snp.centerX)
        })
        contentsTextView.snp.makeConstraints({
            $0.top.equalTo(contentsFrame.snp.top).offset(10)
            $0.leading.equalTo(contentsFrame.snp.leading).offset(6)
            $0.trailing.equalTo(contentsFrame.snp.trailing).offset(-6)
            $0.bottom.equalTo(contentsFrame.snp.bottom).offset(-10)
        })
        bottomBtn.snp.makeConstraints({
            $0.height.equalTo(56)
            $0.top.equalTo(contentsFrame.snp.bottom).offset(88)
            $0.leading.equalTo(backgroundFrame.snp.leading).offset(24)
            $0.trailing.equalTo(backgroundFrame.snp.trailing).offset(-24)
        })
        
    }
    // MARK: - Bind
    override func bind() {
        
        contentsTextView.rx.text.subscribe(onNext: { st in
            if st?.count ?? 0 > 0 || st?.count == nil {
                self.placeHolderLbl.isHidden = true
                self.bottomBtn.backgroundColor = UIColor(asset: Asset.Color.priMain)
                self.bottomBtn.isUserInteractionEnabled = true
            } else {
                self.placeHolderLbl.isHidden = false
                self.bottomBtn.backgroundColor = UIColor(asset: Asset.Color.priLight018Dis)
                self.bottomBtn.isUserInteractionEnabled = false
            }
        }).disposed(by: disposedBag)
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: { height in
                self.backgroundFrame.snp.updateConstraints({
                    $0.height.equalTo(676 + height)
                })
            }).disposed(by: disposedBag)
        
        backBtn.rx.tap.bind {
            self.navigator.pop(sender: self)
        }.disposed(by: disposedBag)
        
        bottomBtn.rx.tap.bind {
            self.viewModel.requestCreateQuestion(context: self.contentsTextView.text ?? "")
            self.bottomBtn.isUserInteractionEnabled = false
        }.disposed(by: disposedBag)
        
        viewModel.requestQuestionSuccessOb.subscribe(onNext: { _ in
            CommonView.showToast(vc: self, message: "문의하기가 완료 되었습니다.", duration: 1.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1510)) {
                self.bottomBtn.isUserInteractionEnabled = true
                self.navigator.pop(sender: self)
            }
        }).disposed(by: disposedBag)
        
    }
    
}

extension ContactUsView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.placeHolderLbl.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if contentsTextView.text.count == 0 {
            self.placeHolderLbl.isHidden = false
        }
    }
    
}

extension ContactUsView {
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
}
