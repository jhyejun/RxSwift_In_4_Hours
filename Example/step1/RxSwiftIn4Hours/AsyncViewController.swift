//
//  ViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import UIKit

class AsyncViewController: UIViewController {
    // MARK: - Field

    var counter: Int = 0
    let IMAGE_URL = "https://picsum.photos/1280/720/?random"

    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.counter += 1
            self.countLabel.text = "\(self.counter)"
        }
    }

    // MARK: - IBOutlet

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var countLabel: UILabel!

    // MARK: - IBAction

    @IBAction func onLoadSync(_ sender: Any) {
        let image = loadImage(from: IMAGE_URL)
        imageView.image = image
    }

    @IBAction func onLoadAsync(_ sender: Any) {
        loadImageAsync1(from: IMAGE_URL) {
            self.imageView.image = $0
        }
        
        // loadImageAsync3(from: IMAGE_URL) { (나중에_오면<UIImage>) }
    }

    private func loadImage(from imageUrl: String) -> UIImage? {
        guard let url = URL(string: imageUrl) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }

        let image = UIImage(data: data)
        return image
    }
    
    // 리턴하는 방법 1 (callBack 함수)
    private func loadImageAsync1(from imageUrl: String, callBack: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            let image = self.loadImage(from: self.IMAGE_URL)
            DispatchQueue.main.async {
                callBack(image)
            }
        }
    }
    
    // 리턴하는 방법 2 (delegate 사용)
    private func loadImageAsync2(from imageUrl: String) {
        DispatchQueue.global(qos: .userInteractive).async {
            let image = self.loadImage(from: self.IMAGE_URL)
            // delegate.setImage
        }
    }
    
    // 리턴하는 방법 3
    // Reactive Programming (나중에 생기는 애를 나중에 줄게)
    // private func loadImageAsync3(from imageUrl: String) -> 나중에_줄게<UIImage> { }
}
