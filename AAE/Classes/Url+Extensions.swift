//  Created by Axel Ancona Esselmann on 9/11/19.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import Foundation

// https://stackoverflow.com/questions/46603220/how-do-i-convert-url-query-to-a-dictionary-in-swift#answer-46603619
public extension URL {
    var queryDictionary: [String: String]? {
        guard let query = self.query else { return nil}

        var queryStrings = [String: String]()
        for pair in query.components(separatedBy: "&") {

            let key = pair.components(separatedBy: "=")[0]

            let value = pair
                .components(separatedBy:"=")[1]
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? ""

            queryStrings[key] = value
        }
        return queryStrings
    }
}

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

    /// For url comparison where only the host and the port are of interest
    var hostWithPort: URL? {
        guard let host = self.host else {
            return nil
        }
        return URL(string: "\(host):\(17851)")
    }
}
