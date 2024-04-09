//
//  LibraryAlbumViewController.swift
//  SPOTIFY
//
//  Created by milad marandi on 3/29/24.
//

import UIKit

class LibraryAlbumViewController: UIViewController {

    var albums = [Album]()

    private let noAlbumsView = ActionViewLabel()
    private var observer:NSObjectProtocol?
    
    private let tableview: UITableView = {
        let table = UITableView(frame: .zero , style: .grouped)
        table.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        table.isHidden = true
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableview)
        view.addSubview(noAlbumsView)
        tableview.delegate = self
        tableview.dataSource = self
        noAlbumsView.configure(with: ActionViewLabelViewModel(title: "you do not have any playlists yet", actionTitle: "Add Playlist"))
        noAlbumsView.delegate = self
        fetchData()
        updateUI()
        observer = NotificationCenter.default.addObserver(forName: Notification.Name.AlbumNotification, object: nil, queue: .main, using: { [weak self] _ in
            self?.fetchData()
        })

    }
    
    private func fetchData(){
        self.albums.removeAll()
        APICaller.share.getCurrentUserAlbum { result  in
            DispatchQueue.main.async {[weak self] in
                switch result{
                case .success(let albums):
                    self?.albums = albums
                    self?.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @objc func didTapClose(){
        dismiss(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noAlbumsView.frame = CGRect(x: (view.frame.width - 200) / 2, y: (view.frame.height - 200) / 2, width: 200, height: 200)
        tableview.frame = view.bounds
    }
    
    private func updateUI(){
        if albums.isEmpty {
            noAlbumsView.isHidden = false
            tableview.isHidden = true
        }
        else {
            //show playlist
            tableview.reloadData()
            noAlbumsView.isHidden = true
            tableview.isHidden = false
            
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
            
        }))
        
        self.present(Alert , animated: true)
    }

}

extension LibraryAlbumViewController:ActionViewLabelDelegate{
    
    func actionLableViewDidTapButton(_ view: ActionViewLabel) {
        ShowAlertToCreatePlaylist()
    }
    
    
}

extension LibraryAlbumViewController:UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
            return UITableViewCell()
        }
        
        //#warning("you need to replace proper value with these arguments")
        let album = albums[indexPath.row]
        cell.configure(with: SearchResultSubtitleTableViewModel(title: album.name , imageURL: URL(string:album.images.first?.url ?? " "), subtitle: album.artists.first?.name ?? " "))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        let album = albums[indexPath.row]
        
        let vc = AlbumViewController(album: album)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
