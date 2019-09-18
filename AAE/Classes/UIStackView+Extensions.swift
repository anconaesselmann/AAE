//  Created by Axel Ancona Esselmann on 3/03/18.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import UIKit

#if os(iOS)
public extension UIStackView {

    /// Creates a grid of equally sized and spaced elements
    convenience init(views: [UIView], numberElementsInRow: Int, interElementSpacing: CGFloat = 0.0) {
        self.init(frame: .zero)
        axis = .vertical
        distribution = .equalSpacing
        alignment = .fill
        spacing = interElementSpacing

        func emptyRow() -> UIStackView {
            let rowView = UIStackView()
            rowView.axis = .horizontal
            rowView.distribution = .fillEqually
            rowView.alignment = .fill
            rowView.spacing = interElementSpacing
            return rowView
        }

        var currentRow: [UIView] = []
        for individualView in views {
            currentRow.append(individualView)
            guard currentRow.count >= numberElementsInRow else {
                continue
            }
            let rowView = emptyRow()

            for rowElement in currentRow {
                rowView.addArrangedSubview(rowElement)
            }
            currentRow = []
            addArrangedSubview(rowView)
        }
        if !currentRow.isEmpty {
            let numberOfEmptyColumns = numberElementsInRow - currentRow.count

            let lastRow = emptyRow()
            for lastRowElement in currentRow {
                lastRow.addArrangedSubview(lastRowElement)
            }
            for _ in 0..<numberOfEmptyColumns {
                let emptyView = UIView()
                lastRow.addArrangedSubview(emptyView)
            }
            addArrangedSubview(lastRow)
        }
    }
}

public extension UIStackView {
    
    /// Creates a vertical stack view with optional separator views
    convenience init(views: [UIView], separatorCreator: (() -> UIView)? = nil, interRowSpacing: CGFloat = 0.0) {
        self.init(frame: .zero)
        axis = .vertical
        alignment = .fill
        spacing = interRowSpacing

        for view in views {
            if arrangedSubviews.count > 0, let separator = separatorCreator?() {
                addArrangedSubview(separator)
            }
            addArrangedSubview(view)
        }
    }
}
#endif
