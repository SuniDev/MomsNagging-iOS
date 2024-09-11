//
//  BasePageViewController.swift
//  momsnagging
//
//  Created by suni on 9/12/24.
//

import Foundation

import RxSwift
import RxCocoa
import RxFlow
/**
 # (C) BasePageViewController
 - Authors: suni
 - Note: 모든 PageVC의 Base, 모든 PageViewController의 기본 기능 정의.
 */
class BasePageViewController: UIPageViewController, Stepper {
    let steps = PublishRelay<Step>()
    
    lazy private(set) var className: String = {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()
    
    deinit {
        Log.info("DEINIT: \(self.className)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUI()
        self.initLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true)
   }
    
    /**
     # initUI
     - Authors: suni
     - Note: UI 초기 설정하는 Override용 함수
     */
    func initUI() { }
    
    /**
     # initLayout
     - Authors: suni
     - Note: layout 관련 설정하는 Override용 함수
     */
    func initLayout() { }
    
    /**
     # reloadData
     - Authors: suni
     - Note: reload할 데이터를 설정하는 Override용 함수
     */
    func reloadData() { }
}

extension Reactive where Base: UIPageViewController {

    // Delegate proxy 제공
    var delegate: DelegateProxy<UIPageViewController, UIPageViewControllerDelegate> {
        return RxPageViewControllerDelegateProxy.proxy(for: base)
    }

    // willTransitionTo 이벤트를 Observable로 노출
    var willTransitionTo: Observable<[UIViewController]> {
        return delegate
            .methodInvoked(#selector(UIPageViewControllerDelegate.pageViewController(_:willTransitionTo:)))
            .compactMap { parameters in
                guard let viewControllers = parameters[1] as? [UIViewController] else {
                    return nil
                }
                return viewControllers
            }
    }

    // didFinishAnimating 이벤트를 Observable로 노출
    var didFinishAnimating: Observable<(finished: Bool, previousViewControllers: [UIViewController], completed: Bool)> {
        return delegate
            .methodInvoked(#selector(UIPageViewControllerDelegate.pageViewController(_:didFinishAnimating:previousViewControllers:transitionCompleted:)))
            .compactMap { parameters in
                guard let finished = parameters[1] as? Bool,
                      let previousViewControllers = parameters[2] as? [UIViewController],
                      let completed = parameters[3] as? Bool else {
                    return nil
                }
                return (finished, previousViewControllers, completed)
            }
    }
}
