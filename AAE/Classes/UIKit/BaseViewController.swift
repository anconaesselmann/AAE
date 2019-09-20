//  Created by Axel Ancona Esselmann on 9/14/19.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import UIKit
import RxSwift
#if os(iOS)
import constrain
#endif

public protocol ContainerProtocol {
    func inject(_ consumer: AnyObject)
}

public protocol Injectable {
    init(container: ContainerProtocol)
}

open class BaseViewModel: Injectable {
    public let container: ContainerProtocol

    public required init(container: ContainerProtocol) {
        self.container = container
        container.inject(self)
    }
}

#if os(iOS)
open class BaseViewController: UIViewController, Injectable {

    public required init(container: ContainerProtocol) {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) { fatalError() }

    public var loadingComponent: UIViewController?
    public let hasDismissedError: Observable<Error> = PublishSubject<Error>()
    private let bag = DisposeBag()

    internal func showLoader(_ customLoadingComponent: UIViewController? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard self?.loadingComponent == nil else {
                return
            }
            let loadingComponent = customLoadingComponent ?? LoadingComponent()
            self?.loadingComponent = loadingComponent
            self?.constrainSubview(loadingComponent)
                .fill()
        }
    }

    internal func hideLoader() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingComponent?.view.removeFromSuperview()
            self?.loadingComponent = nil
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    public func subscribe<T>(state: ObservableState<T>, customLoadingComponent: UIViewController? = nil, onLoaded: ((T) -> Void)?, onError: ((Error) -> Void)? = nil, showDefaultErrorDialog: Bool = true) {
        state.observeOnMain().subscribeOnNext { [weak self] state in
            switch state {
            case .loading: self?.showLoader(customLoadingComponent)
            case .loaded(let loaded):
                self?.hideLoader()
                onLoaded?(loaded)
            case .error(let error):
                self?.hideLoader()
                onError?(error)
                if showDefaultErrorDialog {
                    self?.present(error: error)
                }
            }
            }.disposed(by: bag)
    }

    public func subscribe<T>(state: ObservableState<T>) -> Observable<T> {
        return state.observeOnMain().map { [weak self] state -> T? in
            switch state {
            case .loading:
                self?.showLoader()
                return nil
            case .loaded(let loaded):
                self?.hideLoader()
                return loaded
            case .error(let error):
                self?.hideLoader()
                self?.present(error: error)
                return nil
            }
        }.filterNil()
    }

    public func present(error: Error) {
        let userFacingError = (error as? UserFacingErrorConvertable)?.userFacingError ?? .unknown
        let errorString = userFacingError.errorString
        let errorAlert = UIAlertController(title: nil, message: errorString, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak hasDismissedError] _ in
            (hasDismissedError as? PublishSubject)?.onNext(error)
        }))
        present(errorAlert, animated: true, completion: nil)
    }

    public func present(message: String) {
        let errorAlert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(errorAlert, animated: true, completion: nil)
    }
}

#endif
