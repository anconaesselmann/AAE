//  Created by Axel Ancona Esselmann on 1/20/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

extension Int: ExpressibleAsDouble {
    public var asDouble: Double { return Double(self) }
}
