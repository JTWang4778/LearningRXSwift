//
//  SecondViewController.swift
//  RX
//
//  Created by 王锦涛 on 2017/8/31.
//  Copyright © 2017年 JTWang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SecondViewController: UIViewController {
    
    @IBOutlet var userNameField: UITextField!
    
    @IBOutlet var usernameTipLabel: UILabel!
    
    
    @IBOutlet var passwordTield: UITextField!
    
    @IBOutlet var passwordTipLabel: UILabel!

    @IBOutlet var buttton: UIButton!
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttton.isEnabled = false

        let usernameValidate = userNameField.rx.text.orEmpty.map{
            value -> Bool in
            print("usernameValidate")
            return value.characters.count >= 5 }.shareReplay(1)
        
        let passwordValidate = passwordTield.rx.text.orEmpty.map{ value in value.characters.count >= 5 }.shareReplay(1)
        
        usernameValidate.bind(to: usernameTipLabel.rx.isHidden).disposed(by: disposeBag)
        
        usernameValidate.bind(to: passwordTield.rx.isEnabled).disposed(by: disposeBag)
        
        passwordValidate.bind(to: passwordTipLabel.rx.isHidden).disposed(by: disposeBag)
        
        Observable.combineLatest(usernameValidate,passwordValidate){ v1, v2 -> Bool in  v1 && v2 }.shareReplay(1).bind(to: buttton.rx.isEnabled).disposed(by: disposeBag)
        
        
        
        buttton.rx.tap.subscribe(onNext: { [weak self] in self?.showAlert() }).disposed(by: disposeBag)
    }

    
    func showAlert() {
        let alertView = UIAlertView(
            title: "RxExample",
            message: "This is wonderful",
            delegate: nil,
            cancelButtonTitle: "OK"
        )
        
        alertView.show()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
