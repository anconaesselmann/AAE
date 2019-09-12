//  Created by Axel Ancona Esselmann on 9/11/19.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import UIKit

#if os(iOS)

public extension UIWindow {
    convenience init(rootViewController vc: UIViewController) {
        self.init(frame: UIScreen.main.bounds)
        rootViewController = vc
        makeKeyAndVisible()
    }
}

#endif
