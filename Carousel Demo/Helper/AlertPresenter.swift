//
//  AlertPresenter.swift
//  CoupangPlayDemo
//
//  Created by Jeet Gandhi on 2/3/21.
//


import UIKit
import Combine

public protocol AlertPresenterType {
    func presentAlertViewController(alert: Error,
                                    presentingVC: UIViewController)
}

public class AlertPresenter: AlertPresenterType {
    
    private let router = Router()
    private let disposeBag = CancelBag()
    
    public init() {
    }
    
    public func presentAlertViewController(alert: Error,
                                           presentingVC: UIViewController) {
        let appError = alert as? AppError
        let alertViewController = UIAlertController(title: "Error",
                                                    message: appError?.rawValue ?? alert.localizedDescription,
                                                    preferredStyle: .alert)
        
        alertViewController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        
        
        presentingVC.tabBarController?.tabBar.isUserInteractionEnabled = false
        
        presentingVC.present(alertViewController, animated: true, completion: nil)
    }
    
}
