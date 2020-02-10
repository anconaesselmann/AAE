//  Created by Axel Ancona Esselmann on 9/11/18.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import Foundation

public struct URN {
    public let stringValue: String

    public init?(stringValue: String) {
        self.stringValue = stringValue
        // todo: don't initialize if not a valid urn
    }

    public var uuid: UUID {
        return UUID(uuidString: String(stringValue.suffix(36)))! // ! will be OK because initializers check validity
    }

    public var uuidString: String {
        return uuid.uuidString.lowercased()
    }
}

extension URN: StringRepresentable {
    public var rawValue: String {
        return stringValue
    }

    public init?(rawValue: String) {
        self.init(stringValue: rawValue)
    }
}

extension URN: Encodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.stringValue = try container.decode(String.self)
        // todo: throw if not a valid urn
    }
}

extension URN: Decodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(stringValue)
    }
}

extension URN: Equatable {
    public static func ==(lhs: URN, rhs: URN) -> Bool {
        return lhs.stringValue.lowercased() == rhs.stringValue.lowercased()
    }
}

public extension UUID {
    init?(urnString: String?) {
        guard
            let urnString = urnString,
            let uuidString = urnString.matches(for: "[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}").first
            else { return nil }

        self.init(uuidString: uuidString)
    }
}

public extension String {
    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch {
            return []
        }
    }
}

public extension UUID {
    var serverString: String {
        return uuidString.lowercased()
    }
}
