//
//  NewsHeaderView.swift
//  Stocks
//
//  Created by Hermine M on 08/03/2022.
//

import UIKit

/// Delegate to notify of header events
protocol NewsHeaderViewDelegate: AnyObject {
    /// Notifies that user tapped header button
    /// - Parameter headerView: Reference of header view
    func newsHeaderViewDidTapAddButton(_ headerView: NewsHeaderView)
}

/// TableView header for news
final class NewsHeaderView: UITableViewHeaderFooterView {
    /// Header identifier
    static let identifier = "NewsHeaderView"
    
    /// Ideal height of header
    static let preferredHeight: CGFloat = 70
    
    /// Delegate instance for events
    weak var delegate: NewsHeaderViewDelegate?
    
    /// View model for header view
    struct ViewModel {
        let title: String
        let shouldShowAddButton: Bool
    }
    
    
    // MARK: - Private
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 32)
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("+ Watchlist", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    
    // MARK: - Init
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(label, button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    // MARK: - Private
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 14, y: 0, width: contentView.width-28, height: contentView.height)
        button.sizeToFit()
        button.frame = CGRect(x: contentView.width-button.width-16, y: (contentView.height-button.height)/2, width: button.width+8, height: button.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    /// Handle button tap
    @objc private func didTapButton() {
        //call delegate
        delegate?.newsHeaderViewDidTapAddButton(self)
    }
    
    
    // MARK: - Public
    
    /// Configure view
    /// - Parameter viewModel: View ViewModel
    public func configure(with viewModel: ViewModel) {
        label.text = viewModel.title
        button.isHidden = !viewModel.shouldShowAddButton
    }
}
