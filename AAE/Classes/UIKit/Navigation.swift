//  Created by Axel Ancona Esselmann on 2/7/20.
//

import UIKit

#if os(iOS)
public enum Navigation {

    public enum Direction {
        case fromLeft
        case fromRight
        case replace
    }

    case next(screenType: BaseViewController.Type, clearNavigationStack: Bool, direction: Direction)
    case back
}
#endif
