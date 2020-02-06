//  Created by Axel Ancona Esselmann on 2/5/20.
//

import Foundation

extension RangeReplaceableCollection {
    public func appendedUnique(_ element: Element, where comparison: (Element, Element) -> Bool) -> Self {
        var copy = self
        copy.removeAll(where: { comparison($0, element) })
        copy.append(element)
        return copy
    }
}
