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

    // TODO: What does it mean when values are larger than bins?
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

public extension Array where Element: ExpressibleAsDouble {
    func runningTotals() -> [Double] {
        var result: [Double] = [0]
        var runningTotal: Double = 0.0
        guard !self.isEmpty else { return result }
        for delta in self {
            runningTotal += delta.asDouble
            result.append(runningTotal)
        }
        return result
    }
}

public extension Array where Element: Hashable {
    
    func after(item: Element) -> Element? {
        if let index = index(of: item), index + 1 < self.count {
            return self[index + 1]
        }
        return nil
    }
    
    func before(item: Element) -> Element? {
        if let index = index(of: item), index - 1 >= 0 {
            return self[index - 1]
        }
        return nil
    }
    
    @discardableResult
    mutating func appendIfNew(item: Element) -> Bool {
        if let _ = index(of: item) {
            return false
        } else {
            self.append(item)
            return true
        }
    }
    
    @discardableResult
    mutating func removeIfMember(item: Element) -> Bool {
        if let index = index(of: item) {
            self.remove(at: index)
            return true
        } else {
            return false
        }
    }
}
