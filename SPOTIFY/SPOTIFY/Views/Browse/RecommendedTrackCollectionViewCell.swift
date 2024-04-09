//
//  RecommendedTrackCollectionViewCell.swift
//  SPOTIFY
//
//  Created by milad marandi on 2/21/24.
//

import UIKit

class RecommendedTrackCollectionViewCell: UICollectionViewCell {
    
    static let identifier:String = "RecommendedTrackCollectionViewCell"
    
    
    private let albumcoverAlbumImageView: UIImageView = {
       let cover = UIImageView()
        cover.image = UIImage(systemName: "photo")
        cover.contentMode = .scaleAspectFill
        return cover
    }()
    
    private let tracknameLabel:UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
        
    }()
    
    
    
    
    private let ArtistNameLabel:UILabel = {
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.numberOfLines = 1
        return label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumcoverAlbumImageView)
        contentView.addSubview(ArtistNameLabel)
        contentView.clipsToBounds = true
        contentView.addSubview(tracknameLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        albumcoverAlbumImageView.frame =  CGRect(x: 5, y: 2, width: contentView.frame.height - 4, height: contentView.frame.height - 4)
        
        
        tracknameLabel.frame =  CGRect(x: albumcoverAlbumImageView.frame.maxX + 10 , y: 10 , width: contentView.frame.width - albumcoverAlbumImageView.frame.maxX - 15, height: 20)
        
        ArtistNameLabel.frame = CGRect(x: albumcoverAlbumImageView.frame.maxX + 10, y: 30, width: contentView.frame.width, height: contentView.frame.height/2)
        
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        tracknameLabel.text = nil
        ArtistNameLabel.text = nil
        albumcoverAlbumImageView.image = nil
    }
    
    func configure(with viewmodel: RecommnededCellViewModel){
        tracknameLabel.text = viewmodel.name
        ArtistNameLabel.text = viewmodel.artistName
        albumcoverAlbumImageView.sd_setImage(with: viewmodel.artworkURL, completed: nil)
    }
}
