//  Created by Axel Ancona Esselmann on 02/05/17.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import UIKit

public extension UIColor {
    convenience init?(red: Int, green: Int, blue: Int) {
        guard
            red   >= 0 && red   <= 255,
            green >= 0 && green <= 255,
            blue  >= 0 && blue  <= 255
        else {
            return nil
        }
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0, alpha: 1.0
        )
    }

}
