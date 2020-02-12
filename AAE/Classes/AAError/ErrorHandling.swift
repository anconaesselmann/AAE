//  Created by Axel Ancona Esselmann on 8/10/18.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import Foundation

public protocol ErrorStringConvertable {
    var errorString: String { get }
}

public protocol UserFacingErrorConvertable {
    var userFacingError: UserFacingError { get }
}

public enum UserFacingError {
    case message(String)
    case unknown
}

extension UserFacingError: ErrorStringConvertable {

    struct Strings {
        static let generalErrorMessage = "We encountered an error"
    }

    public var errorString: String {
        switch self {
        case .message(let message):
            return message
        case .unknown:
            return Strings.generalErrorMessage
        }
    }
}
