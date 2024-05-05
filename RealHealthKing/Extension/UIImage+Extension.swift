//
//  UIImage+Extension.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/21/24.
//

import UIKit
import Kingfisher
import KeychainSwift

extension UIImage {
    
    func resizeWithWidth(width: CGFloat) -> UIImage? {
            let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
            imageView.contentMode = .scaleAspectFit
            imageView.image = self
            UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            imageView.layer.render(in: context)
            guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
            UIGraphicsEndImageContext()
            return result
        }
    
}

extension UIImageView {
    
    func downloadImage(imageUrl: String) {
        
        guard let url = URL(string: imageUrl), let scale = UIScreen.current?.scale else { return }
        
        //        let processor = DownsamplingImageProcessor(size: CGSize(width: width, height: height))
        
        let imageDownloadRequest = AnyModifier { request in
            var requestBody = request
            requestBody.setValue(KeyChainManager.shared.accessToken, forHTTPHeaderField: HTTPHeader.authorization.rawValue)
            requestBody.setValue(APIKey.secretKey.rawValue, forHTTPHeaderField: HTTPHeader.sesacKey.rawValue)
            return requestBody
        }
        
        KingfisherManager.shared.retrieveImage(with: url, options: [
            //            .processor(processor),
            .requestModifier(imageDownloadRequest),
            .scaleFactor(scale),
        ]) { imageResult in
            switch imageResult {
            case .success(let result):
                self.image = result.image
            case .failure(let error):
                print(error)
            }
        }
    }
}
