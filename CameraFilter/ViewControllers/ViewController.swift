//
//  ViewController.swift
//  CameraFilter
//
//  Created by ASHWANI  SHAKYA on 30/11/21.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    @IBOutlet weak var applyFilterButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Camera Filter"
    }


    @IBAction func ChoosePhoto(_ sender: Any) {
        let vc = instatiateVC(type: PhotosCollectionViewController.self) as! PhotosCollectionViewController
        vc.selectedPhoto.subscribe(onNext: { [self] image in
            updateUI(with: image)
        }).disposed(by: disposeBag)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func updateUI(with image: UIImage){
        self.imageView.image = image
        self.applyFilterButton.isHidden = false
    }
    
    @IBAction func applyFilter(_ sender: Any) {
        FilterService().applyFilter(to: self.imageView.image!) { image in
            self.imageView.image = image
        }
    }
}

