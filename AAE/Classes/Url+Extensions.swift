//  Created by Axel Ancona Esselmann on 9/11/19.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import URN

public extension URL {
    func appendingQueryItem(name: String, value: String) -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return self
        }
        var queryItems = components.queryItems ?? []
        let queryItem = URLQueryItem(name: name, value: value)
        queryItems.append(queryItem)
        components.queryItems = queryItems
        return components.url ?? self
    }

    func appendingQueryItem(name: StringRepresentable, value: String) -> URL {
        return self.appendingQueryItem(name: name.stringValue, value: value)
    }

    func appendingQueryItem(name: StringRepresentable, value: StringRepresentable) -> URL {
        return self.appendingQueryItem(name: name.stringValue, value: value.stringValue)
    }

    func appendingPathComponent(_ pathComponent: StringRepresentable) -> URL {
        return self.appendingPathComponent(pathComponent.stringValue)
    }
}


// https://stackoverflow.com/questions/46603220/how-do-i-convert-url-query-to-a-dictionary-in-swift#answer-46603619

// MARK: - [URLQueryItem] to [String: Any]

extension Array where Element == URLQueryItem {
    public func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        for queryItem in self {
            guard let value = queryItem.value?.toCorrectType() else { continue }
            if queryItem.name.contains("[]") {
                let key = queryItem.name.replacingOccurrences(of: "[]", with: "")
                let array = dictionary[key] as? [Any] ?? []
                dictionary[key] = array + [value]
            } else {
                dictionary[queryItem.name] = value
            }
        }
        return dictionary
    }
}

extension String {

    // MARK: - String to [URLQueryItem]

    func toURLQueryItems() -> [URLQueryItem]? {
        guard let urlString = self.removingPercentEncoding, let url = URL(string: urlString) else { return nil }
        if let querItems = url.toQueryItems() { return querItems }
        var urlComponents = URLComponents()
        urlComponents.query = urlString
        return urlComponents.queryItems
    }

    // MARK: - attempt to cast string to correct type (int, bool...)

    func toCorrectType() -> Any {
        let types: [LosslessStringConvertible.Type] = [Bool.self, Int.self, Double.self]
        func cast<T>(to: T) -> Any? { return (to.self as? LosslessStringConvertible.Type)?.init(self) }
        for type in types { if let value = cast(to: type) { return value } }
        return self
    }
}

// MARK: - URL to [URLQueryItem]

extension URL {
    public func toQueryItems() -> [URLQueryItem]? {
        return URLComponents(url: self, resolvingAgainstBaseURL: false)?.queryItems
    }
}

// MARK: - create [URLQueryItem] from [AnyHashable: Any] or [any]

extension URLQueryItem {
    private static var _bracketsString: String { return "[]" }
    static func create(from values: [Any], with key: String) -> [URLQueryItem] {
        let _key = key.contains(_bracketsString) ? key : key + _bracketsString
        return values.compactMap { value -> URLQueryItem? in
            if value is [Any] || value is [AnyHashable: Any] { return nil }
            return URLQueryItem(name: _key, value: value as? String ?? "\(value)")
        }
    }

    static func create(from values: [AnyHashable: Any]) -> [URLQueryItem] {
        return values.flatMap { element -> [URLQueryItem] in
            if element.value is [AnyHashable: Any] { return [] }
            let key = element.key as? String ?? "String"
            if let values = element.value as? [Any] { return URLQueryItem.create(from: values, with: key) }
            return [URLQueryItem(name: key, value: element.value as? String ?? "\(element.value)")]
        }
    }
}

 // MARK: - [AnyHashable: Any] to [URLQueryItem]

extension Dictionary where Value: Any {
    public func toURLQueryItems() -> [URLQueryItem] { return URLQueryItem.create(from: self) }
}
