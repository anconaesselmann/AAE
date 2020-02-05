//  Created by Axel Ancona Esselmann on 9/11/19.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import RxSwift

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

    struct StorageKeys {
        static let auth = "AuthManager.auth"
    }

    // TODO: Inject more sensible storage
    let storage: UserDefaults

    // Right now this allows outside classes to log a user in
    public let loginStatus: LoadableBehaviorSubject<AuthenticationStatus>

    public var isLoggedIn: Observable<Bool> {
        return loginStatus
            .unpack(whenNotLoaded: .loggedOut)
            .map { $0.isLoggedIn }
    }

    public var auth: AuthData? {
        get {
            let loadableResult: LoadableResult<AuthenticationStatus> = loginStatus.safeValue ?? .error(AAError.deinitialized)
            let status: AuthenticationStatus = loadableResult.unpack() ?? .loggedOut
            switch status {
            case .loggedOut: return nil
            case .loggedIn(let auth): return auth
            }
        }
        set {
            guard let auth = newValue else {
                storage.removeObject(forKey: StorageKeys.auth)
                loginStatus.onNext(.loaded(.loggedOut))
                return
            }
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            do {
                let encoded = try encoder.encode(auth)
                storage.set(encoded, forKey: StorageKeys.auth)
                loginStatus.onNext(.loaded(.loggedIn(auth)))
            } catch {
                Debug.log(error)
                loginStatus.onNext(.loaded(.loggedOut))
                return
            }
        }
    }

    public init(storage: UserDefaults = UserDefaults.standard) {
        self.storage = storage
        let loginState: LoadableResult<AuthenticationStatus>
        if let authData = storage.object(forKey: StorageKeys.auth) as? Data {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let decodedAuth = try decoder.decode(AuthData.self, from: authData)
                loginState = .loaded(.loggedIn(decodedAuth))
            } catch {
                loginState = .loaded(.loggedOut)
                Debug.log(error)
            }
        } else {
            loginState = .loaded(.loggedOut)
        }
        loginStatus = LoadableBehaviorSubject<AuthenticationStatus>(value: loginState)
    }

}
