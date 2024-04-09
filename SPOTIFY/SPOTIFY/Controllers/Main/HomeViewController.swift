//
//  HomeViewController.swift
//  SPOTIFY
//
//  Created by milad marandi on 1/13/24.
//

import UIKit



enum BrowseSectionType{
    
    case featured_Playlists(viewModels:[FeaturedPlaylistcellViewModel])
    case Recommended_Tracks(viewModels:[RecommnededCellViewModel])
    case New_Releases(viewModels:[NewReleasesCellViewModel])
    
    var title:String{
        switch self{
        
        case .featured_Playlists:
            return "Featured Playlists"
        case .Recommended_Tracks:
            return "Recommended Tracks"
        case .New_Releases:
            return "New Albums"
        }
    }
    
    
}

class HomeViewController: UIViewController {
   

    private var newAlbums: [Album] = []
    private var tracks:[AudioTrack] = []
    private var featuredPlaylist:[playlist] = []
    private var collectionView:UICollectionView!
    private var sections = [BrowseSectionType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTap))
        
        
        let layout = UICollectionViewCompositionalLayout{ sectionIndex, _ -> NSCollectionLayoutSection? in
            return self.createSectionLayout(index: sectionIndex)
        }
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        CollectionViewConfigure()
        fetchData()
        addLongTapGesture()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func addLongTapGesture()
    {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didTapGesture))
        collectionView.addGestureRecognizer(gesture)
    }
    
    @objc func didTapGesture(_ gesture:UILongPressGestureRecognizer){
        guard gesture.state == .began else {
            return
        }
        
        let touchpoint = gesture.location(in: collectionView)
        
        guard let indexPath = collectionView.indexPathForItem(at: touchpoint) , indexPath.section == 2 else {
            return
        }
        
        let model = tracks[indexPath.row]
        
        let actionSheet = UIAlertController(title: model.name, message: "would you like to add this to a playlist?", preferredStyle: UIAlertController.Style.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Add to playlist", style: UIAlertAction.Style.default, handler: {[weak self] _  in
            let vc = LibraryPlayListsViewController()
            vc.selectionHandler = { PLAYLIST in
                APICaller.share.addTrackToPlaylist(track: model, Playlist: PLAYLIST) { success in
                    
                    print("this playlist just added to your library: \(PLAYLIST)")
                }
                
            }
            vc.title = "Select Playlist"
            self?.present(UINavigationController(rootViewController: vc) , animated: true)
        }))
        
        present(actionSheet , animated: true)
        
    }
    private func CollectionViewConfigure(){
        view.addSubview(collectionView)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.register(NewReleaseCollectionViewCell.self, forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
        
        collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        
        collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        
        collectionView.register(HomeHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeHeaderCollectionReusableView.identifier)
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
    }
    
    
    private func createSectionLayout(index:Int) -> NSCollectionLayoutSection{
        
        
        let header = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            
            ]
        
        switch index {
        case 0:
            //Item
            let item = NSCollectionLayoutItem(layoutSize:  NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            //Group
            let verticalgroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120)), repeatingSubitem: item, count: 3)
            
            let horizontalgroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(360)), repeatingSubitem: verticalgroup, count: 1)
            //Section
            let section = NSCollectionLayoutSection(group: horizontalgroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = header
            
            return section
            
            
        case 1:
            //Item
            let item = NSCollectionLayoutItem(layoutSize:  NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(200)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            //Group
            let verticalgroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(400)), repeatingSubitem: item, count: 2)
            
            let horizontalgroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(400)), repeatingSubitem: verticalgroup, count: 1)
            //Section
            let section = NSCollectionLayoutSection(group: horizontalgroup)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = header
            return section
            
            
        case 2:
            //Item
            let item = NSCollectionLayoutItem(layoutSize:  NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            //Group
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80)), repeatingSubitem: item, count: 3)
      
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = header
            return section
            
            
            
        default:
            //Item
            let item = NSCollectionLayoutItem(layoutSize:  NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120)), repeatingSubitem: item, count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
    
    private func fetchData(){
        
        let group = DispatchGroup()
        
        group.enter()
        group.enter()
        group.enter()
        
        var featuredPlaylist : FeaturedPlaylistResponse? // Response
        //featured Playlists
        APICaller.share.getFeaturedFlaylists(completion: {result in
            defer {
                group.leave()
            }
            switch result{
            case .success(let model):
                featuredPlaylist = model
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        })
        
        
        var recommendations : RecommendationsResponse?
        //Recommended Tracks

        var newReleases: NewRelease? //Response
        
        //New Releases
        APICaller.share.GetNewRelease(completion: {result in
            defer {
                group.leave()
            }
            switch result{
            case .success(let model):
                newReleases = model
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        })
        
        
        APICaller.share.getRecommendedGenre(completion: {result in
            
            switch result{
                
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement() {
                        seeds.insert(random)
                    }
                }
                
                APICaller.share.getRecommendations(genres: seeds, completion: { recommendedResult in
                    defer {
                        group.leave()
                    }
                    
                    switch recommendedResult{
                    case .success(let model):
                        recommendations = model
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                })
                
              
                
            case .failure(let error ):

                print(error.localizedDescription)
            }
            
        })
        group.notify(queue: .main){
            guard let newAlbums = newReleases?.albums.items,let playlists = featuredPlaylist?.playlists.items , let tracks = recommendations?.tracks else{
                return
            }
            self.configureModels(newAlbums: newAlbums, tracks: tracks, featuredPlaylist: playlists)
        }
     
    }
    
    
    private func configureModels(newAlbums: [Album] , tracks:[AudioTrack] , featuredPlaylist:[playlist]){
        
        self.newAlbums = newAlbums
        self.tracks = tracks
        self.featuredPlaylist = featuredPlaylist

        
        //New_Releases
        sections.append(.New_Releases(viewModels: newAlbums.compactMap({ return NewReleasesCellViewModel(name: $0.name, artworkURL: URL(string:$0.images.first?.url ?? ""), numberOfTracks: $0.total_tracks, artistName: $0.artists.first?.name ?? "-")})))
        
        //Featured playlists
        sections.append(.featured_Playlists(viewModels: featuredPlaylist.compactMap({
            return FeaturedPlaylistcellViewModel(name: $0.name, artworkURL: URL(string:$0.images?.first?.url ?? " "), creatorName:$0.owner.display_name)
        })))
    
        
        //Recommended
        sections.append(.Recommended_Tracks(viewModels:tracks.compactMap({
            
            return RecommnededCellViewModel(name: $0.name, artistName: $0.artists.first?.name ?? "-", artworkURL: URL(string: $0.album?.images.first?.url ?? " "))
        })))
        
        
        collectionView.reloadData()
    }
    
    @objc func didTap(){
        let vc = SettingsViewController()
        vc.title = "Setting"
        navigationController?.pushViewController(vc, animated: true)
    }
    

}


extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let section = sections[indexPath.section]
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeHeaderCollectionReusableView.identifier, for: indexPath) as? HomeHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        
        
        header.configure(title: section.title)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type{
        case .New_Releases(let viewModels):
            return viewModels.count
        case .Recommended_Tracks(let viewModels):
            return viewModels.count
        case .featured_Playlists(let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        let section = sections[indexPath.section]
        
        switch section{
            
        case .New_Releases:
            
            let album = newAlbums[indexPath.row]
            let vc = AlbumViewController(album:album)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
        case .featured_Playlists:
            
            let PlayList = featuredPlaylist[indexPath.row]
            let vc = PlaylistViewController(Playlist: PlayList)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
        case .Recommended_Tracks:
            let track = tracks[indexPath.row]
            PlaybackPresenter.shared.startPlayback(from: self, track: track)
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = sections[indexPath.section]
        
        switch type{

            //Featured Playlist
        case .featured_Playlists(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath) as? FeaturedPlaylistCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
            
            
        case .Recommended_Tracks(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as? RecommendedTrackCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewmodel = viewModels[indexPath.row]
            cell.configure(with: viewmodel)
            return cell
          
            //New Releases
        case .New_Releases(let viewModels):
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleaseCollectionViewCell.identifier, for: indexPath) as? NewReleaseCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
            
        }
        
    }
    
}
