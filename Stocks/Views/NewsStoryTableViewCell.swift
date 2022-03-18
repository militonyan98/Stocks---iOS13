//
//  NewsStoryTableViewCell.swift
//  Stocks
//
//  Created by Hermine M on 08/03/2022.
//
import SDWebImage
import UIKit

class NewsStoryTableViewCell: UITableViewCell {
    
    static let identifier = "NewsStoryTableViewCell"
    
    static let preferredHeight: CGFloat = 140
    
    struct ViewModel {
        let source: String
        let headline: String
        let dateString: String
        let imageURL: URL?
        
        init(model: NewsStory) {
            self.source = model.source
            self.headline = model.headline
            self.dateString = String.string(from: model.datetime)
            self.imageURL = URL(string: model.image)
        }
    }
    
    //source
    private let sourceLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    //headline
    private let headlineLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    //date
    private let dateLable: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    //image
    private let storyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .tertiarySystemBackground
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
        backgroundColor = .secondarySystemBackground
        addSubviews(sourceLable, headlineLable, dateLable, storyImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = contentView.height / 1.4
        storyImageView.frame = CGRect(x: contentView.width-imageSize - 10, y: (contentView.height - imageSize) / 2, width: imageSize, height: imageSize)
        
        //label layout
        let availableWidth: CGFloat = contentView.width - separatorInset.left - imageSize - 15
        dateLable.frame = CGRect(x: separatorInset.left, y: contentView.height - 40, width: availableWidth, height: 40)
        
        //source label
        sourceLable.sizeToFit()
        sourceLable.frame = CGRect(x: separatorInset.left, y: 4, width: availableWidth, height: sourceLable.height)
        
        //headline label
        headlineLable.frame = CGRect(x: separatorInset.left, y: sourceLable.bottom + 5, width: availableWidth, height: contentView.height - sourceLable.bottom - dateLable.height - 10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sourceLable.text = nil
        headlineLable.text = nil
        dateLable.text = nil
        storyImageView.image = nil
    }
    
    public func configure(with viewModel: ViewModel) {
        headlineLable.text = viewModel.headline
        sourceLable.text = viewModel.source
        dateLable.text = viewModel.dateString
        storyImageView.sd_setImage(with: viewModel.imageURL, completed: nil)
        //manually set image
        //storyImageView.setImage(with: viewModel.imageURL)
    }
}
