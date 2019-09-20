//  Created by Axel Ancona Esselmann on 9/11/19.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import UIKit

#if os(iOS)

public extension UILabel {
    convenience init(text: String, font: UIFont? = nil, numberOfLines: Int? = nil) {
        self.init(frame: CGRect.zero)
        self.text = text
        if let font = font {
            self.font = font
        }
        if let numberOfLines = numberOfLines {
            self.numberOfLines = numberOfLines
        }
    }
}

#endif
