//
//  SearchResultViewController.swift
//  SPOTIFY
//
//  Created by milad marandi on 3/14/24.
//

import UIKit


struct searchSection{
    let title:String
    let results:[SearchResult]
}

protocol SearchResultViewControllerDelegate:AnyObject{
    func didTapResult(_ result:SearchResult)
}

class SearchResultViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    weak var delegate:SearchResultViewControllerDelegate?
    private var sections = [searchSection]()
    
    private var tableview:UITableView = {
        let tableview = UITableView(frame: .zero , style: .grouped)
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableview.isHidden = true
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(tableview)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(SearchResultDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultDefaultTableViewCell.identifier)
        tableview.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableview.frame = view.bounds
        tableview.center = view.center
    }
    
    func update(with results:[SearchResult]){
        
        let artists = results.filter {
            switch $0{
            case .artist:
                return true
            default:
                return false
            }
        }
        
        
        let albums = results.filter {
            switch $0{
            case .album:
                return true
            default:
                return false
            }
        }
        
        
        let tracks = results.filter {
            switch $0{
            case .track:
                return true
            default:
                return false
            }
        }
        
        
        let playlists = results.filter {
            switch $0{
            case .playlist:
                return true
            default:
                return false
            }
        }
        
        self.sections = [
        searchSection(title: "Artists", results: artists),
        searchSection(title: "Albums", results: albums),
        searchSection(title: "Songs", results: tracks),
        searchSection(title: "Playlists", results: playlists),

        
        ]
        
        DispatchQueue.main.async {
            self.tableview.reloadData()
            self.tableview.isHidden = results.isEmpty
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = sections[indexPath.section].results[indexPath.row]
        delegate?.didTapResult(result)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let result = sections[indexPath.section].results[indexPath.row]
        
        let Acell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as! SearchResultSubtitleTableViewCell
        
        switch result{
            
        case .artist(model: let artist):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultDefaultTableViewCell.identifier, for: indexPath) as? SearchResultDefaultTableViewCell else {
                return Acell
            }
            cell.configure(with: SearchResultDefaultTableViewModel(title: artist.name, imageURL:URL(string: artist.images?.first?.url ?? "")))
            
            return cell
        case .album(model: let model):
            let viewmodel = SearchResultSubtitleTableViewModel(title: model.name, imageURL: URL(string: model.images.first?.url ?? " "), subtitle: model.artists.first?.name ?? " ")
            Acell.configure(with: viewmodel)

        case .track(model: let model):
            let viewmodel = SearchResultSubtitleTableViewModel(title: model.name, imageURL: URL(string: model.album?.images.first?.url ?? " "), subtitle: model.artists.first?.name ?? " ")
            Acell.configure(with: viewmodel)

        case .playlist(model: let model):
            let viewmodel = SearchResultSubtitleTableViewModel(title: model.name, imageURL: URL(string:model.images?.first?.url ?? ""), subtitle: model.owner.display_name)
            Acell.configure(with: viewmodel)

        }
        return Acell
    }
    
}
