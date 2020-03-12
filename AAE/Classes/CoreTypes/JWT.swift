//  Created by Axel Ancona Esselmann on 9/11/19.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import Foundation

public struct JWT: Equatable {
    public let stringValue: String

    public init?(stringValue: String) {
        self.stringValue = stringValue
        // todo: don't initialize if not a valid urn
    }
}

extension JWT: Encodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.stringValue = try container.decode(String.self)
        // todo: throw if not a valid urn
    }
}

extension JWT: Decodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(stringValue)
    }
}
