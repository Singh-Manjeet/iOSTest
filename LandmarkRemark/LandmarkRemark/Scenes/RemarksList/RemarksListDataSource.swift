//
//  RemarksListDataSource.swift
//  LandmarkRemark
//
//  Created by Manjeet Singh on 31/5/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit
import RealmSwift

// MARK: - Data Container

struct RemarksContainer {
    let remarks: Results<Remark>
}

// MARK: - Cell Type

enum RemarkCellType {
    case remarks(Remark)
    case empty
}

enum RemarksViewMode {
    case search(Results<Remark>?)
    case normal
}

// MARK: - DataSource Protocol

protocol RemarksListDataSourceProtocol {
    var state: ViewControllerDataState<RemarksContainer> { get set }
    func cellType(at indexPath: IndexPath) -> RemarkCellType
    func registerCells(for tableView: UITableView)
}

typealias ViewControllerDataState<T> = DataState<T, NSError>

// MARK: - View Controller DataSource

class RemarksListDataSource: NSObject, RemarksListDataSourceProtocol {
    
    // MARK: - Vars
    
    var mode: RemarksViewMode = .normal
    var state: ViewControllerDataState<RemarksContainer>  = .loading {
        didSet {
            cellTypes = buildCellTypes()
        }
    }
    
    private var cellTypes: [RemarkCellType] = []
    
    init(for tableView: UITableView) {
        super.init()
        tableView.dataSource = self
        registerCells(for: tableView)
    }
    
    func cellType(at indexPath: IndexPath) -> RemarkCellType {
        return cellTypes[indexPath.row]
    }
    
    func registerCells(for tableView: UITableView) {
        tableView.register(EmptyTableViewCell.self)
    }
}

// MARK: - TableView DataSource

extension RemarksListDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch mode {
        case .normal:
            return cellTypes.count
        case .search(let searchedResults):
            guard let searched = searchedResults else { return cellTypes.count }
            return searched.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellTypeAtIndex = cellType(at: indexPath)
        
        switch cellTypeAtIndex {
        case .remarks(let remark):
            let remarkCell: RemarkTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            
            switch mode {
            case .normal:
                remarkCell.populate(with: remark)
            case .search(let searchedResults):
                guard let remarkInSearchResults = searchedResults else {
                    remarkCell.populate(with: remark)
                    return remarkCell
                }
                
                remarkCell.populate(with: remarkInSearchResults[indexPath.row] as Remark)
            }
            
            return remarkCell
        case .empty:
            let emptyCell: EmptyTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            return emptyCell
        }
    }
}

// MARK: - Cell Builder

private extension RemarksListDataSource {
    func buildCellTypes() -> [RemarkCellType] {
        
        switch state {
        case .loading: break
        case .loaded(let container):
            cellTypes.removeAll()
            guard !container.remarks.isEmpty else {
                cellTypes.append(.empty)
                return cellTypes
            }
            
            for remark in container.remarks {
                let cellType = RemarkCellType.remarks(remark)
                cellTypes.append(cellType)
            }
        case .error:
            cellTypes.removeAll()
            cellTypes.append(.empty)
        }
        
        return cellTypes
    }
}
