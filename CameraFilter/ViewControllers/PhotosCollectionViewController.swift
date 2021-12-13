//
//  PhotosCollectionViewController.swift
//  CameraFilter
//
//  Created by ASHWANI  SHAKYA on 30/11/21.
//

import UIKit
import Photos
import RxSwift

class PhotosCollectionViewController: UICollectionViewController{
    
    private let selectedPhotoSubject = PublishSubject<UIImage>()
    var selectedPhoto:Observable<UIImage> {
        return selectedPhotoSubject.asObserver()
    }
    
    private var images = [PHAsset]()
    override func viewDidLoad() {
        populatePhotos()
    }
    
    private func populatePhotos(){
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .authorized {
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: .none)
                assets.enumerateObjects { (object, count, stop) in
                    self?.images.append(object)
                }
                self?.images.reversed()

                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else { fatalError("PhotoCollectionViewCell is not found") }
        let asset = self.images[indexPath.row]
        let manager = PHImageManager.default()
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: nil) { image, _ in
            cell.imageView.image = image
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAsset = self.images[indexPath.row]
        PHImageManager.default().requestImage(for: selectedAsset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil) { image, info in
            guard let info = info else {
                return
            }
            let isDegradedImage = info["PHImageResultIsDegradedKey"] as! Bool
            
            if !isDegradedImage {
                if let image = image {
                    self.selectedPhotoSubject.onNext(image)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("viewDidDisappear")
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        print("dismiss")
    }
}


func instatiateVC(type:UIViewController.Type)->UIViewController{
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: String(describing: type.self))
}
