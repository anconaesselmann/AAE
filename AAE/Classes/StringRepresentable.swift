//  Created by Axel Ancona Esselmann on 8/10/18.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import Foundation

public protocol StringRepresentable {
    var rawValue: String { get }
    init?(rawValue: String)
}

public extension StringRepresentable {
    var stringValue: String {
        return rawValue
    }
}
