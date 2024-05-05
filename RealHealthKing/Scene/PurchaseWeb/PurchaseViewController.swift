//
//  PurchaseViewController.swift
//  RealHealthKing
//
//  Created by 김진수 on 5/5/24.
//

import UIKit
import iamport_ios
import WebKit
import RxSwift
import RxCocoa

class PurchaseViewController: BaseViewController<PurchaseView> {

    var payment: IamportPayment?
    let viewModel = PurchaseViewModel()
    let paymentResponse = PublishRelay<IamportResponse?>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.webView.navigationDelegate = self
        setWebView()
    }
    
    override func bind() {
        let input = PurchaseViewModel.Input(payment: paymentResponse.asObservable())
    }

}

extension PurchaseViewController {
    func setWebView() {
        if let paymentData = payment {
            Iamport.shared.paymentWebView(webViewMode: mainView.webView, userCode: APIKey.userCode.rawValue, payment: paymentData) { [weak self] iamportResponse in
                guard let self else { return }
                print(String(describing: iamportResponse))
                
                paymentResponse.accept(iamportResponse)
            }
        }
    }
}

extension PurchaseViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        mainView.indicator.isHidden = false
        mainView.indicator.startAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        mainView.indicator.stopAnimating()
        mainView.indicator.isHidden = true
        guard let title = webView.title else { return }
        navigationItem.title = title
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        mainView.indicator.stopAnimating()
        mainView.indicator.isHidden = true
    }
}
