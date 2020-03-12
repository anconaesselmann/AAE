//  Created by Axel Ancona Esselmann on 3/3/20.
//

import Foundation

#if DEBUG

public enum InstanceCountGroup: String, DebugPrintable {
    case viewModel
}

extension Debug {
    static func isDisplayingInstanceCounts(for group: InstanceCountGroup) -> Bool {
        return isLogging(for: group)
    }
}

private var instanceCounts: [String: Int] = [:]

func printInstanceCounts() {
//    guard Debug.isDisplayingInstanceCounts else {
//        return
//    }
    print("\n\n")
    for (name, count) in instanceCounts {
        print(name, count)
    }
}

public extension Debug {

    static func incrementInstanceCount<T>(for type: T.Type, group: InstanceCountGroup) {
        guard Debug.isDisplayingInstanceCounts(for: group) else {
            return
        }
        let instanceCount = instanceCounts["\(type)"] ?? 0
        instanceCounts["\(type)"] = instanceCount + 1
        printInstanceCounts()
    }

    static func decrementInstanceCount<T>(for type: T.Type, group: InstanceCountGroup) {
        guard Debug.isDisplayingInstanceCounts(for: group) else {
            return
        }
        let instanceCount = instanceCounts["\(type)"] ?? 0
        instanceCounts["\(type)"] = instanceCount - 1
        printInstanceCounts()
    }

}
#endif
