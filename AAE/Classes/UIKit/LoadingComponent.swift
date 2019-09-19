//  Created by Axel Ancona Esselmann on 9/14/19.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import UIKit

#if os(iOS)
open class LoadingComponent: UIViewController {

    var spinner: UIActivityIndicatorView?

    open override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 50, green: 50, blue: 50)?.withAlphaComponent(0.3)

        let spinner = UIActivityIndicatorView(style: .gray)
        self.spinner = spinner
        constrainSubview(spinner)
            .center()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        spinner?.startAnimating()
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        spinner?.startAnimating()
    }
}
#endif
