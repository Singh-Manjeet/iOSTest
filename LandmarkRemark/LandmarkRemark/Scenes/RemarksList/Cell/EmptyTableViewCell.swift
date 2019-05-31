//
//  EmptyTableViewCell.swift
//  LandmarkRemark
//
//  Created by Manjeet Singh on 31/5/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit

private struct Design {
    static let errorMessage = "There are no remarks added."
    static let cellPadding: CGFloat = 13.0
}

class EmptyTableViewCell: UITableViewCell, Reusable {
    
    // MARK: - Vars
    
    @IBOutlet private var titleLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        titleLabel.text = Design.errorMessage
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



