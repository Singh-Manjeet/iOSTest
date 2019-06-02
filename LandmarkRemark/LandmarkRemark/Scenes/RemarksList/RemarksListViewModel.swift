//
//  RemarksListViewModel.swift
//  LandmarkRemark
//
//  Created by Manjeet Singh on 31/5/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import Foundation
import RealmSwift

private struct Design {
    static let noTitle = "Anonymous"
    static let noInternet = "Please check your internet and try again."
}

// MARK: - RemarksListViewModelDelegate

protocol RemarksListViewModelDelegate: class {
    func stateDidChange(_ state: ViewControllerDataState<RemarksContainer>)
}

final class RemarksListViewModel {
    weak var delegate: RemarksListViewModelDelegate?
    
    // MARK: - LifeCycle
    
    init(delegate: RemarksListViewModelDelegate? = nil) {
        self.delegate = delegate
    }
    
    private(set) var state: ViewControllerDataState<RemarksContainer> = .loading {
        didSet {
            delegate?.stateDidChange(state)
        }
    }
    
    // MARK: - Public Function
    
    func fetchRemarks() {
        
        guard Reachability.isConnectedToNetwork() else {
            self.state = .error(NSError(domain: Design.noInternet, code: 0, userInfo: nil))
            return
        }
        
        let remarks = DataManager.sharedInstance.getRemarksFromDatabase()
        let container = RemarksContainer(remarks: remarks)
        state = .loaded(container)
    }
    
    //Used for unit test
    func fetchRemarksForTesting() -> DataState<Results<Remark>, Error> {
        
        guard Reachability.isConnectedToNetwork() else {
            return .error(NSError(domain: Design.noInternet, code: 0, userInfo: nil))
        }
        
        let remarks = DataManager.sharedInstance.getRemarksFromDatabase()
        return .loaded(remarks)
    }
}
