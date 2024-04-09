//
//  SearchResultSubtitleTableViewCell.swift
//  SPOTIFY
//
//  Created by milad marandi on 3/22/24.
//

import UIKit
import SDWebImage

class SearchResultSubtitleTableViewCell: UITableViewCell {

    static let identifier:String = "SearchResultSubtitleTableViewCell"
    
    let ImageView:UIImageView = {
        let imageview = UIImageView()
        return imageview
    }()
    
    let subtitle:UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        return label
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
        contentView.addSubview(subtitle)
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
        subtitle.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        ImageView.frame = CGRect(x: 10, y: 0, width: contentView.frame.height, height: contentView.frame.height)
        name.frame = CGRect(x: ImageView.frame.maxX + 10, y: 0, width: contentView.frame.width - ImageView.frame.maxX - 15, height: contentView.frame.height/2)
        subtitle.frame = CGRect(x: ImageView.frame.maxX + 10, y: name.frame.maxY, width: contentView.frame.width - ImageView.frame.maxX - 15, height: contentView.frame.height/2)
    }
    
    public func configure(with viewmodel:SearchResultSubtitleTableViewModel){
        ImageView.sd_setImage(with: viewmodel.imageURL,placeholderImage: UIImage(systemName: "photo"), completed: nil)
        name.text = viewmodel.title
        subtitle.text = viewmodel.subtitle
    }

}
