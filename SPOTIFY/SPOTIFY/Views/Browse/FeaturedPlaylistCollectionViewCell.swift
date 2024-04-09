//
//  FeaturedPlaylistCollectionViewCell.swift
//  SPOTIFY
//
//  Created by milad marandi on 2/21/24.
//

import UIKit

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier:String = "FeaturedPlaylistCollectionViewCell"
    
    
    private let PlaylistcoverAlbumImageView: UIImageView = {
       let cover = UIImageView()
        cover.image = UIImage(systemName: "photo")
        cover.layer.masksToBounds = true
        cover.layer.cornerRadius = 8
        cover.contentMode = .scaleAspectFill
        return cover
    }()
    
    private let PlaylistAlbumLabel:UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
        
    }()
    
    
    
    
    private let PlaylistArtistNameLabel:UILabel = {
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        contentView.addSubview(PlaylistcoverAlbumImageView)
        contentView.addSubview(PlaylistArtistNameLabel)
        contentView.clipsToBounds = true
        contentView.addSubview(PlaylistAlbumLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        PlaylistArtistNameLabel.frame = CGRect(x: 3, y: contentView.frame.height - 50, width: contentView.frame.width - 6, height: 30)
        
        PlaylistAlbumLabel.frame =  CGRect(x: 3, y: contentView.frame.height - 70 , width: contentView.frame.width - 6, height: 30)
        
        let imageSize = contentView.frame.height - 70
        
        PlaylistcoverAlbumImageView.frame =  CGRect(x: (contentView.frame.width - imageSize)/2, y: 3, width: imageSize, height: imageSize)
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        PlaylistAlbumLabel.text = nil
        PlaylistArtistNameLabel.text = nil
        PlaylistcoverAlbumImageView.image = nil
    }
    
    func configure(with viewmodel: FeaturedPlaylistcellViewModel){
        PlaylistAlbumLabel.text = viewmodel.name
        PlaylistArtistNameLabel.text = viewmodel.creatorName
        PlaylistcoverAlbumImageView.sd_setImage(with: viewmodel.artworkURL, completed: nil)
    }
    
}
