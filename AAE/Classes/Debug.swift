//  Created by Axel Ancona Esselmann on 8/10/18.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import Foundation

public enum DebugGroup: String, DebugPrintable {
    case debug
    case note
    case todo
    case warning
    case fatal
}

public protocol DebugPrintable {
    var rawValue: String { get }
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

    public static func log(_ string: String?, group: DebugPrintable) {
        #if DEBUG
        guard self.loggingGroups[group.rawValue] ?? false else {
            return
        }
        if let string = string {
            print(string)
        } else {
            print("nil")
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
}
