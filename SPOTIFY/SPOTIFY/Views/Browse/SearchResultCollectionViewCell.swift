//
//  SearchResultCollectionViewCell.swift
//  SPOTIFY
//
//  Created by milad marandi on 3/14/24.
//

import UIKit

#warning("move this file later")

class SearchViewControllerCollectionViewCell: UICollectionViewCell {
    
    static let identifier:String = "SearchViewControllerCollectionViewCell"
    
    private let ImageView:UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.tintColor = .white
        imageview.image = UIImage(systemName: "music.quarternote.3" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
        return imageview
    }()
    
    private let Label:UILabel = {
       
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
        
    }()
    
    
    let colors:[UIColor] = [
        .systemBlue,
        .systemGreen,
        .systemPurple,
        .systemGray,
        .systemPink,
        .systemOrange
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = colors.randomElement()
        contentView.addSubview(Label)
        contentView.addSubview(ImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        Label.text = "loading"
        ImageView.image = UIImage(systemName: "music.quarternote.3" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.Label.frame = CGRect(x: 10, y: contentView.frame.height/2, width: contentView.frame.width-20, height: contentView.frame.height/2)
        self.ImageView.frame = CGRect(x: contentView.frame.width/2, y: 0, width: contentView.frame.width/2, height: contentView.frame.height/2)
    }
    
    func configure(with model: CategoryCollectionViewcellModel){
        Label.text = model.name
        ImageView.sd_setImage(with: model.image, completed: nil)
    }
    
}
