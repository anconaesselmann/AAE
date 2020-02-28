//  Created by Axel Ancona Esselmann on 2/21/20.
//

import KeychainQueryBuilder

public enum OSError: Swift.Error {
    case unhandledError(status: OSStatus)
    case duplicateItem
    case unimplemented
    case diskFull
    case ioError
    case fileAlreadyOpen
    case invalidParameter
    case noWritePermission
    case failedToAllocateMemory

    init?(_ status: OSStatus) {
        switch status {
        case errSecSuccess:
            return nil
        case errSecUnimplemented:
            self = .unimplemented
        case errSecDiskFull:
            self = .diskFull
        case errSecIO:
            self = .ioError
        case errSecOpWr:
            self = .fileAlreadyOpen
        case errSecParam:
            self = .invalidParameter
        case errSecWrPerm:
            self = .noWritePermission
        case errSecAllocate:
            self = .failedToAllocateMemory

        // TODO: do others

        case errSecDuplicateItem:
            self = .duplicateItem

        default:
            self = .unhandledError(status: status)
        }
    }
}

public class KeychainWrapper {

    public init() {
        
    }

    public func set(_ query: CFDictionary) throws {
        let status = SecItemAdd(query, nil)
        if let error = OSError(status) {
            throw error
        }
    }

    public func update(existingItemQuery: CFDictionary, updateQuery: CFDictionary) throws {
        let status = SecItemUpdate(existingItemQuery, updateQuery)
        if let error = OSError(status) {
            throw error
        }
    }

    public func delete(_ existingItemQuery: CFDictionary) throws {
        let status = SecItemDelete(existingItemQuery)
        if let error = OSError(status) {
            throw error
        }
    }

    public func getOne(_ query: CFDictionary) -> Data? {
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query, &item)

        let result = KeychainQueryResultBuilder(forQuery: query)
            .result(for: item, status: status)

        switch result {
        case .none:
            return nil
        case .one(let result):
            return result.data
        case .many(let results):
            if let first = results.first {
                return first.data
            } else {
                return nil
            }
        case .error:
            return nil
        }
    }

    public func setGenericPassword(_ password: String, for key: String) throws {
        let query = KeychainQueryBuilder(type: .genericPassword)
            .account(key)
            .data(fromString: password)
            .build()
        try set(query)
    }

    public func setGenericPassword(_ password: String, for uuid: UUID, context: String? = nil) throws {
        let context = context ?? ""
        try setGenericPassword(password, for: uuid.uuidString + context)
    }

    public func updateGenericPassword(_ password: String, for key: String) throws {
        let existingItemQuery = KeychainQueryBuilder(type: .genericPassword)
            .account(key)
            .build()

        let updateQuery = KeychainQueryBuilder()
            .account(key)
            .data(fromString: password)
            .build()
        try update(existingItemQuery: existingItemQuery, updateQuery: updateQuery)
    }

    public func updateGenericPassword(_ password: String, for uuid: UUID, context: String? = nil) throws {
        let context = context ?? ""
        try updateGenericPassword(password, for: uuid.uuidString + context)
    }

    public func deleteGenericPassword(for key: String) throws {
        let existingItemQuery = KeychainQueryBuilder(type: .genericPassword)
            .account(key)
            .build()

        try delete(existingItemQuery)
    }

    public func deleteGenericPassword(for uuid: UUID, context: String? = nil) throws {
        let context = context ?? ""
        try deleteGenericPassword(for: uuid.uuidString + context)
    }

    public func getGenericPassword(for key: String) -> String? {
        let query = KeychainQueryBuilder(type: .genericPassword)
            .account(key)
            .matchLimit(.one)
            .returnAttributes()
            .returnData()
            .build()

        guard let data = getOne(query) else {
            return nil
        }
        guard let password = String(data: data, encoding: .utf8) else {
            return nil
        }
        return password
    }

    public func getGenericPassword(for uuid: UUID, context: String? = nil) -> String? {
        let context = context ?? ""
        return getGenericPassword(for: uuid.uuidString + context)
    }
}
