//  Created by Axel Ancona Esselmann on 9/18/19.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import Foundation

open class BaseManager: Injectable {

    public let container: ContainerProtocol

    public required init(container: ContainerProtocol) {
        self.container = container
        container.inject(self)
    }
}
