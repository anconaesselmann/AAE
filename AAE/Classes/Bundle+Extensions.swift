//  Created by Axel Ancona Esselmann on 9/10/18.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import Foundation

public extension Bundle {
    convenience init?(for aClass: AnyClass, inFramework framework: String? = nil) {
        guard let framework = framework else {
            self.init(for: aClass)
            return
        }
        let bundle = Bundle(for: aClass)
        guard let url = bundle.url(forResource: framework, withExtension: "bundle") else {
            Debug.log("Unknown bundle", group: DebugGroup.warning)
            return nil
        }
        self.init(url: url)
    }
}
