//
//  ViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    let relay = PublishRelay<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
        
        relay.accept("TEST")
    }

    // MARK: - IBOutler

    @IBOutlet var idField: UITextField!
    @IBOutlet var pwField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var idValidView: UIView!
    @IBOutlet var pwValidView: UIView!

    // MARK: - Bind UI

    private func bindUI() {
        // id input +--> check valid --> bullet
        //          |
        //          +--> button enable
        //          |
        // pw input +--> check valid --> bullet
        
        let isValidEmail = idField.rx.text.orEmpty.map(checkEmailValid)
        let isValidPw = pwField.rx.text.orEmpty.map(checkPasswordValid)
        
        isValidEmail
            .bind(to: idValidView.rx.isHidden)
            .disposed(by: disposeBag)
        
        isValidPw
            .bind(to: pwValidView.rx.isHidden)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(isValidEmail, isValidPw) { $0 && $1 }
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { (result) in
                self.loginButton.rx.isEnabled
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Logic

    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }

    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count > 5
    }
}
