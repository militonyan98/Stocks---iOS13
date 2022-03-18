//
//  SearchResultsViewController.swift
//  Stocks
//
//  Created by Hermine M on 02/03/2022.
//

import UIKit

/// Delegate for search results
protocol SearchResultsViewControllerDelegate: AnyObject {
    /// Notifies delegate of selection
    /// - Parameter searchResult: Result that was picked
    func searchResultsViewControllerDidSelect(searchResult: SearchResult)
}


/// VC to show search results
final class SearchResultsViewController: UIViewController {
    /// Delegate to get events
    weak var delegate: SearchResultsViewControllerDelegate?
    
    /// Collection of results
    private var results: [SearchResult] = []
    
    /// Primary view
    private let tableView: UITableView = {
        let table = UITableView()
        //regiter a cell
        table.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        
        table.isHidden = true
        
        return table
    }()

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpTable()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    
    // MARK: - Private
    
    /// Sets up table view
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    // MARK: - Public
    
    /// Updates results on VC
    /// - Parameter results: Collection of news results
    public func update(with results: [SearchResult]) {
        self.results = results
        tableView.isHidden = results.isEmpty
        tableView.reloadData()
    }
}


// MARK: - TableView

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath)
        
        let model = results[indexPath.row]
        
        cell.textLabel?.text = model.displaySymbol
        cell.detailTextLabel?.text = model.description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = results[indexPath.row]
        delegate?.searchResultsViewControllerDidSelect(searchResult: model)
    }
}
