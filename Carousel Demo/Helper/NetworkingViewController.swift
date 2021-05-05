//
//  NetworkingViewController.swift
//  TrafficImages
//
//  Created by jeet_gandhi on 13/12/20.
//

import UIKit
import Combine

protocol CustomError : Error {
    var localizedDescription: String { get }
}

public enum AppError: String, CustomError {
   
    case unknown = "Unknown Error"
    case apiKeyError = "The request is missing a valid API key."
    case decodingError = "Failed to map data to a Decodable object."
    
    
}

enum RequestError : Int, CustomError {
    
    case unknown            = -5000
    case badRequest         = 400
    case loginFailed        = 401
    case userDisabled       = 403
    case notFound           = 404
    case methodNotAllowed   = 405
    case serverError        = 500
    case noConnection       = -1009
    case timeOutError       = -1001

}

public protocol ViewControllerProtocol {
    associatedtype ViewModelT
    var viewModel: ViewModelT! { get set }
}

public protocol NetworkingViewController: ViewControllerProtocol where Self: UIViewController, ViewModelT: NetworkingViewModel {
    var alertPresenter: AlertPresenterType { get }
    var cancelBag: CancelBag { get }
    var loadingSpinner: CustomRefreshControl { get }
    var mainCollectionView: UICollectionView! { get } 

    func setupNetworkingEventsUI()
    func setupLoadingSpinner()
}

extension NetworkingViewController {

    public func setupLoadingSpinner() {
        let screenFrame = UIScreen.main.bounds
        let screenHeight = screenFrame.height
        let screenWidth = screenFrame.width
        let height = (screenHeight/2) - 23
        let width = (screenWidth/2) - 23
        self.loadingSpinner.frame = CGRect(x: width, y: height, width: 46, height: 46)
        self.view.addSubview(self.loadingSpinner)
    }

    public func setupNetworkingEventsUI() {
                
        self.viewModel.events
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] event in
                guard let _self = self else { return }
                switch event.toNetworkEvent() {
                    case .waiting:
                        _self.loadingSpinner.beginRefreshing()
                    case .succeeded:
                        _self.loadingSpinner.endRefreshing()
                    case .failed(let error):
                        _self.loadingSpinner.endRefreshing()
                        _self.presentError(error: error)
                    case .none:
                        _self.loadingSpinner.endRefreshing()
                        _self.presentError(error: AppError.unknown)
                }
            })
            .cancel(with: cancelBag)
    }

    public func setupErrorDisplayEvent() {
        self.viewModel.events
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] event in
                guard let _self = self else { return }
                switch event.toNetworkEvent() {
                    case .failed(let error):
                        _self.presentError(error: error)
                    case .none:
                        _self.loadingSpinner.endRefreshing()
                        _self.presentError(error: AppError.unknown)
                        
                    default:
                        break
                }
            })
            .cancel(with: cancelBag)
    }

    func presentError(error: Error) {
        self.alertPresenter.presentAlertViewController(alert: error,
                                                       presentingVC: UIViewController.currentRootViewController)
    }

}

public class CustomRefreshControl: UIRefreshControl {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func beginRefreshing() {
        if let scrollView = superview as? UIScrollView {
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - (frame.height)), animated: true)
        }
        super.beginRefreshing()
    }
    
    public override func endRefreshing() {
        if let scrollView = superview as? UIScrollView {
            scrollView.setContentOffset(CGPoint.zero, animated: true)
        }
        super.endRefreshing()
    }
    
}
