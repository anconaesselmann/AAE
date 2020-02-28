//  Created by Axel Ancona Esselmann on 9/11/19.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import RxSwift
import RxLoadableResult

public class AuthManager {

    public enum AuthenticationStatus {
        case loggedOut
        case loggedIn(AuthData)

        var isLoggedIn: Bool {
            switch self {
            case .loggedIn: return true
            case .loggedOut: return false
            }
        }
    }

    // TODO: Inject more sensible storage
    private let storage: UserDefaults

    private let loginStatus: LoadableBehaviorSubject<AuthenticationStatus>

    private let bag = DisposeBag()

    public var status: Observable<AuthenticationStatus> {
        return loginStatus
        .unpack(whenNotLoaded: .loggedOut)
    }

    public var isLoggedIn: Observable<Bool> {
        return status.map { $0.isLoggedIn }
    }

    public var isLoggedInStatus: LoadingObservable<Bool> {
        return loginStatus.mapLoadableResult { $0.isLoggedIn }
    }

    public var auth: Observable<AuthData?> {
        return status.map { status in
            switch status {
            case .loggedOut: return nil
            case .loggedIn(let auth): return auth
            }
        }
    }

    public init(storage: UserDefaults = UserDefaults.standard) {
        self.storage = storage
        let loginState = AuthCacheHelper.loginStatus(from: storage)
        loginStatus = LoadableBehaviorSubject<AuthenticationStatus>(value: loginState)

        self.loginStatus.asObservable()
            .unpack(whenNotLoaded: .loggedOut)
            .with(storage)
            .subscribeOnNext { AuthCacheHelper.cache(loginState: $0.0, storage: $0.1) }
            .disposed(by: bag)
    }

    public func logout() {
        loginStatus.onNext(.loaded(.loggedOut))
    }

    public func login(authData: AuthData) {
        loginStatus.onNext(.loaded(.loggedIn(authData)))
    }

    public func loading() {
        loginStatus.onNext(.loading)
    }

}
