//
//  ViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import RxSwift
import UIKit

class ViewController: UITableViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func exJust1() {
        Observable.just("Hello World")                              // Observable<String>
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exJust2() {
        Observable.just(["Hello", "World"])                         // Observable<String>
            .subscribe(onNext: { arr in
                print(arr)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exFrom1() {
        Observable.from(["RxSwift", "In", "4", "Hours"])            // Observable<String>
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exMap1() {
        Observable.just("Hello")                                    // Observable<String>
            .map { "\($0) RxSwift" }                                // Observable<String>
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exMap2() {
        Observable.from(["with", "곰튀김"])                           // Observable<String>
            .map { $0.count }                                       // Observable<Int>
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exFilter() {
        Observable.from([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])            // Observable<Int>
            .filter { $0 % 2 == 0 }                                 // Observable<Int>
            .single()                                               // single 은 스트림이 한번만 발생해야하나 여러번 발생해서 에러가 발생
            .subscribe(onNext: { n in
                print("success: \(n)")
            }, onError: { (error) in
                print("error: \(error.localizedDescription)")
            }, onCompleted: {
                print("completed")
            }, onDisposed: {
                print("disposed")
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exMap3() {
        Observable.just("800x600")                                  // Observable<String> -> "800x600"
            .map { $0.replacingOccurrences(of: "x", with: "/") }    // Observable<String> -> "800/600"
            .map { "https://picsum.photos/\($0)/?random" }          // Observable<String> -> "https://picsum.photos/800/600/?random"
            .map { URL(string: $0) }                                // Observable<URL?> -> URL(https://picsum.photos/800/600/?random)
            .filter { $0 != nil }                                   // Observable<URL?>
            .map { $0! }                                            // Observable<URL>
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .utility))
            .map { try Data(contentsOf: $0) }                       // Observable<Data>
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .map { UIImage(data: $0) }                              // Observable<UIImage?>
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { image in
                self.imageView.image = image
            })
            .disposed(by: disposeBag)
    }
}
