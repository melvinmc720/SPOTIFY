//
//  LibraryPlayListsViewController.swift
//  SPOTIFY
//
//  Created by milad marandi on 3/29/24.
//

import UIKit

class LibraryPlayListsViewController: UIViewController {

    var playlists = [playlist]()
    public var selectionHandler: ((playlist) -> Void)?
    private let noPlaylistsView = ActionViewLabel()
    
    private let tableview: UITableView = {
        let table = UITableView(frame: .zero , style: .grouped)
        table.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        table.isHidden = true
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableview)
        tableview.delegate = self
        tableview.dataSource = self
        
        noPlaylistsView.configure(with: ActionViewLabelViewModel(title: "you do not have any playlists yet", actionTitle: "Add Playlist"))
        view.addSubview(noPlaylistsView)
        noPlaylistsView.delegate = self

        APICaller.share.getCurrentUserPlaylists { result in
            DispatchQueue.main.async { [weak self] in
             
                switch result{
                case .success(let playlist):
                    self?.playlists = playlist
                    self?.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        if selectionHandler != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
                }
    }
    
    @objc func didTapClose(){
        dismiss(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noPlaylistsView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        noPlaylistsView.center = view.center
        tableview.frame = view.bounds
    }
    
    private func updateUI(){
        if playlists.isEmpty {
            noPlaylistsView.isHidden = false
            tableview.isHidden = true
            print("it is empty \(playlists)")
        }
        else {
            //show playlist
            tableview.reloadData()
            noPlaylistsView.isHidden = true
            tableview.isHidden = false
            print("it is not empty \(playlists)")
            
        }
    }
    
    func ShowAlertToCreatePlaylist(){
        let Alert = UIAlertController(title: "New Playlist", message: "Enter Playlist name", preferredStyle: .alert)
        
        Alert.addTextField(configurationHandler: {
            Textfield in
            Textfield.placeholder = "Playlists..."
        })
        
        Alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        Alert.addAction(UIAlertAction(title: "Create", style: .default, handler:{
         _ in
            guard let textfield = Alert.textFields?.first , let text = textfield.text , !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                return
            }
            APICaller.share.createPlaylists(with: text, completion: { success in
             
                if success{
                    HapticsManager.shared.vibrate(for: .success)
                    APICaller.share.getCurrentUserPlaylists { result in
                        DispatchQueue.main.async { [weak self] in
                         
                            switch result{
                            case .success(let playlist):
                                self?.playlists = playlist
                                self?.updateUI()
                                
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    }
                    
                }
                else {
                    HapticsManager.shared.vibrate(for: .error)
                    print("failed to create a playlist")
                }
                
            })
            
        }))
        
        self.present(Alert , animated: true)
    }

}

extension LibraryPlayListsViewController:ActionViewLabelDelegate{
    
    func actionLableViewDidTapButton(_ view: ActionViewLabel) {
        ShowAlertToCreatePlaylist()
    }
    
    
}

extension LibraryPlayListsViewController:UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
            return UITableViewCell()
        }
        
        //#warning("you need to replace proper value with these arguments")
        let playlist = playlists[indexPath.row]
        cell.configure(with: SearchResultSubtitleTableViewModel(title: playlist.name , imageURL: URL(string:playlist.images?.first?.url ?? " "), subtitle: playlist.owner.display_name))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        let Myplaylist = playlists[indexPath.row]
        guard selectionHandler == nil else {
            selectionHandler?(Myplaylist)
            self.tableview.reloadData()
            dismiss(animated: true, completion: nil)
            return
        }
        
        let vc = PlaylistViewController(Playlist: Myplaylist)
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.isOwner = true
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
