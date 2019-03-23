//
//  RxSwiftViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import RxSwift
import UIKit

class RxSwiftViewController: UIViewController {
    // MARK: - Field

    var counter: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.counter += 1
            self.countLabel.text = "\(self.counter)"
        }
    }

    var disposeBag: DisposeBag = DisposeBag()

    // MARK: - IBOutlet

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var countLabel: UILabel!

    // MARK: - IBAction

    @IBAction func onLoadImage(_ sender: Any) {
        imageView.image = nil
        
        // Thread > Operation > GCD > Scheduler

         rxswiftLoadImage(from: LARGER_IMAGE_URL)
            // obsereOn 은 사용한 직후 다음줄로부터, subscribOn 은 시작을 해당 스케쥴러 부터
            .observeOn(MainScheduler.instance)
            // subscribe : 나중에_오면
            .subscribe({ result in
                switch result {
                case let .next(image):
                    self.imageView.image = image

                case let .error(err):
                    print(err.localizedDescription)

                case .completed:
                    break
                }
            }).disposed(by: disposeBag)
    }

    @IBAction func onCancel(_ sender: Any) {
        // 일부러 disposeBag 에 있는 것들을 dispose 할 때는 재생성
        disposeBag = DisposeBag()
    }

    // MARK: - RxSwift

    func rxswiftLoadImage(from imageUrl: String) -> Observable<UIImage?> {
        // Observable : 나중에_줄게
//        Observable<String>.create { (observer) -> Disposable in
//            // observable 에 제공해줄 수 있는 데이터는 3가지
//            // Next
//            observer.onNext("A")
//            observer.onNext("B")
//            observer.onNext("C")
//            observer.onNext("D")
//
//            // Completed
//            observer.onCompleted()
//
//            // Error
//            observer.onError(NSError())
//
//            return Disposables.create()
//        }
        
        return Observable.create { observer in
            guard let url = URL(string: imageUrl) else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if let error = error {
                    observer.onError(error)
                }
                
                if let data = data {
                    let image = UIImage(data: data)
                    observer.onNext(image)
                }
                
                observer.onCompleted()
            })
            
            task.resume()
            
            return Disposables.create {
                // 새로 생성 된 disposable 이 dispose 될 때 실행할 클로져
                task.cancel()
            }
        }
    }
}
