//
//  LibraryViewController.swift
//  SPOTIFY
//
//  Created by milad marandi on 1/13/24.
//

import UIKit

class LibraryViewController: UIViewController {

    let ScrollView:UIScrollView = {
       let scroll = UIScrollView()
       return scroll
    }()
    
    private let Playlist = LibraryPlayListsViewController()
    private let Album = LibraryAlbumViewController()
    private let Options = LibraryToggleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        ScrollView.contentSize = CGSize(width: view.frame.width * 2, height: ScrollView.frame.height)
        ScrollView.delegate = self
        ScrollView.isPagingEnabled = true
        view.addSubview(ScrollView)
        view.addSubview(Options)
        Options.delegate = self
        
        addchild()
    }
    
    override func viewDidLayoutSubviews() {
        ScrollView.frame = CGRect(origin: CGPoint(x: 0, y: view.safeAreaInsets.top + 55), size: CGSize(width: view.frame.width, height: view.frame.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 55))
        Options.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.width, height: ScrollView.frame.minY - view.safeAreaInsets.top)
    }
    
    private func UpdateBarButton(){
        switch Options.state{
            
        case .Albums:
            navigationItem.rightBarButtonItem = nil
        case .Playlist:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.add, target: self, action: #selector(didTapAdd))
        }
    }
    
    @objc func didTapAdd(){
        Playlist.ShowAlertToCreatePlaylist()
    }
    
    private func addchild(){
        
        addChild(Playlist)
        addChild(Album)
        
        ScrollView.addSubview(Playlist.view)
        ScrollView.addSubview(Album.view)
        
        Playlist.view.frame = CGRect(x: 0, y: 0, width: ScrollView.frame.width, height: ScrollView.frame.height)
        
        Album.view.frame = CGRect(x: view.frame.width, y: 0, width: ScrollView.frame.width, height: ScrollView.frame.height)
        
        Playlist.didMove(toParent: self)
        Album.didMove(toParent: self)
    }
    

}


extension LibraryViewController:UIScrollViewDelegate , LibraryToggleViewDelegate{
    func LibraryToggleViewdidTapPlaylist(_ view: LibraryToggleView) {
        ScrollView.setContentOffset(.zero, animated: true)
        UpdateBarButton()
    }
    
    func LibraryToggleViewdidTapAlbum(_ view: LibraryToggleView) {
        ScrollView.setContentOffset(CGPoint(x: view.frame.width, y: 0), animated: true)
        UpdateBarButton()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= view.frame.width - 100 {
            Options.update(.Albums)
            UpdateBarButton()
        }
        else{
            Options.update(.Playlist)
            UpdateBarButton()
        }
    }
    
}
