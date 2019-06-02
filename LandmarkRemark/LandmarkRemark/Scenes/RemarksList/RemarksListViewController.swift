//
//  RemarksListViewController.swift
//  LandmarkRemark
//
//  Created by Manjeet Singh on 31/5/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit
import RealmSwift

private enum SearchScope: String, CaseIterable {
    case username = "username"
    case title = "title"
    case detail = "detail"
    
    static func value(forIndex index: Int) -> SearchScope {
        
        switch index {
        case 0:
            return .username
        case 1:
            return .title
        case 2:
            return .detail
        default:
            return .username
        }
    }
}

// MARK: - Design Constants

private struct Design {
    static let estimatedTableViewCellHeight: CGFloat = 44.0
}

class RemarksListViewController: UITableViewController {
    
    // MARK: - Vars
    
    private var viewModel: RemarksListViewModel!
    private var dataSource: RemarksListDataSource!
    
    private var searchController: UISearchController!
    private var searchResults: Results<Remark>?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
}

// MARK: - RemarksListViewModelDelegate

extension RemarksListViewController: RemarksListViewModelDelegate {
    func stateDidChange(_ state: ViewControllerDataState<RemarksContainer>) {
        
        refreshControl?.endRefreshing()
        dataSource.state = state
        
        switch state {
        case .loaded, .loading: break
        case .error(let error):
            presentError(with: error.domain)
        }
        
        tableView.reloadData()
        tableView.layoutIfNeeded()
    }
    
}

extension RemarksListViewController: RemarksListDataSourceDelegate {
    func refreshTableView() {
        viewModel.fetchRemarks()
        tableView.reloadData()
    }
}

// MARK: - UISearchResultsUpdating

extension RemarksListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(for: searchController.searchBar.text, scopeIndex: searchController.searchBar.selectedScopeButtonIndex)
    }
}

// MARK: - UISearchBarDelegate

extension RemarksListViewController:  UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContent(for: searchBar.text, scopeIndex: selectedScope)
    }
}

// MARK: - Helper Functions

private extension RemarksListViewController {
    func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Design.estimatedTableViewCellHeight
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView()
        tableView.sectionFooterHeight = CGFloat.leastNonzeroMagnitude
        
        navigationController?.navigationBar.tintColor = .white
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = UIColor(red: 25.0/255.0,
                                                          green: 198.0/255.0,
                                                          blue: 1.0,
                                                          alpha: 1.0)
        
        // Setup the Scope Bar
        var allCaseRawValues = [String]()
        for scope in SearchScope.allCases.enumerated() {
            allCaseRawValues.append(scope.element.rawValue.capitalized)
        }
        
        searchController.searchBar.scopeButtonTitles = allCaseRawValues
        searchController.searchBar.delegate = self
        
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
    
    func setupDataSource() {
        viewModel = RemarksListViewModel(delegate: self)
        dataSource = RemarksListDataSource(for: tableView, delegate: self)
    }
    
    func presentError(with message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    @objc func didReloadRefreshControl(_ sender: UIRefreshControl) {
        fetchData()
    }
    
    func fetchData() {
        viewModel.fetchRemarks()
    }
    
    func filterContent(for searchText: String?, scopeIndex: Int) {
        
        guard let textToSearch = searchText,
              !textToSearch.isEmpty else {
                dataSource.mode = .normal
                tableView.reloadData()
                return
        }
        
        let selectedScope = SearchScope.value(forIndex: scopeIndex)
        var predicate: NSPredicate!
        
        switch selectedScope {
        case .title:
            predicate = NSPredicate(format: "title BEGINSWITH [c]%@", textToSearch)
        case .username:
            predicate = NSPredicate(format: "username BEGINSWITH [c]%@", textToSearch)
        case .detail:
            predicate = NSPredicate(format: "detail CONTAINS [c]%@", textToSearch)
        }
        
        let remarks = DataManager.sharedInstance.getRemarksFromDatabase()
        
        searchResults = remarks.filter(predicate).sorted(byKeyPath: selectedScope.rawValue.lowercased(), ascending: true)
        dataSource.mode = .search(searchResults)
        tableView.reloadData()
    }
}

