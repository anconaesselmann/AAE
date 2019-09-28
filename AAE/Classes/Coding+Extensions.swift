//  Created by Axel Ancona Esselmann on 8/10/18.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import Foundation

public extension JSONDecoder {
    convenience init(convertFromSnakeCase: Bool) {
        self.init()
        if convertFromSnakeCase {
            keyDecodingStrategy = .convertFromSnakeCase
        }
    }
}

public extension Decodable {
    init?(jsonString: String?) {
        guard let decoded = JsonCoder.default.decode(string: jsonString, to: Self.self) else {
            return nil
        }
        self = decoded
    }
}
