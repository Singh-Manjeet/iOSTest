//
//  RemarkTableViewCell.swift
//  LandmarkRemark
//
//  Created by Manjeet Singh on 31/5/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit

class RemarkTableViewCell: UITableViewCell, Reusable {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /**
     * To populate the cell with Remark
     * Parameters: Remark
     */
    
    func populate(with remark: Remark) {
        updateUI(with: remark)
    }
}

// MARK: - Private Helpers
private extension RemarkTableViewCell {
    
    func updateUI(with remark: Remark) {
        
        titleLabel.text = remark.title
        detailLabel.text = remark.detail
        usernameLabel.text = remark.username
    }
}
