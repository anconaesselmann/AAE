//  Created by Axel Ancona Esselmann on 9/11/18.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import Foundation

public extension String {
    init?(notEmptyOrNil: String?) {
        guard let notEmptyOrNil = notEmptyOrNil, !notEmptyOrNil.isEmpty else {
            return nil
        }
        self = notEmptyOrNil
    }

    func capitalizeFirstLetter() -> String {
        let first = String(prefix(1)).capitalized
        let other = String(dropFirst())
        return first + other
    }
}
