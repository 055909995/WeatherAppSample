//
//  Extesions.swift
//  WeatherApp
//
//  Created by Vardan Sargsyan on 26.04.21.
//

import Foundation
import UIKit

extension UIViewController {
    func showActivity(viewController : UIViewController){
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func hideActivity(viewController: UIViewController){
        viewController.presentedViewController?.dismiss(animated: true, completion: nil)
    }
}
