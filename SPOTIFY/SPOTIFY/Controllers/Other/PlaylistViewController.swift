//
//  PlaylistViewController.swift
//  SPOTIFY
//
//  Created by milad marandi on 1/13/24.
//

import UIKit

class PlaylistViewController: UIViewController {

    private var Playlist:playlist
    private var tracks = [AudioTrack]()
    public var isOwner:Bool = false
    
    private var CollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection in
            
            let item = NSCollectionLayoutItem(layoutSize:  NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            //Group
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80)), repeatingSubitem: item, count: 3)
      
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            
            ]
            return section
            
        }))
    
    private var ViewModels = [RecommnededCellViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Playlist.name
        view.backgroundColor = .systemBackground
        view.addSubview(CollectionView)
        CollectionView.frame = view.frame
        CollectionView.delegate = self
        CollectionView.dataSource = self
        CollectionView.register(PlaylistHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        CollectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        
        APICaller.share.getPlaylistDetail(for: Playlist, completion: { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let model):
                    self.tracks = model.tracks.items.compactMap({$0.track})
                    self.ViewModels = model.tracks.items.compactMap({ item in
                        
                        return RecommnededCellViewModel(name: item.track.name, artistName: item.track.artists.first?.name ?? "-", artworkURL: URL(string: item.track.album?.images.first?.url ?? ""))
                    })
                    self.CollectionView.reloadData()
                   
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        })
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapshare))
        
        if isOwner
        {
            let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress))
            self.CollectionView.addGestureRecognizer(gesture)
            
        }
        

    }
    
    @objc func didLongPress(_ gesture:UILongPressGestureRecognizer){
        guard gesture.state == .began else {
            return
        }
        
        let touchpoint = gesture.location(in: CollectionView)
        
        guard let indexPath = CollectionView.indexPathForItem(at: touchpoint) else {
            return
        }
        
        let trackTodelete = tracks[indexPath.row]
        
        let ActionSheet = UIAlertController(title: trackTodelete.name, message: "would you like to remove this track from the playlist?", preferredStyle: .actionSheet)
        ActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        ActionSheet.addAction(UIAlertAction(title: "Remove", style: .destructive, handler:{_ in
            
            APICaller.share.removeTrackFromPlaylist(track:trackTodelete , Playlist: self.Playlist, completion: { success in
                DispatchQueue.main.async {
                    if success {
                        self.tracks.remove(at: indexPath.row)
                        self.ViewModels.remove(at: indexPath.row)
                        self.CollectionView.reloadData()
                    }
                }
            })
        }))
        
        present(ActionSheet, animated: true, completion: nil)
        
    }
                
    @objc func didTapshare(){
        guard let url = URL(string: Playlist.external_urls["spotify"] ?? " ") else {
            return
        }
        let vc = UIActivityViewController(activityItems: ["Check out this cool playlist I found" , url], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc , animated: true)
    }
    
     init(Playlist:playlist){
         
         self.Playlist = Playlist
         super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension PlaylistViewController:UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as? RecommendedTrackCollectionViewCell else{
            print("error")
            return UICollectionViewCell()
            
        }
        
        cell.backgroundColor = .systemBackground
        cell.configure(with: ViewModels[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier, for: indexPath) as? PlaylistHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        let headerViewmodel = PlaylistHeaderViewViewModel(name:Playlist.name, Ownername: Playlist.owner.display_name, Description: Playlist.description, artWork: URL(string: Playlist.images?.first?.url ?? " "))
        header.configure(with:headerViewmodel)
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let track = tracks[indexPath.row]
        PlaybackPresenter.shared.startPlayback(from: self, track: track)
    }
    
    
}

extension PlaylistViewController:PlaylistHeaderCollectionReusableViewDelegate{
    func playlistHeaderCollectionReusableViewDidTapPlayA11(_ header: PlaylistHeaderCollectionReusableView) {
        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracks)
    }
    
}
