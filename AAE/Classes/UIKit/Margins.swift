//  Created by Axel Ancona Esselmann on 9/11/19.
//

import UIKit

public enum Margins: CGFloat {
    case zero = 0
    case small = 8
    case medium = 16
    case large = 24
    case extraLarge = 32
}

public extension CGFloat {
    static let small: CGFloat = Margins.small.rawValue
    static let medium: CGFloat = Margins.medium.rawValue
    static let large: CGFloat = Margins.large.rawValue
    static let extraLarge: CGFloat = Margins.extraLarge.rawValue
}
