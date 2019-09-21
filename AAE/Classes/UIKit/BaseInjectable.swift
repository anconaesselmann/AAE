//  Created by Axel Ancona Esselmann on 9/18/19.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import RxSwift

public protocol ContainerProtocol {
    func inject(_ consumer: AnyObject)
}

public protocol Injectable {
    init(container: ContainerProtocol)
}

open class BaseInjectable: Injectable {

    public let bag = DisposeBag()
    public let container: ContainerProtocol

    public required init(container: ContainerProtocol) {
        self.container = container
        container.inject(self)
    }
}
