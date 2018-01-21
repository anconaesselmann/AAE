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

// TODO: What does it mean when values are larger than bins?
public extension Array {
    func splits<T: ExpressibleAsDouble>(_ splitSize: ExpressibleAsDouble, transform: ((Element, Element) -> T)) -> [[Element]] {
        let splitSize = splitSize.asDouble
        var result: [[Element]] = []
        var runnintTotal: Double = 0
        var currentBin: [Element] = []
        var prev: Element? = nil
        for new in self {
            defer { prev = new }
            guard let old = prev else { currentBin.append(new); continue }
            let delta = transform(old, new)
            runnintTotal += delta.asDouble
            let binNumber: Int = runnintTotal.truncatingRemainder(dividingBy: splitSize) == 0 ? Int(runnintTotal / splitSize) - 1 : Int(floor(runnintTotal / splitSize))
            if binNumber > result.count {
                result.append(currentBin)
                currentBin = []
                currentBin.append(old)
            }
            currentBin.append(new)
        }
        if currentBin.count > 1 {
            result.append(currentBin)
        }
        return result
    }
}
