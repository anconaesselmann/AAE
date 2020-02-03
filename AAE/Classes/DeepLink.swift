//  Created by Axel Ancona Esselmann on 8/10/18.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

public struct DeepLink<Root> where Root: StringRepresentable {
    public let root: Root
    public let queryDict: [String: Any]

    public init?(url: URL) {
        guard
            let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
            let hostString = components.host,
            let root = Root(rawValue: hostString)
        else {
            return nil
        }
        self.root = root
        self.queryDict = url.toQueryItems()?.toDictionary() ?? [:]
    }
}
