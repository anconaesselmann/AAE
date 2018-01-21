//  Created by Axel Ancona Esselmann on 7/12/17.
//  Copyright © 2017 Axel Ancona Esselmann. All rights reserved.
//

import UIKit

extension CGFloat: ExpressibleAsDouble {
    public var asDouble: Double { return Double(self) }
}
