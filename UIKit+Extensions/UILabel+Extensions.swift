//  Created by Axel Ancona Esselmann on 9/11/19.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import UIKit

public extension UILabel {
    convenience init(text: String) {
        self.init(frame: CGRect.zero)
        self.text = text
    }
}
