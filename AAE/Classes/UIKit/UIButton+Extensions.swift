//  Created by Axel Ancona Esselmann on 9/11/19.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

#if os(iOS)

public extension UIButton {
    convenience init(title: String, titleColor: UIColor? = nil) {
        self.init(frame: CGRect.zero)
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
    }

    func setImage(_ image: UIImage, withMargins margins: CGFloat) {
        setImage(image, for: .normal)
        contentVerticalAlignment = .fill
        contentHorizontalAlignment = .fill
        imageEdgeInsets = UIEdgeInsets(
            top: margins,
            left: margins,
            bottom: margins,
            right: margins)
    }
}

extension Reactive where Base : UIButton {
    public var tapped: Observable<Void> {
        return tap.map { _ in }
    }
}

#endif
