//
//  AlbumViewController.swift
//  SPOTIFY
//
//  Created by milad marandi on 3/5/24.
//

import UIKit

class AlbumViewController: UIViewController {

    private var album:Album
    private var ViewModels = [RecommnededCellViewModel]()
    private var tracks =  [AudioTrack]()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = album.name
        view.backgroundColor = .systemBackground
        
        
        view.addSubview(CollectionView)
        CollectionView.frame = view.frame
        CollectionView.delegate = self
        CollectionView.dataSource = self
        CollectionView.register(AlbumHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AlbumHeaderCollectionReusableView.identifier)
        CollectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        
        fetchData()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapActions))
    }
    
    @objc func didTapActions(){
        let ActionSheet = UIAlertController(title: album.name, message: "would you like to add this album to your playlist?", preferredStyle: .actionSheet)
        
        ActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ActionSheet.addAction(UIAlertAction(title: "Add Album", style: .default, handler:{ [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            APICaller.share.SaveAlbum(Album: strongSelf.album) { success in
                if success{
                    HapticsManager.shared.vibrate(for: .success)
                    NotificationCenter.default.post(name: NSNotification.Name.AlbumNotification, object: nil)
                }
                else{
                    HapticsManager.shared.vibrate(for: .error)
                }
                
            }
        }))
        
        present(ActionSheet, animated: true)
    }
    private func fetchData(){
        APICaller.share.getAlbumDetail(for: album, completion: { result in
            
            DispatchQueue.main.async {[self] in
                switch result{
                case .success(let data):
                    self.tracks = data.tracks.items
                    self.ViewModels = data.tracks.items.compactMap({ item in
                        
                        return RecommnededCellViewModel(name: item.name, artistName: item.artists.first?.name ?? " ", artworkURL: URL(string: album.images.first?.url ?? " "))
                    })
                    self.CollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
            
            
        })
    }
    
     init(album:Album){
         
         self.album = album
         super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension AlbumViewController:UICollectionViewDelegate , UICollectionViewDataSource{
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
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AlbumHeaderCollectionReusableView.identifier, for: indexPath) as? AlbumHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        let headerViewmodel = AlbumHeaderViewViewModel(name:album.name, Ownername: album.artists.first?.name, Description: album.release_date, artWork: URL(string: album.images.first?.url ?? " "))
        header.configure(with:headerViewmodel)
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let track = self.tracks[indexPath.row]
        PlaybackPresenter.shared.startPlayback(from: self, track: track)
    }
}


extension AlbumViewController:AlbumHeaderCollectionReusableViewDelegate{
    func AlbumHeaderCollectionReusableViewDidTapPlayA11(_ header: AlbumHeaderCollectionReusableView) {
        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracks)
    }
    
    
}
