//  Created by Axel Ancona Esselmann on 9/11/19.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import UIKit

public extension UIButton {
    convenience init(title: String, titleColor: UIColor? = nil) {
        self.init(frame: CGRect.zero)
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
    }
}
