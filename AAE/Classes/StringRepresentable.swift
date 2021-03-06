//  Created by Axel Ancona Esselmann on 8/10/18.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import URN

public extension Dictionary where Key: StringRepresentable {
    var withStringKeys: [String: Value] {
        return reduce(into: [:], { $0[$1.key.rawValue] = $1.value })
    }
}

public extension Dictionary where Key: StringRepresentable, Value: StringRepresentable {
    var withStringKeyValues: [String: String] {
        return reduce(into: [:], { $0[$1.key.rawValue] = $1.value.rawValue })
    }
}
