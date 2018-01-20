//  Created by Axel Ancona Esselmann on 1/15/18.
//  Copyright © 2018 Axel Ancona Esselmann. All rights reserved.
//

import Foundation

public extension Array {
    func deltas<T>(_ transform: ((Element, Element) -> T)) -> [T] {
        var result: [T] = []
        var prev: Element? = nil
        for new in self {
            if let old = prev {
                let delta = transform(old, new)
                result.append(delta)
            }
            prev = new
        }
        return result
    }
}
