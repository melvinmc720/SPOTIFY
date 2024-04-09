//
//  AlbumHeaderCollectionReusableView.swift
//  SPOTIFY
//
//  Created by milad marandi on 3/9/24.
//

import UIKit

protocol AlbumHeaderCollectionReusableViewDelegate:AnyObject{
    func AlbumHeaderCollectionReusableViewDidTapPlayA11(_ header:AlbumHeaderCollectionReusableView)
}


class AlbumHeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "AlbumHeaderCollectionReusableView"
    
    public var delegate: AlbumHeaderCollectionReusableViewDelegate?
    
    private var NameLabel:UILabel = {
       let label = UILabel()
        label.font  = .systemFont(ofSize: 18 , weight: .semibold)
        return label
    }()
    
    private var DescriptionLabel:UILabel = {
       let label = UILabel()
        label.textColor = .secondaryLabel
        label.font  = .systemFont(ofSize: 18 , weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    
    private var OwnerNameLabel:UILabel = {
       let label = UILabel()
        label.textColor = .secondaryLabel
        label.font  = .systemFont(ofSize: 18 , weight: .light)
        return label
    }()
    
    private var HeaderImageView:UIImageView = {
       let Imageview = UIImageView()
        Imageview.contentMode = .scaleAspectFill
        Imageview.image = UIImage(systemName: "photo")
        return Imageview
    }()
    
    private var playAllbutton:UIButton = {
       let button = UIButton()
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(DidTapPlayAll), for: .touchUpInside)
        return button
    }()
    
    @objc private func DidTapPlayAll(){
        delegate?.AlbumHeaderCollectionReusableViewDidTapPlayA11(self)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(HeaderImageView)
        addSubview(OwnerNameLabel)
        addSubview(DescriptionLabel)
        addSubview(NameLabel)
        addSubview(playAllbutton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize:CGFloat = frame.height / 1.5
        
        HeaderImageView.frame = CGRect(x: (frame.width - imageSize)/2, y: 20, width: imageSize, height: imageSize)
        //OwnerNameLabel.frame = CGRect(x: 10, y: DescriptionLabel.frame.maxY, width: frame.width - 20, height: 44)
        NameLabel.frame = CGRect(x: 10, y: HeaderImageView.frame.maxY, width: frame.width - 20, height: 44)
        DescriptionLabel.frame = CGRect(x: 10, y: NameLabel.frame.maxY, width: frame.width - 20, height: 44)
        
        playAllbutton.frame = CGRect(x: frame.width - 60 , y: frame.height - 40, width: 50, height: 50)
    }
    
    public func configure(with viewModel:AlbumHeaderViewViewModel){
        OwnerNameLabel.text = viewModel.Ownername
        DescriptionLabel.text = viewModel.Description
        NameLabel.text = viewModel.name
        HeaderImageView.sd_setImage(with:viewModel.artWork, completed: nil)
    }
}
