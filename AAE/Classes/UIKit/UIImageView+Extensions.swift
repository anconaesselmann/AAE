//  Created by Axel Ancona Esselmann on 2/7/20.
//

import UIKit

#if os(iOS)
extension UIImageView {
    public convenience init(contentMode: UIView.ContentMode) {
        self.init()
        self.contentMode = contentMode
    }
}
#endif
