//  Created by Axel Ancona Esselmann on 8/01/18.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import Foundation

public extension Array {
    func replacing(element newElement: Element, where comparison: (Element, Element) -> Bool) -> Array<Element> {
        return self.map { comparison($0, newElement) ? newElement : $0 }
    }
}
