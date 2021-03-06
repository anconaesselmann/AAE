//  Created by Axel Ancona Esselmann on 2/7/20.
//

import UIKit

#if os(iOS)
open class BaseView: UIView {
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError() }

    public init() {
        super.init(frame: .zero)
    }

}
#endif
