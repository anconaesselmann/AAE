//  Created by Axel Ancona Esselmann on 2/26/17.
//  Copyright © 2017 Axel Ancona Esselmann. All rights reserved.
//

import Foundation

public extension Set{
    func setFilter(_ isIncluded: (Element) throws -> Bool) rethrows -> Set<Element> {
        return Set<Element>(try! filter(isIncluded))
    }
}
