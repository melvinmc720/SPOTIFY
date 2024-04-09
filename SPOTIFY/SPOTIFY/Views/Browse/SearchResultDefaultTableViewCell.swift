//
//  SearchResultDefaultTableViewCell.swift
//  SPOTIFY
//
//  Created by milad marandi on 3/22/24.
//

import UIKit
import SDWebImage

class SearchResultDefaultTableViewCell: UITableViewCell {
    
    static let identifier:String = "SearchResultDefaultTableViewCell"
    
    let ImageView:UIImageView = {
        let imageview = UIImageView()
        return imageview
    }()
    
    let name:UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(ImageView)
        contentView.addSubview(name)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        ImageView.image = nil
        name.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        ImageView.frame = CGRect(x: 10, y: 0, width: contentView.frame.height, height: contentView.frame.height)
        name.frame = CGRect(x: ImageView.frame.maxX + 10, y: 0, width: contentView.frame.width - ImageView.frame.maxX - 15, height: contentView.frame.height)
    }
    
    public func configure(with viewmodel:SearchResultDefaultTableViewModel){
        ImageView.sd_setImage(with: viewmodel.imageURL, completed: nil)
        name.text = viewmodel.title
    }
}
