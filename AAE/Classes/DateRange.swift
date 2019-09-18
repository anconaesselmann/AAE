//  Created by Axel Ancona Esselmann on 9/20/18.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import Foundation

public struct DateRange {

    public enum Boundary {
        case inclusive(Date)
        case exclusive(Date)
        case none
    }

    public let lower: Boundary
    public let upper: Boundary

    public init(lower: Boundary, upper: Boundary) {
        // TODO: Currently not checking that lower comes before upper.
        self.lower = lower
        self.upper = upper
    }

    public init(lower: Boundary) {
        self.init(lower: lower, upper: .none)
    }

    public init(upper: Boundary) {
        self.init(lower: .none, upper: upper)
    }

    public init() {
        self.init(lower: .none, upper: .none)
    }

    public init(pastNumberOfDays: Int) {
        let today = Date()
        let upper = Boundary.inclusive(today)
        guard let lowerDate = Calendar.current.date(byAdding: .day, value: -(pastNumberOfDays + 1), to: today) else {
            self.init(upper: upper)
            return
        }
        self.init(lower: .inclusive(lowerDate), upper: upper)
    }

    public func includes(_ date: Date) -> Bool {

        func included(lower: Date, upper: Date, date: Date) -> Bool {
            let range = lower...upper
            return range.contains(date)
        }

        switch (lower, upper) {
        case (.inclusive(let lower), .inclusive(let upper)):
            return included(lower: lower, upper: upper, date: date)
        case (.inclusive(let lower), .exclusive(let upper)):
            let adjustedUpper = upper.previousDay
            return included(lower: lower, upper: adjustedUpper, date: date)
        case (.inclusive(let lower), .none):
            return included(lower: lower, upper: date, date: date)

        case (.exclusive(let lower), .inclusive(let upper)):
            let adjustedLower = lower.nextDay
            return included(lower: adjustedLower, upper: upper, date: date)
        case (.exclusive(let lower), .exclusive(let upper)):
            let adjustedLower = lower.nextDay
            let adjustedUpper = upper.previousDay
            return included(lower: adjustedLower, upper: adjustedUpper, date: date)
        case (.exclusive(let lower), .none):
            let adjustedLower = lower.nextDay
            return included(lower: adjustedLower, upper: date, date: date)

        case (.none, .inclusive(let upper)):
            return included(lower: date, upper: upper, date: date)
        case (.none, .exclusive(let upper)):
            let adjustedUpper = upper.previousDay
            return included(lower: date, upper: adjustedUpper, date: date)
        case (.none, .none):
            return true
        }
    }

    public func includesPreviousDate(for date: Date) -> Bool {
        return includes(date.previousDay)
    }

    public func includesNextDate(for date: Date) -> Bool {
        return includes(date.nextDay)
    }

}
