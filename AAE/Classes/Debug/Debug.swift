//  Created by Axel Ancona Esselmann on 8/10/18.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import Foundation

public enum DebugGroup: String, PrefixedDebugPrintable {
    case debug
    case note
    case todo
    case warning
    case fatal

    public var prefix: String {
        switch self {
        case .fatal:
            return "‼️"
        case .warning:
            return "⚠️"
        case .debug:
            return "🐞"
        case .note:
            return "☝️"
        case .todo:
            return "🏗"
        }
    }
}

public protocol DebugPrintable {
    var rawValue: String { get }
}

public protocol PrefixedDebugPrintable: DebugPrintable {
    var prefix: String { get }
}

public class Debug {
    #if DEBUG
    private static var loggingGroups: [String: Bool] = [:]
    #endif

    public static func log(group: DebugPrintable, isLogging: Bool = true) {
        #if DEBUG
        self.loggingGroups[group.rawValue] = isLogging
        #endif
    }

    public static func isLogging(for group: DebugPrintable) -> Bool {
        return self.loggingGroups[group.rawValue] ?? false
    }

    public static func log(_ string: String?, group: DebugPrintable) {
        #if DEBUG
        guard self.loggingGroups[group.rawValue] ?? false else {
            return
        }
        let string = string ?? "nil"
        if let prefixedGroup = group as? PrefixedDebugPrintable {
            print(prefixedGroup.prefix + " " + string)
        } else {
            print(string)
        }
        #endif
    }
    public static func log(_ convertable: CustomStringConvertible?, group: DebugPrintable) {
        #if DEBUG
        self.log(convertable.debugDescription, group: group)
        #endif
    }

    public static func log(_ error: Error, file: String = #file, line: Int = #line) {
        #if DEBUG
        log("\(error)\nFile: \(file)\nLine #\(line)", group: DebugGroup.warning)
        #endif
    }

    public static func printJson(_ json: Any) {
        #if DEBUG
        guard
            let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
            let string = String(data: data, encoding: .utf8)
        else {
            print("Not JSON")
            return
        }
        print(NSString(string: string))
        #endif
    }

    public static func printDebug(_ string: String?) {
        #if DEBUG
        log(string, group: DebugGroup.debug)
        #endif
    }

    public static func printDebug(_ strings: [String]?) {
        #if DEBUG
        printDebug(strings?.joined(separator: ", "))
        #endif
    }
}
