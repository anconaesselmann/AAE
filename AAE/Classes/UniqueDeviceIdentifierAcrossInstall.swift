//  Created by Axel Ancona Esselmann on 4/15/18.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import UIKit

#if os(iOS)
public struct UniqueDeviceIdentifierAcrossInstall {

    public static var UUID: NSUUID? {
        guard let uuidString = UIDevice.current.identifierForVendor?.uuidString, let uuid = NSUUID(uuidString: uuidString) else {
            Debug.log("Could not get device identifier", group: DebugGroup.warning)
            return nil
        }
        return uuid
    }
}
#endif
