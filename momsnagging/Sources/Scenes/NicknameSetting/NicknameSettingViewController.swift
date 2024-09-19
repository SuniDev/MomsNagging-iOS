//
//  NicknameSettingViewController.swift
//  momsnagging
//
//  Created by suni on 9/24/24.
//

import UIKit

import SnapKit
import Then
import RxViewController
import ReactorKit

class NicknameSettingViewController: BaseViewController {

    // MARK: - Properties & Variable
    var disposeBag = DisposeBag()
    
    // MARK: - UI Properties
    
    // MARK: - Init
    init(with reactor: IntroReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
