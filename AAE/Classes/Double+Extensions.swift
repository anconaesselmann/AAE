//  Created by Axel Ancona Esselmann on 1/20/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

extension Double: ExpressibleAsDouble {
    public var asDouble: Double { return self }
}

extension Double {
    var stringWithoutTrailingZeros: String {
        return string(minimumFractionDigits: 0, maximumFractionDigits: 1)
    }

    func string(minimumFractionDigits: Int, maximumFractionDigits: Int, minimumIntegerDigits: Int = 0) -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumIntegerDigits = minimumIntegerDigits
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits
        return String(formatter.string(from: number) ?? "")
    }

    func string(fractionDigits: Int) -> String {
        return string(minimumFractionDigits: fractionDigits, maximumFractionDigits: fractionDigits)
    }
}
