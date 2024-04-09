//
//  LibraryToggleView.swift
//  SPOTIFY
//
//  Created by milad marandi on 3/29/24.
//

import UIKit

protocol LibraryToggleViewDelegate:AnyObject{
    func LibraryToggleViewdidTapPlaylist(_ view:LibraryToggleView)
    func LibraryToggleViewdidTapAlbum(_ view:LibraryToggleView)
}

class LibraryToggleView: UIView {
    
    enum State:String{
        case Albums
        case Playlist
    }
    
    var state:State = .Playlist
    var delegate:LibraryToggleViewDelegate?
    private let AlbumButton:UIButton = {
        
        let button = UIButton()
        button.setTitle("Albums", for: .normal)
        button.addTarget(self, action: #selector(didTapAlbum), for: .touchUpInside)
        return button
    }()
    
    private let PlaylistButton:UIButton = {
        
        let button = UIButton()
        button.setTitle("Playlists", for: .normal)
        button.addTarget(self, action: #selector(didTapPlaylist), for: .touchUpInside)
        return button
    }()
    
    private let UnderLine:UIView = {
       let Line = UIView()
        Line.backgroundColor = .white
        Line.layer.masksToBounds = true
        Line.layer.cornerRadius = 5
        return Line
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(AlbumButton)
        addSubview(PlaylistButton)
        addSubview(UnderLine)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func UnderLinePosition(){
        
        switch state {
            
        case .Albums:
            
            UnderLine.frame = CGRect(x: AlbumButton.frame.minX, y: PlaylistButton.frame.maxY + 5, width: 100, height: 3)
            
        case .Playlist:
            
            UnderLine.frame = CGRect(x: 0, y: PlaylistButton.frame.maxY + 5, width: 100, height: 3)
            
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        PlaylistButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        AlbumButton.frame = CGRect(x: PlaylistButton.frame.maxX + 10, y: 0, width: 100, height: 40)
        
        UnderLinePosition()
    }
    
    @objc func didTapPlaylist(){
        self.state = .Playlist
        UIView.animate(withDuration: 0.2, animations: { [self] in
            UnderLinePosition()
        })
        delegate?.LibraryToggleViewdidTapPlaylist(self)
    }
    
    @objc func didTapAlbum(){
        self.state = .Albums
        UIView.animate(withDuration: 0.2, animations: { [self] in
            UnderLinePosition()
        })
        delegate?.LibraryToggleViewdidTapAlbum(self)
    }
    
    public func update(_ state:State){
        self.state = state
        UIView.animate(withDuration: 0.2, animations: {
            self.UnderLinePosition()
        })
    }
    

}
