//
//  ViewController.swift
//  CameraFilter
//
//  Created by ASHWANI  SHAKYA on 30/11/21.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Camera Filter"
    }


    @IBAction func ChoosePhoto(_ sender: Any) {
        let vc = instatiateVC(type: PhotosCollectionViewController.self) as! PhotosCollectionViewController
        vc.selectedPhoto.subscribe(onNext: { image in
            self.imageView.image = image
        }).disposed(by: disposeBag)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func applyFilter(_ sender: Any) {
    }
}

