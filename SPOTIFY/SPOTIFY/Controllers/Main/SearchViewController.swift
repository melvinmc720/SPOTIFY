//
//  SearchViewController.swift
//  SPOTIFY
//
//  Created by milad marandi on 1/13/24.
//

import UIKit
import SafariServices

class SearchViewController: UIViewController, UISearchResultsUpdating , UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        //
    }
    
    

    private let SearchController:UISearchController = {
        
       let SearchBar = UISearchController(searchResultsController: SearchResultViewController())
        SearchBar.searchBar.placeholder = "Songs, Artists , Albums"
        SearchBar.searchBar.searchBarStyle = .minimal
        SearchBar.definesPresentationContext = true
       return SearchBar
        
    }()
    
    private var collectionView:UICollectionView!
    private var categories = [Category]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        self.SearchController.searchBar.delegate = self
        self.SearchController.searchResultsUpdater = self
        navigationItem.searchController = SearchController
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(section: CompositionalLayout()))
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(SearchViewControllerCollectionViewCell.self, forCellWithReuseIdentifier: SearchViewControllerCollectionViewCell.identifier)
        view.addSubview(collectionView)
        
        APICaller.share.getCategories(completion: {[weak self]
            result in
            DispatchQueue.main.async {
             
                switch result{
                case .success(let categories):
                    self?.categories = categories
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        })

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView.frame = view.frame
        self.collectionView.center = view.center
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text ,!text.trimmingCharacters(in: .whitespaces).isEmpty , let resultcontroller  = SearchController.searchResultsController as? SearchResultViewController else {
            return
        }
        
        resultcontroller.delegate = self
        
        APICaller.share.search(with: text, completion: {
            
            result in
            
            switch result{
                
            case .success(let results):
                resultcontroller.update(with: results)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
        
    }
    
    
    
    
    private func CompositionalLayout() -> NSCollectionLayoutSection {
        
        //item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .absolute(100)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5)
        
        //group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(110)), repeatingSubitem: item, count: 2)
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        
        //return
        
        return section
        
    }
    
        


}


extension SearchViewController:UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchViewControllerCollectionViewCell.identifier, for: indexPath) as? SearchViewControllerCollectionViewCell else {
            return UICollectionViewCell()
        }
        let Category = self.categories[indexPath.row]
        cell.configure(with: CategoryCollectionViewcellModel(name: Category.name, image: URL(string:Category.icons.first?.url ?? " ")))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        let category = categories[indexPath.row]
        let vc = CategoryViewContoller(category: category)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension SearchViewController:SearchResultViewControllerDelegate{
    func didTapResult(_ result: SearchResult) {
        switch result{
        case .artist(model: let model):
            guard let url = URL(string: model.external_urls["spotify"] ?? " ") else {
                return
            }
            
            let vc = SFSafariViewController(url: url)
            present(vc , animated: true)
            
        case .album(model: let model):
            let vc = AlbumViewController(album: model)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .track(model: let track):
            PlaybackPresenter.shared.startPlayback(from: self, track: track)
        case .playlist(model: let model):
            let vc = PlaylistViewController(Playlist: model)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
