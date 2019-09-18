//  Created by Axel Ancona Esselmann on 9/23/18.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import Foundation

public extension Date {

    static var iso8601Formatter: DateFormatter {
        let format = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter
    }

    static let utcIso8601DateFormatter: DateFormatter = {
        let format = "yyyy-MM-dd"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter
    }()

    static let readableDateFormatter: DateFormatter = {
        let format = "MMMM d, yyyy"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter
    }()

    init?(timestamp: String) {
        guard let date = Date.iso8601Formatter.date(from: timestamp) else {
            return nil
        }
        self.init(timeIntervalSince1970: date.timeIntervalSince1970)
    }

    init?(yyyyMMddTimestamp: String) {
        guard let date = Date.utcIso8601DateFormatter.date(from: yyyyMMddTimestamp) else {
            return nil
        }
        self.init(timeIntervalSince1970: date.timeIntervalSince1970)
    }

    var utcIso8601: String {
        return Date.iso8601Formatter.string(from: self)
    }

    var utcIso8601Date: String {
        return Date.utcIso8601DateFormatter.string(from: self)
    }

    var readableDate: String {
        return Date.readableDateFormatter.string(from: self)
    }

    func isWithinSeconds(_ seconds: TimeInterval, ofDate date2: Date) -> Bool {
        let secondsApart = abs(timeIntervalSince(date2))
        return secondsApart < seconds
    }
}

public extension Date {
    var previousDay: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self) ?? self
    }
    var nextDay: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self) ?? self
    }
}
