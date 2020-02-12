//  Created by Axel Ancona Esselmann on 2/7/20.
//

import UIKit

public enum Navigation {

    public enum Direction {
        case fromLeft
        case fromRight
        case replace
    }

    #if os(iOS)
    case next(screenType: BaseViewController.Type, clearNavigationStack: Bool, direction: Direction)
    #endif
    
    case back
}
