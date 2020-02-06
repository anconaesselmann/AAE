//  Created by Axel Ancona Esselmann on 2/5/20.
//

import Foundation

struct AuthCacheHelper {

    struct StorageKeys {
        static let auth = "AuthManager.auth"
    }

    static func loginStatus(from storage: UserDefaults) -> LoadableResult<AuthManager.AuthenticationStatus> {
        if let authData = storage.object(forKey: StorageKeys.auth) as? Data {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let decodedAuth = try decoder.decode(AuthData.self, from: authData)
                return .loaded(.loggedIn(decodedAuth))
            } catch {
                Debug.log(error)
                return .loaded(.loggedOut)
            }
        } else {
            return .loaded(.loggedOut)
        }
    }

    static func cache(
        loginState: AuthManager.AuthenticationStatus,
        storage: UserDefaults)
    {
        switch loginState {
        case .loggedOut:
            storage.removeObject(forKey: StorageKeys.auth)
        case .loggedIn(let auth):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            do {
                let encoded = try encoder.encode(auth)
                storage.set(encoded, forKey: StorageKeys.auth)
            } catch {
                Debug.log(error)
                storage.removeObject(forKey: StorageKeys.auth)
            }
        }

    }
}
