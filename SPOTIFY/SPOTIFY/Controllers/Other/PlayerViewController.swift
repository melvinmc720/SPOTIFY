//
//  PlayerViewController.swift
//  SPOTIFY
//
//  Created by milad marandi on 1/13/24.
//

import UIKit

protocol PlayerViewControllerDelegate:AnyObject{
    func didTapPlayPause()
    func didTapForward()
    func didTapBackward()
    func didSlideSlider(_ Value:Float)
}
class PlayerViewController: UIViewController {

    
    let MusicImageView:UIImageView = {
       let imageview = UIImageView()
        imageview.image = UIImage(systemName: "photo")
        return imageview
    }()
    
    let ControllerView = PlayerControlsView()
    var datasource:PlayerDataSource?
    var delegate:PlayerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(MusicImageView)
        view.addSubview(ControllerView)
        ControllerView.delegate = self
        configure()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        
    }
    
    @objc func didTapClose(){
        dismiss(animated: true)
    }
    
    @objc func didTapShare(){
        //
    }
    
    private func configure(){
        MusicImageView.sd_setImage(with: datasource?.SongImage, completed: nil)
        ControllerView.configure(with: PlayerControlsViewModel(title: datasource?.title, subtitle: datasource?.subtitle))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        MusicImageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.width, height: view.frame.height/2)
        ControllerView.frame = CGRect(x: 0, y: MusicImageView.frame.maxY, width: view.frame.width, height: view.frame.height/2)
    }

}


extension PlayerViewController:PlayerControlsViewDelegate{
    
    
    func PlayerControlsViewdidTapPlayPause(_ Plyarcontrolsview: PlayerControlsView) {
        delegate?.didTapPlayPause()
    }
    
    func PlayerControlsViewdidTapForward(_ Plyarcontrolsview: PlayerControlsView) {
        delegate?.didTapForward()
    }
    
    func PlayerControlsViewdidTapBackward(_ Plyarcontrolsview: PlayerControlsView) {
        delegate?.didTapBackward()
    }
    func playercontrolsview(_ Plyarcontrolsview: PlayerControlsView, didSlideSlider value: Float) {
        delegate?.didSlideSlider(value)
    }
}
