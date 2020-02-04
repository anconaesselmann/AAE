//  Created by Axel Ancona Esselmann on 2/4/20.
//

import UIKit

public struct TableStyle {
    public var tableFooterView: UIView?
    public var rowHeight: CGFloat?
    public var estimatedRowHeight: CGFloat?
    public var backgroundColor: UIColor?

    public init(
        tableFooterView: UIView?,
        rowHeight: CGFloat?,
        estimatedRowHeight: CGFloat?,
        backgroundColor: UIColor?
    ) {
        self.tableFooterView = tableFooterView
        self.rowHeight = rowHeight
        self.estimatedRowHeight = estimatedRowHeight
        self.backgroundColor = backgroundColor
    }
}

extension UITableView {
    public convenience init(delegate: UITableViewDelegate, dataSource: UITableViewDataSource, style: TableStyle? = nil) {
        self.init()
        self.delegate = delegate
        self.dataSource = dataSource
        if let style = style {
            self.style(style)
        }
    }

    public func style(_ style: TableStyle) {
        if let tableFooterView = style.tableFooterView {
            self.tableFooterView = tableFooterView
        }
        if let rowHeight = style.rowHeight {
            self.rowHeight = rowHeight
        }
        if let estimatedRowHeight = style.estimatedRowHeight {
            self.estimatedRowHeight = estimatedRowHeight
        }
        if let backgroundColor = style.backgroundColor {
            self.backgroundColor = backgroundColor
        }
    }
}
