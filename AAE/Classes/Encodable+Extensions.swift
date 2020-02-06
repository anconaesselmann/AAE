//  Created by Axel Ancona Esselmann on 9/13/19.
//

import Foundation

public extension Encodable {
    var json: Any? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        do {
            let data = try encoder.encode(self)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            return json
        } catch {
            return nil
        }
    }

    var jsonDict: [String: Any]? {
        guard let json = json else {
            return nil
        }
        return json as? [String: Any]
    }

    var jsonArray: [[String: Any]]? {
        guard let json = json else {
            return nil
        }
        return json as? [[String: Any]]
    }
}
