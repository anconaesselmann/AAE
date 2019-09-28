//  Created by Axel Ancona Esselmann on 9/11/19.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import Foundation

public class AuthManager {

    struct Keys {
        static let auth = "AuthManager.auth"
    }

    // TODO: Inject store
    let defaults = UserDefaults.standard

    public var isLoggedIn: Bool {
        return auth != nil
    }

    public init() {
        if let authData = defaults.object(forKey: Keys.auth) as? Data {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let decodedAuth = try decoder.decode(AuthData.self, from: authData)
                self.auth = decodedAuth
            } catch {
                Debug.log(error)
            }
        }
    }

    public var auth: AuthData? {
        didSet {
            guard let auth = auth else {
                defaults.removeObject(forKey: Keys.auth)
                return
            }
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            do {
                let encoded = try encoder.encode(auth)
                defaults.set(encoded, forKey: Keys.auth)
            } catch {
                Debug.log(error)
            }
        }
    }
}
