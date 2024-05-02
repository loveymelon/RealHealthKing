//
//  UIView+Extension.swift
//  RealHealthKing
//
//  Created by 김진수 on 4/22/24.
//

import UIKit

extension UIView: ReusableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIView {
    func updateImageViews(scrollView: UIScrollView, pageControl: UIPageControl, postData: [String], width: CGFloat) {
        
        for num in 0..<postData.count {
            let imageView = UIImageView()
            let postionX = width * CGFloat(num)
            
            let width = width
            let height = scrollView.bounds.height
 
            imageView.frame = CGRect(x: postionX, y: 0, width: width, height: height)
            
            let url = APIKey.baseURL.rawValue + NetworkVersion.version.rawValue + "/" + postData[num]
            
            imageView.downloadImage(imageUrl: url)
            
            scrollView.addSubview(imageView)
            
            scrollView.contentSize.width = width * CGFloat(1+num) // scrollView의 넓이 설정
        }
        
        pageControl.numberOfPages = postData.count
        
    }
}
