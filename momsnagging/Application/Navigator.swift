//
//  Navigator.swift
//  momsnagging
//
//  Created by suni on 2022/03/28.
//

import Foundation
import UIKit

protocol Navigatable {
    var navigator: Navigator! { get set }
}

class Navigator {
    static var `default` = Navigator()
    
    var root: UIViewController {
        return self.rootViewController
    }
    
    private lazy var rootViewController: BaseNavigationController = {
        let viewController = BaseNavigationController()
        viewController.setNavigationBarHidden(true, animated: false)
        return viewController
    }()
    
    // MARK: - all app scenes
    enum Scene {
        case intro(viewModel: IntroViewModel)
        case onboarding(viewModel: OnboardingViewModel)
        case login(viewModel: LoginViewModel)
        case idSetting(viewModel: IDSettingViewModel)
        case nicknameSetting(viewModel: NicknameSettingViewModel)
        case mainContainer(viewModel: MainContainerViewModel)
        case home(viewModel: HomeViewModel)
        case calendar(viewModel: CalendarViewModel)
        case diary(viewModel: DiaryViewModel)
        case detailDiary(viewModel: DetailDiaryViewModel)
        case addHabit(viewModel: AddHabitViewModel)
        case detailHabit(viewModel: DetailHabitViewModel)
        case performTimeSetting(viewModel: PerformTimeSettingViewModel)
        case detailTodo(viewModel: DetailTodoViewModel)
        case recommendedHabit(viewModel: RecommendedHabitViewModel)
        case reportCard(viewModel: ReportCardViewModel)
        case awardViewModel(viewModel: AwardViewModel)
        case my(viewModel: MyViewModel)
        case setting(viewModel: SettingViewModel)
        case privacyPolicy(viewModel: PrivacyPolicyViewModel)
        case deleteAccount(viewModel: DeleteAccountViewModel)
        case contactUs(viewModel: ContactUsViewModel)
        case pushSetting(viewModel: PushSettingViewModel)
    }
    
    enum Transition {
        case root
        case navigation
        case modal
        case popup
        case alert
        case custom
    }
    
    // MARK: - get a single viewcontroller
    func get(seque: Scene) -> UIViewController? {
        switch seque {
        case .intro(let viewModel): return IntroView(viewModel: viewModel, navigator: self)
        case .onboarding(let viewModel): return OnboardingView(viewModel: viewModel, navigator: self)
        case .login(let viewModel): return LoginView(viewModel: viewModel, navigator: self)
        case .idSetting(let viewModel): return IDSettingView(viewModel: viewModel, navigator: self)
        case .nicknameSetting(let viewModel): return NicknameSettingView(viewModel: viewModel, navigator: self)
        case .mainContainer(viewModel: let viewModel): return MainContainerView(viewModel: viewModel, navigator: self)
        case .home(viewModel: let viewModel): return HomeView(viewModel: viewModel, navigator: self)
        case .calendar(viewModel: let viewModel): return CalendarView(viewModel: viewModel, navigator: self)
        case .diary(viewModel: let viewModel): return DiaryView(viewModel: viewModel, navigator: self)
        case .detailDiary(viewModel: let viewModel): return DetailDiaryView(viewModel: viewModel, navigator: self)
        case .addHabit(viewModel: let viewModel): return AddHabitView(viewModel: viewModel, navigator: self)
        case .detailHabit(viewModel: let viewModel): return DetailHabitView(viewModel: viewModel, navigator: self)
        case .performTimeSetting(viewModel: let viewModel): return PerformTimeSettingView(viewModel: viewModel, navigator: self)
        case .detailTodo(viewModel: let viewModel): return DetailTodoView(viewModel: viewModel, navigator: self)
        case .recommendedHabit(viewModel: let viewModel): return RecommendedHabitView(viewModel: viewModel, navigator: self)
        case .reportCard(viewModel: let viewModel): return ReportCardView(viewModel: viewModel, navigator: self)
        case .awardViewModel(viewModel: let viewModel): return AwardView(viewModel: viewModel, navigator: self)
        case .my(viewModel: let viewModel): return MyView(viewModel: viewModel, navigator: self)
        case .setting(viewModel: let viewModel): return SettingView(viewModel: viewModel, navigator: self)
        case .privacyPolicy(viewModel: let viewModel): return PrivacyPolicyView(viewModel: viewModel, navigator: self)
        case .deleteAccount(viewModel: let viewModel): return DeleteAccountView(viewModel: viewModel, navigator: self)
        case .contactUs(viewModel: let viewModel): return ContactUsView(viewModel: viewModel, navigator: self)
        case .pushSetting(viewModel: let viewModel): return PushSettingView(viewModel: viewModel, navigator: self)
        }
    }
    
    func pop(sender: UIViewController?, toRoot: Bool = false) {
        if toRoot {
            sender?.navigationController?.popToRootViewController(animated: true)
        } else {
            sender?.navigationController?.popViewController(animated: true)
        }
    }

    func dismiss(sender: UIViewController?) {
        sender?.navigationController?.dismiss(animated: true, completion: nil)
    }

    // MARK: - invoke a single segue
    func show(seque: Scene, sender: UIViewController?, transition: Transition = .navigation) {
        if let target = get(seque: seque) {
            show(target: target, sender: sender, transition: transition)
        }
    }
    
    private func show(target: UIViewController, sender: UIViewController?, transition: Transition) {
        switch transition {
        case .root:
            rootViewController.setViewControllers([target], animated: false)
            return
        case .custom:
            return
        default: break
        }
        
        guard let sender = sender else {
            fatalError()
        }
        
        switch transition {
        case .navigation:
            rootViewController.pushViewController(target, animated: true)
        case .modal:
            DispatchQueue.main.async {
                sender.present(target, animated: true)
            }
        case .popup:
            // TODO: - popup 처리
            return
        case .alert:
            DispatchQueue.main.async {
                sender.present(target, animated: true, completion: nil)
            }
            return
        default: break
        }
    }
}
