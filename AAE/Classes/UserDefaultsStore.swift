//  Created by Axel Ancona Esselmann on 9/13/19.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//
import Contain

public protocol Storing: class {
    func set<T>(_ storable: T, forKey key: String) where T: Codable
    func get<T>(type: T.Type, forKey key: String) -> T? where T: Codable
    func get<T>(forKey key: String) -> T? where T: Codable
}

public extension Storing {
    func set<T>(_ storable: T, forKey key: StringRepresentable) where T: Codable {
        set(storable, forKey: key.stringValue)
    }

    func get<T>(type: T.Type, forKey key: StringRepresentable) -> T? where T: Codable {
        return get(type: type, forKey: key.stringValue)
    }

    func get<T>(forKey key: StringRepresentable) -> T? where T: Codable {
        return get(type: T.self, forKey: key.stringValue)
    }
}

public class UserDefaultsStore: BaseInjectable, Storing {

    public var decodingStategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase
    public var encodingStategy: JSONEncoder.KeyEncodingStrategy = .convertToSnakeCase

    private let defaults = UserDefaults.standard
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = self.decodingStategy
        return decoder
    }()

    private lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = self.encodingStategy
        return encoder
    }()

    public func set<T>(_ storable: T, forKey key: String) where T: Codable {
        guard !setPrimitive(storable, forKey: key) else {
            return
        }
        let encoded: Data
        do {
            encoded = try encoder.encode(storable)
        } catch {
            Debug.printDebug("\(storable) can not be encoded")
            return
        }
        defaults.set(encoded, forKey: key)
    }

    public func get<T>(type: T.Type, forKey key: String) -> T? where T: Codable {
        if let primitive = getPrimitive(type: type, forKey: key) {
            return primitive
        }
        guard let decoded = defaults.data(forKey: key) else {
            return nil
        }
        do {
            return try decoder.decode(T.self, from: decoded)
        } catch {
            return nil
        }
    }

    public func get<T>(forKey key: String) -> T? where T: Codable {
        return self.get(type: T.self, forKey: key)
    }

    private func setPrimitive<T>(_ storable: T, forKey key: String) -> Bool where T: Codable {
        switch storable.self {
        case let string as String:
            defaults.set(string, forKey: key)
            return true
        case let url as URL:
            defaults.set(url, forKey: key)
            return true
        default:
            return false
        }
    }

    private func getPrimitive<T>(type: T.Type, forKey key: String) -> T? {
        switch type {
        case is String.Type: return defaults.string(forKey: key) as? T
        case is URL.Type: return defaults.url(forKey: key) as? T
        default:
            return nil
        }
    }
}

public protocol StoreConsumer: class {
    var store: Storing? { get set }
}

public class StoreDependency: BaseDependency, Injecting {

    lazy var store: Storing = { return UserDefaultsStore(container: self.container) }()

    public override func inject(into consumer: AnyObject) {
        guard let consumer = consumer as? StoreConsumer else {
            return
        }
        consumer.store = store
    }
}
