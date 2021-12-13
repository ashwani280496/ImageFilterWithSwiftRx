//
//  FliterService.swift
//  CameraFilter
//
//  Created by ASHWANI  SHAKYA on 14/12/21.
//

import Foundation
import UIKit
import CoreImage
import RxSwift

class FilterService {
    private var context: CIContext
    
    init() {
        self.context = CIContext()
    }
    
   private func applyFilter(to inputImage:UIImage, completion: @escaping((UIImage)-> ())) {
        let filter = CIFilter(name: "CICMYKHalftone")
        filter?.setValue(5.0, forKey: kCIInputWidthKey)
        
        if let sourceImage = CIImage(image: inputImage) {
            filter?.setValue(sourceImage, forKey: kCIInputImageKey)
            
            if let cgImage = self.context.createCGImage((filter?.outputImage!)!, from: (filter?.outputImage!.extent)!) {
                let processedImage = UIImage(cgImage: cgImage, scale: inputImage.scale, orientation: inputImage.imageOrientation)
                completion(processedImage)
            }
        }
    }
    
    func applyFilter(to inputImage:UIImage) -> Observable<UIImage> {
        return Observable<UIImage>.create { observer in
            self.applyFilter(to: inputImage) { image in
                observer.onNext(image)
            }
            return Disposables.create()
        }
    }
}
