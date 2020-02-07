//  Created by Axel Ancona Esselmann on 2/7/20.
//

import UIKit

extension UIImageView {
    public convenience init(contentMode: UIView.ContentMode) {
        self.init()
        self.contentMode = contentMode
    }
}
