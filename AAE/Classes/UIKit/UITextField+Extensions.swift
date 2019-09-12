//  Created by Axel Ancona Esselmann on 9/11/19.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import UIKit

#if os(iOS)

public extension UITextField {
    convenience init(placeholder: String) {
        self.init(frame: CGRect.zero)
        self.placeholder = placeholder
    }
}

#endif
