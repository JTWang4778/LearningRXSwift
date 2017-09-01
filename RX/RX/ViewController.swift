//
//  ViewController.swift
//  RX
//
//  Created by 王锦涛 on 2017/8/29.
//  Copyright © 2017年 JTWang. All rights reserved.
//

import UIKit
import RxSwift
extension ObservableType {
    
    /**
     Add observer with `id` and print each emitted event.
     - parameter id: an identifier for the subscription.
     */
    func addObserver(_ id: String) -> Disposable {
        return subscribe { print("Subscription:", id, "Event:", $0) }
    }
    
}

class ViewController: UIViewController {

    @IBOutlet var first: UITextField!
    
    @IBOutlet var second: UITextField!
    
    @IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
//        creatAndSubscribe()
        
//        subjectTest()
        
//        combinationOperators()
        
//        transformOperatorsTest()
        
//        fliterAndConditionalOperators()
        
//        mathematicalAndAggregateOperators()
    }
    
    // 数学和聚合操作符
    func mathematicalAndAggregateOperators() {
        
        // toArray  聚合一个信号源发出的所有信号  成一个信号  发出后立即完成结束
        let disposeBag = DisposeBag()
        Observable.of(1,2,3,4,5,6,7,8).toArray().subscribe{ print($0) }.disposed(by: disposeBag)
        
        // reduce  从一开始抑制源信号  对每一个元素应用闭包 直到源信号完成 将结果聚合成一个元素发送信号
        Observable.of(10,100,1000).reduce(1, accumulator: {
            sum , add in
            sum + add
        }).subscribe( { print($0) } ).disposed(by: disposeBag)
        
        // 省略形式
        Observable.of(10,100,1000).reduce(1, accumulator: + ).subscribe( { print($0) } ).disposed(by: disposeBag)
        
        
        
        // 
        print("-=-=-=-=-=concat-=-=-=-=-=-")
        let subject1 = BehaviorSubject(value: "🍎")
        let subject2 = BehaviorSubject(value: "🐶")
        
        let variable = Variable(subject1)
        
        variable.asObservable()
            .concat()
            .subscribe { print($0) }
            .disposed(by: disposeBag)
        
        subject1.onNext("🍐")
        subject1.onNext("🍊")
        
        variable.value = subject2
        
        subject2.onNext("I would be ignored")
        subject2.onNext("🐱")
        subject2.onNext("❤️")
//
        subject1.onCompleted()
//
        subject2.onNext("🐭")
        
    }
    
    func fliterAndConditionalOperators() {
        
        // fliter  从源序列中 有选择的发送满足条件的信号
        let disposeBag = DisposeBag()
        Observable.of("🐴","🐱","🐂","🐶","🐱","🐟","🐱","","❤️").filter{ $0 == "🐱" }.subscribe(onNext: { print($0) }).disposed(by: disposeBag)
        
        //  distinctUntilChanged  抑制可观察序列的顺序重复元素  只有当前信号和之前的信号不一样的时候才发送
        print("-=-=-=-=-=distinctUntilChanged-=-=-=-=-=-=")
        Observable.of("🐴","🐱","🐱","🐱","🐂","🐶","🐶","🐱","🐟","🐟","🐱","❤️","❤️").distinctUntilChanged().subscribe(onNext: { print($0) }).disposed(by: disposeBag)
        
        // elementAt  发送指定索引位置的元素  从0开始
        print("-=-=-=-=-=elementAt-=-=-=-=-=-=")
         Observable.of("🐴","🐱","🐂","🐶","🐱","🐟","🐱","","❤️").elementAt(3).subscribe(onNext: { print($0) }).disposed(by: disposeBag)
        
        //single  只发出序列的第一个或者 第一个满足条件的元素，  如果没有发出一个信号 会报错错误
        print("-=-=-=-=-=single-=-=-=-=-=-=")
        // 第一个元素
        Observable.of("🐴","🐱","🐂","🐶","🐱","🐟","🐱","","❤️").single().subscribe(onNext: { print($0) }).disposed(by: disposeBag)
        
        
        // 第一个满足条件的
        Observable.of("🐴","🐱","🐂","🐶","🐱","🐟","🐱","","❤️").single{  $0 == "🐶" }.subscribe(onNext: { print($0) }).disposed(by: disposeBag)
        
        
        // take  发送从开始位置的指定个数的信号
        print("-=-=-=-=-=take-=-=-=-=-=-=")
        Observable.of("🐴","🐱","🐂","🐶","🐱","🐟","🐱","","❤️").take(3).subscribe(onNext: { print($0) }).disposed(by: disposeBag)
        
        Observable.of("🐴","🐱","🐂","🐶","🐱","🐟","🐱","❤️").takeLast(4).subscribe(onNext: { print($0) }).disposed(by: disposeBag)
        
        // takeWhile  从头开始  当条件不成立的时候  结束
        print("-=-=-=-=-=takeWhile-=-=-=-=-=-=")
        Observable.of("🐴","🐱","🐂","🐶","🐱","🐟","🐱","❤️").takeWhile({ $0 !=  "🐟"}).subscribe(onNext: { print($0) }).disposed(by: disposeBag)
        
        //takeUntil   从源序列发信号  直到引用序列开始发信号 源序列结束
        print("-=-=-=-=-=takeUntil-=-=-=-=-=-=")
        let sourceSequence = PublishSubject<String>()
        let referenceSequence = PublishSubject<String>()
        sourceSequence.takeUntil(referenceSequence).subscribe(onNext: { print($0) }).addDisposableTo(disposeBag)
        sourceSequence.onNext("🐂")
        sourceSequence.onNext("🐟")
        referenceSequence.onNext("end")
        sourceSequence.onNext("❤️")
        
        
        // skip 从序列头部开始  抑制指定数量的信号不发送
        print("-=-=-=-=-=skip-=-=-=-=-=-=")
        Observable.of("🐴","🐱","🐂","🐶","🐱","🐟","🐱","❤️").skip(4).subscribe({ print($0) }).disposed(by: disposeBag)
        
        // skipWhile 从序列头部开始  抑制满足条件的信号不发送
        print("-=-=-=-=-=skipWhile-=-=-=-=-=-=")
        Observable.of(1,2,3,4,5,6,7).skipWhile({ $0 < 4 }).subscribe({ print($0) }).disposed(by: disposeBag)
        
        
        // skipWhileWithIndex 从序列头部开始  抑制满足条件的信号不发送
        print("-=-=-=-=-=skipWhileWithIndex-=-=-=-=-=-=")
        Observable.of("🐴","🐱","🐂","🐶","🐱","🐟","🐱","❤️").skipWhileWithIndex({
            element , index in
            index < 3
        }).subscribe({ print($0) }).disposed(by: disposeBag)
        
        
        //skipUntil  抑制源序列  直到引用序列开始发信号  源序列开始正常发信号
        print("-=-=-=-=-=skipUntil-=-=-=-=-=-=")
        let source = PublishSubject<String>()
        let reference = PublishSubject<String>()
        source.skipUntil(reference).subscribe(onNext: { print($0) }).disposed(by: disposeBag)
        
        source.onNext("🐟")
//        source.onNext("🐂")
//        source.onNext("🐱")
        reference.onNext("❤️")
        source.onNext("🐶")
        source.onNext("🐂")
        source.onNext("🐱")
        
        
    }
    
    
    // 转换操作符
    func transformOperatorsTest() {
        
        // map   对于每一个信号  应用闭包  返回一个新的信号
        let disposeBag = DisposeBag()
        Observable.of(1,2,3,4).map({ $0 * $0 }).subscribe(onNext: { print($0) }).disposed(by: disposeBag)
        
        // flatMap
        print("=-=-=-=-=-=-=-flatMap=-=-=-=-=-=-=-")
        struct Player {
            var score: Variable<Int>
        }
        
        let 👦🏻 = Player(score: Variable(80))
        let 👧🏼 = Player(score: Variable(90))
        
        let player = Variable(👦🏻)
        
        player.asObservable()
            .flatMapLatest { $0.score.asObservable() } // Change flatMap to flatMapLatest and observe change in printed output
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        👦🏻.score.value = 85
        
        player.value = 👧🏼
//
        👦🏻.score.value = 95 // 使用flatMap的时候  即使重新赋值  原来的信号改变的时候  还是会打印出来  当使用flatMapLatest  就不会了
//
        👧🏼.score.value = 100
        
        // scan  从初始值开始  将累加闭包应用于每一个元素 并将每一个中间结果返回
        print("=-=-=-=-=-=-=-scan=-=-=-=-=-=-=-")
        Observable.of(10,100,1000).scan(1){
            sum, add  in
            sum + add}.subscribe(onNext: {  print($0) }).disposed(by: disposeBag)
        Observable.of(10,100,1000).scan(1, accumulator: { sum, add  in  sum + add }).subscribe(onNext: {  print($0) }).disposed(by: disposeBag)
        
    }
    
    // 组合操作符 组合信号 产生新的信号
    func combinationOperators() {
        
        // startWith 在Observable发送之前 发送执行的信号
        print("-=-=-=-=-=-=-startWith=-=-=-=--=-=-=-==")
        let disposeBag = DisposeBag()
        Observable.of("🐶","🐱","🦍").startWith("❤️").startWith("🅰️").startWith("3️⃣","2️⃣","2️⃣").subscribe{
            print($0)
        }.disposed(by: disposeBag)
        
        
        //merge   合并多个信号为一个  并且按照各个信号参数信号的时间 发送合并信号
        print("-=-=-=-=-=-=-merge=-=-=-=--=-=-=-==")
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()
        Observable.of(subject1,subject2).merge().subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
        
        subject1.onNext("🐶")
        subject1.onNext("🐱")
        subject2.onNext("2️⃣")
        subject1.onNext("3️⃣")
        subject2.onNext("🅰️")
        
        
        // zip  压缩至多8个信号 为一个新的信号，只有对应位置的信号都有的时候  才会发送压缩后的信号
        print("-=-=-=-=-=-=-zip=-=-=-=--=-=-=-==")
        let stringSubject = PublishSubject<String>()
        let intSubject = PublishSubject<Int>()
        Observable.zip(stringSubject,intSubject) {
            stringElement, intElement in
              "\(stringSubject) \(intElement)"
            }.subscribe{ print($0) }.disposed(by: disposeBag)
        intSubject.onNext(1)
        stringSubject.onNext("❤️")
        intSubject.onNext(2)
        intSubject.onNext(3)
        stringSubject.onNext("🥒")
        
        //  combineLatest 结合至多8个信号 为一个新的信号，只有至少有一个信号 或者有新信号来的时候 会结合最新的信号
        print("-=-=-=-=-=-=-combineLatest=-=-=-=--=-=-=-==")
        Observable.combineLatest(stringSubject,intSubject){
            stringElement, intElement in
            "\(stringSubject) \(intElement)"
            }.subscribe(onNext: {  print($0) }).disposed(by: disposeBag)
        
        stringSubject.onNext("first")
        intSubject.onNext(5)
        
        
        // 结合最新信号的另外一种方式
        let stringObservable = Observable.just("❤️")
        let fruitObservable = Observable.from(["🍎", "🍐", "🍊"])
        let animalObservable = Observable.of("🐶", "🐱", "🐭", "🐹")
        Observable.combineLatest(stringObservable,fruitObservable,animalObservable){
            string, frult , animal in
            "\(string) | \(frult) | \(animal)"
            }.subscribe(onNext: { print($0) }).disposed(by: disposeBag)
        
        
        print("-=-=-=-=-=-=-switchLatest=-=-=-=--=-=-=-==")
        let subject11 = BehaviorSubject(value: "⚽️")
        let subject22 = BehaviorSubject(value: "🍎")
        
        let variable = Variable(subject11)
    
        variable.asObservable().switchLatest().subscribe(onNext: { print($0) } ).disposed(by: disposeBag)
        
        subject11.onNext("🐶")
        subject22.onNext("🐱")
        variable.value = subject22
        subject11.onNext("🐂")
        
        
        
        
    }
    
    func subjectTest() {
        
        //  PublishSubject   消息主体   在订阅者订阅的时间内   广播信号给所有的订阅者
        let disposeBag = DisposeBag()
        let subject = PublishSubject<String>()
        subject.addObserver("1").disposed(by: disposeBag)
        subject.onNext("🐶")
        subject.onNext("🐱")
        subject.onNext("🦍")
        subject.addObserver("2").disposed(by: disposeBag)
        subject.onNext("❤️")
        subject.onNext("🐂")
        
        
       // ReplaySubject 向所有订阅者广播新信号，并且向订阅者广播指定数量的历史信号
        print("-=-=-=-=-=-=-ReplaySubject=-=-=-=-=-=-=-=-=-")
        let replaySubject = ReplaySubject<String>.create(bufferSize: 1)
        replaySubject.addObserver("1").disposed(by: disposeBag)
        replaySubject.onNext("🐶")
        replaySubject.onNext("🐱")
        replaySubject.onNext("🦍")
        replaySubject.addObserver("2").disposed(by: disposeBag)
        replaySubject.onNext("❤️")
        replaySubject.onNext("🐂")
        replaySubject.addObserver("3").disposed(by: disposeBag)
        
        
        
        
       // BehaviorSubject 向所有订阅者广播新信号 并 向新订阅者提供最新（或初始）值
        print("-=-=-=-=-=-=-BehaviorSubject=-=-=-=-=-=-=-=-=-")
        let behaviorSubject = BehaviorSubject(value: "🌞")
        behaviorSubject.addObserver("1").disposed(by: disposeBag)
        behaviorSubject.onNext("🐶")
        behaviorSubject.onNext("🐱")
        behaviorSubject.onNext("🦍")
        behaviorSubject.addObserver("2").disposed(by: disposeBag)
        behaviorSubject.onNext("❤️")
        behaviorSubject.onNext("🐂")
        
        
        // 注意  上述几个主体 并没有发出  complete信号
    
        //  Variable 包装一个BehaviorSubject， 所以Variable 会向所有新的订阅者发送最新（或者初始）信号，Variable会保持当前值状态，但是永远不会发出error事件 ，但是会在deinit的时候  发送complete信号
        print("-=-=-=-=-=-=-Variable=-=-=-=-=-=-=-=-=-")
        let variable = Variable.init("❤️")
        variable.asObservable().addObserver("1").disposed(by: disposeBag)
        variable.value = "🐶"  //Variable 不是使用on操作
        variable.value = "🐱"
        variable.asObservable().addObserver("2").disposed(by: disposeBag)
        variable.value = "🐂"
        
        
    }
    
    func creatAndSubscribe() {
        // never    不会终止 不会发任何事件
        let disposeBag = DisposeBag()
//        let neverSequence = Observable<String>.never()
//        let neverSequenceSubscription = neverSequence.subscribe{
//            _ in
//            print("will never asdf")
//        }
//        neverSequenceSubscription.disposed(by: disposeBag)
        
        
        // empty   只发一个完成事件
//        let _ = Observable<String>.empty().subscribe{
//            event in
//            print(event)
//        }.disposed(by: disposeBag)
        
        // just   只会发一次信号  然后就完成了
        let _ = Observable.just("just once").subscribe{
            event in
            print(event)
        }.disposed(by: disposeBag)
        
        
        Observable.of("🐶","🐱","❤️").subscribe{
            event in
            print(event)
        }.disposed(by: disposeBag)
        
        
        Observable.from(["🐶","🐱","❤️","🐘","🐼"])
            .subscribe(onNext: { element in
                print(element)
            })
            .disposed(by: disposeBag)
        
        
        // create
        let myJust = {
            (element : String) -> Observable<String> in
            return Observable.create{
                observe in
                observe.on(.next(element))
                observe.on(.completed)
                return Disposables.create()
            }
        }
        
        myJust("❤️").subscribe{
            print($0)
        }.disposed(by: disposeBag)
        
        
        // range
        Observable.repeatElement("🐶").take(6).subscribe(onNext: {
            event in
            print(event)
        }, onError: nil, onCompleted: nil, onDisposed: nil).dispose()
        
        // 另外一种写法 如果不指定次数  会一直重复
        Observable.repeatElement("🙄").take(8).subscribe(onNext:{
            print($0)
        }).disposed(by: disposeBag)
        
        
        // generate  创建信号  只要条件成立
        Observable.generate(initialState: 0, condition: {
             $0 < 3
        }, iterate: { $0 + 1 }).subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
        
        // 
        
        
//       deferred   对于每一个订阅 产生一个新的信号
        var count = 1
        
        let deferredSequence = Observable<String>.deferred {
            print("Creating \(count)")
            count += 1
            
            return Observable.create { observer in
                print("Emitting...")
                observer.onNext("🐶")
                observer.onNext("🐱")
                observer.onNext("🐵")
                return Disposables.create()
            }
        }
        
        deferredSequence
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        deferredSequence
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        
        
        // error  创建一个信号 不会发送任何事件  立即结束
        
        // doOn  为每一个发出的事件调用一次副作用操作  返回原始信号
        Observable.of("🍉","🍌","🍎","梨").do(onNext: { print("asdf \($0)") }, onError: { print("on error \($0)") }, onCompleted: { print(" comlete \($0) ") }).subscribe{
            print("$0")
        }.disposed(by: disposeBag)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

