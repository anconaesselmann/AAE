//  Created by Axel Ancona Esselmann on 9/11/19.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import UIKit

#if os(iOS)

public struct LabelStyle {
    public var textColor: UIColor?
    public var textAlignment: NSTextAlignment?
    public var numberOfLines: Int?

    public init(
        textColor: UIColor? = nil,
        textAlignment: NSTextAlignment? = nil,
        numberOfLines: Int?
    ) {
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
    }
}

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

    convenience init(text: String, style: LabelStyle) {
        self.init(text: text)
        if let textColor = style.textColor {
            self.textColor = textColor
        }
        if let textAlignment = style.textAlignment {
            self.textAlignment = textAlignment
        }
        if let numberOfLines = style.numberOfLines {
            self.numberOfLines = numberOfLines
        }
    }
}

#endif
