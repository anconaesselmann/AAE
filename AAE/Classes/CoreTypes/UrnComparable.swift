//  Created by Axel Ancona Esselmann on 2/6/20.
//

import Foundation

public protocol UrnComparable: Comparable {
    var urn: URN { get }
}

extension UrnComparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.urn.rawValue == rhs.urn.rawValue
    }
}
