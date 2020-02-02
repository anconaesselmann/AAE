//  Created by Axel Ancona Esselmann on 9/11/19.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

#if os(iOS)

import UIKit
import RxSwift
import RxOptional

public extension UITextField {
    // https://stackoverflow.com/questions/25367502/create-space-at-the-beginning-of-a-uitextfield#40636808
    func setLeftPadding(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }

    func setRightPadding(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }

    func setPadding(_ amount:CGFloat) {
        setLeftPadding(amount)
        setRightPadding(amount)
    }
}

public extension UITextField {
    var editingDidEnd: Observable<String?> {
        return rx
            .controlEvent([.editingDidEnd])
            .withLatestFrom(rx.text)
            .asObservable()
    }
}

public extension UITextField {
    convenience init(placeholder: String) {
        self.init(frame: CGRect.zero)
        self.placeholder = placeholder
    }
}

#endif
