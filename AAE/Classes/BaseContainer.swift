//  Created by Axel Ancona Esselmann on 9/20/19.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import AAE

public typealias Dependency = Injectable & Injecting

public protocol Injecting {
    func inject(into consumer: AnyObject)
}

open class BaseDependency: Injectable {
    public let container: ContainerProtocol // retain cycle?

    public required init(container: ContainerProtocol) {
        self.container = container
    }
}

open class BaseContainer: ContainerProtocol {

    open func dependencyTypes() -> [Dependency.Type] {
        assertionFailure("Child class needs to override")
        return []
    }

    private var dependencies: [Dependency] = []

    public init() {
        dependencies = dependencyTypes().compactMap { [weak self] type in
            guard let strongSelf = self else {
                return nil
            }
            return type.init(container: strongSelf)
        }
    }

    open func inject(_ consumer: AnyObject) {
        for dependency in dependencies {
            dependency.inject(into: consumer)
        }
    }
}
