//
//  SearchResultTableViewCell.swift
//  Stocks
//
//  Created by Hermine M on 03/03/2022.
//

import UIKit

/// Table view cell for search result
final class SearchResultTableViewCell: UITableViewCell {
    /// Identifier for cell
    static let identifier = "SearchResultTableViewCell"
    
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
