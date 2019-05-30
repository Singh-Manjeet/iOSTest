//
//  AddRemarkViewModel.swift
//  LandmarkRemark
//
//  Created by Manjeet Singh on 30/5/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import Foundation

enum Mode {
    case add
    case delete
}

class AddRemarkViewModel {
    
    func updateRemarkDatabase(with remark: Remark, mode: Mode) {
       
        switch mode {
        case .add:
            DataManager.sharedInstance.addRemark(object: remark)
        case .delete:
            DataManager.sharedInstance.deleteFromDatabase(object: remark)
        }
    }
}
