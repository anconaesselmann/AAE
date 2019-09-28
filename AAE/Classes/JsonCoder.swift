//  Created by Axel Ancona Esselmann on 1/23/18.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import RxSwift

public class JsonCoder {

    public init() { }

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()

    public enum JsonError: Error {
        case noData
        case couldNotDecode(Error)
    }

    public static var `default`: JsonCoder = { JsonCoder() }()

    public func decode<T>(_ jsonData: Data?, to type: T.Type) -> Single<T> where T: Decodable {
        guard let data = jsonData else {
            return Single.error(JsonError.noData)
        }
        do {
            let decoded = try decoder.decode(type, from: data)
            return Single.just(decoded)
        } catch {
            return Single.error(JsonError.couldNotDecode(error))
        }
    }

    public func decode<T>(_ jsonData: Data?) -> Single<T> where T: Decodable {
        return decode(jsonData, to: T.self)
    }

    public func decode<T>(string: String?, to type: T.Type) -> T? where T: Decodable {
        guard let string = string, let data = string.data(using: .utf8) else {
            return nil
        }
        do {
            let decoded = try decoder.decode(T.self, from: data)
            return decoded
        } catch {
            return nil
        }
    }

}
