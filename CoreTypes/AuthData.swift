//  Created by Axel Ancona Esselmann on 9/11/19.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import Foundation

public struct AuthData {

    enum CodingKeys: String, CodingKey {
        case urn
        case jwt
    }

    public let urn: URN
    public let jwt: JWT

    public init(urn: URN, jwt: JWT) {
        self.urn = urn
        self.jwt = jwt
    }
}

extension AuthData: Encodable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        urn = try values.decode(URN.self, forKey: .urn)
        jwt = try values.decode(JWT.self, forKey: .jwt)
    }
}

extension AuthData: Decodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(urn, forKey: .urn)
        try container.encode(jwt, forKey: .jwt)
    }
}
