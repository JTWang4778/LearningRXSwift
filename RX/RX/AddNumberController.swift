//
//  AddNumberController.swift
//  RX
//
//  Created by 王锦涛 on 2017/8/31.
//  Copyright © 2017年 JTWang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddNumberController: UIViewController {
    
    @IBOutlet var first: UITextField!
    
    @IBOutlet var second: UITextField!

    @IBOutlet var result: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.gray
        
        
        
        Observable.combineLatest(first.rx.text.orEmpty,second.rx.text.orEmpty){
            value1, value2  -> Int in
            return (Int(value1) ?? 0) +  (Int(value2) ?? 0)
            }.map{ $0.description }.bind(to: result.rx.text).disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
