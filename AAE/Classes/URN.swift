//  Created by Axel Ancona Esselmann on 9/11/19.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import Foundation

public struct URN {
    public let stringValue: String

    public init?(stringValue: String) {
        self.stringValue = stringValue
        // todo: don't initialize if not a valid urn
    }

    public var uuid: UUID {
        return UUID(uuidString: String(stringValue.suffix(36)))! // ! will be OK because initializers check validity
    }

    public var uuidString: String {
        return uuid.uuidString.lowercased()
    }
}

extension URN: Encodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.stringValue = try container.decode(String.self)
        // todo: throw if not a valid urn
    }
}

extension URN: Decodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(stringValue)
    }
}
