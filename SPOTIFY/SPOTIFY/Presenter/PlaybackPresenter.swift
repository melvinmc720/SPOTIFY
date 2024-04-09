//
//  PlaybackPresenter.swift
//  SPOTIFY
//
//  Created by milad marandi on 3/24/24.
//


import UIKit
import AVFoundation

protocol PlayerDataSource: AnyObject{
    var title:String? { get }
    var subtitle:String? { get }
    var SongImage:URL? { get }
}


final class PlaybackPresenter{
    
    static let shared = PlaybackPresenter()
    
    private var track:AudioTrack?
    private var tracks = [AudioTrack]()
    
    var Player:AVPlayer?
    var PlayerQueue:AVQueuePlayer?
    
    var currentTrack:AudioTrack? {
        if let track = track , tracks.isEmpty {
            return track
        }
        else if let player = self.PlayerQueue , !tracks.isEmpty {
            let item = player.currentItem
            let items = player.items()
            guard let index = items.firstIndex(where: {$0 == item}) else{
                return nil
            }
            return tracks[index]
        }
        return nil
    }
    
     func startPlayback(from viewController:UIViewController , track: AudioTrack){
         
         guard let url = URL(string: track.preview_url ?? "") else {
             return
         }
         
        self.Player = AVPlayer(url: url)
        self.track = track
        self.tracks = []
         
        let vc = PlayerViewController()
        vc.title = track.name
        vc.datasource = self
        vc.delegate  = self
         viewController.present(UINavigationController(rootViewController:vc), animated: true , completion: { [weak self] in
             self?.Player?.play()
             self?.Player?.volume = 0
         })
    }
    
    
    func startPlayback(from viewController:UIViewController , tracks: [AudioTrack]){
        
        self.tracks = tracks
        self.track = nil
        self.PlayerQueue = AVQueuePlayer(items: self.tracks.compactMap({
            guard let url = URL(string: $0.preview_url ?? "") else {
                return nil
            }
            return AVPlayerItem(url: url)
        }))
        self.PlayerQueue?.volume = 0
        self.PlayerQueue?.play()
        
        let vc = PlayerViewController()
        viewController.present(UINavigationController(rootViewController:vc), animated: true)
    }
    
}
extension PlaybackPresenter:PlayerDataSource{
    var title: String? {
        currentTrack?.name
    }
    
    var subtitle: String? {
        currentTrack?.artists.first?.name

    }
    
    var SongImage: URL? {
        URL(string:currentTrack?.album?.images.first?.url ?? " ")

    }
    
    
}

extension PlaybackPresenter:PlayerViewControllerDelegate{
    
    func didTapPlayPause() {
        if let player = Player{
            if player.timeControlStatus == .playing{
                self.Player?.pause()
            }
            else if player.timeControlStatus == .paused{
                self.Player?.play()
            }
        }
        else if let player = PlayerQueue {
            if player.timeControlStatus == .playing{
                player.pause()
            }
            else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }
    
    func didTapForward() {
        if tracks.isEmpty{
            //not playlist or album
            self.Player?.pause()
            
        }
        else if let player = PlayerQueue{
            player.advanceToNextItem()
        }
    }
    
    func didTapBackward() {
        if tracks.isEmpty{
            //not playlist or album
            self.Player?.pause()
            self.Player?.seek(to: CMTime.zero)
            self.Player?.play()
        }
        else if let player = PlayerQueue{
            
        }
    }
    
    func didSlideSlider(_ Value: Float) {
        Player?.volume = Value
    }
    
}

