//
//  NewReleaseCollectionViewCell.swift
//  SPOTIFY
//
//  Created by milad marandi on 2/21/24.
//

import UIKit
import SDWebImage

class NewReleaseCollectionViewCell: UICollectionViewCell {
    static let identifier:String = "NewReleaseCollectionViewCell"
    
    private let coverAlbumImageView: UIImageView = {
       let cover = UIImageView()
        cover.image = UIImage(systemName: "photo")
        cover.contentMode = .scaleAspectFill
        return cover
    }()
    
    private let AlbumLabel:UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
        
    }()
    
    
    private let NumberOfTrackLabel:UILabel = {
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 0
        return label
        
    }()
    
    
    private let ArtistNameLabel:UILabel = {
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(coverAlbumImageView)
        contentView.addSubview(ArtistNameLabel)
        contentView.addSubview(NumberOfTrackLabel)
        contentView.clipsToBounds = true
        contentView.addSubview(AlbumLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imagesize :CGFloat = contentView.frame.height - 10
        let albumLabelsize = AlbumLabel.sizeThatFits(CGSize(width: contentView.frame.width - imagesize - 10, height: contentView.frame.height - imagesize - 10))
        
        NumberOfTrackLabel.sizeToFit()
        ArtistNameLabel.sizeToFit()
        
        coverAlbumImageView.frame = CGRect(x: 5, y: 5, width: imagesize, height: imagesize)
        
        let albumLabelHeight = min(80 , albumLabelsize.height)
        
        AlbumLabel.frame = CGRect(x: coverAlbumImageView.frame.maxX + 10, y: 5, width: albumLabelsize.width, height:albumLabelHeight)
        
        ArtistNameLabel.frame = CGRect(x: coverAlbumImageView.frame.maxX + 10, y:AlbumLabel.frame.maxY, width: contentView.frame.width - coverAlbumImageView.frame.maxX - 10, height: 30)
        
        NumberOfTrackLabel.frame = CGRect(x: coverAlbumImageView.frame.maxX + 10, y: coverAlbumImageView.frame.maxY - 44, width: NumberOfTrackLabel.frame.width, height: 44)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        AlbumLabel.text = nil
        ArtistNameLabel.text = nil
        NumberOfTrackLabel.text = nil
        coverAlbumImageView.image = nil
    }
    
    func configure(with viewmodel: NewReleasesCellViewModel){
        AlbumLabel.text = viewmodel.name
        ArtistNameLabel.text = viewmodel.artistName
        NumberOfTrackLabel.text = String(viewmodel.numberOfTracks)
        coverAlbumImageView.sd_setImage(with: viewmodel.artworkURL, completed: nil)
    }
}
