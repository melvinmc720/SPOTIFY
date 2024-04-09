//
//  PlayerControlsView.swift
//  SPOTIFY
//
//  Created by milad marandi on 3/24/24.
//

import Foundation
import UIKit


protocol PlayerControlsViewDelegate:AnyObject{
    func PlayerControlsViewdidTapPlayPause(_ Plyarcontrolsview:PlayerControlsView)
    func PlayerControlsViewdidTapForward(_ Plyarcontrolsview:PlayerControlsView)
    func PlayerControlsViewdidTapBackward(_ Plyarcontrolsview:PlayerControlsView)
    func playercontrolsview(_ Plyarcontrolsview:PlayerControlsView , didSlideSlider value:Float)
}

final class PlayerControlsView:UIView{
    
    private var isPlaying:Bool = true
    weak var delegate:PlayerControlsViewDelegate?
    
    let SoundSlider:UISlider = {
       let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    let BackwardButton:UIButton = {
       let button = UIButton()
        let image = UIImage(systemName: "backward",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: UIControl.State.normal)
        button.addTarget(self, action: #selector(didTapBackward), for: .touchUpInside)
        button.tintColor = .white

        return button
    }()
    
    let Playbutton:UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "pause.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: UIControl.State.normal)
        button.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        button.tintColor = .white

        return button
    }()
    
    let ForwardButton:UIButton = {
       let button = UIButton()
        let image = UIImage(systemName: "forward" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: UIControl.State.normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapForward), for: .touchUpInside)
        return button
    }()
    
    let Namelabel:UILabel = {
        let label = UILabel()
        label.text = " This is my song"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    let subtitlelabel:UILabel = {
        let label = UILabel()
        label.text = " This is made by someoneelse"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        self.addSubview(SoundSlider)
        self.addSubview(BackwardButton)
        self.addSubview(Playbutton)
        self.addSubview(ForwardButton)
        self.addSubview(Namelabel)
        self.addSubview(subtitlelabel)
        SoundSlider.addTarget(self, action: #selector(didSlideSlider), for: .valueChanged)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewmodel: PlayerControlsViewModel){
        self.Namelabel.text = viewmodel.title
        self.subtitlelabel.text = viewmodel.subtitle
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        Namelabel.frame = CGRect(x: 10, y: 0, width: frame.width, height: 50)
        subtitlelabel.frame = CGRect(x: 10, y: Namelabel.frame.maxY + 10, width: frame.width, height: 50)
        
        SoundSlider.frame = CGRect(x: 10, y: subtitlelabel.frame.maxY + 15, width: frame.width - 20, height: 44)
        
        BackwardButton.frame = CGRect(x: Playbutton.frame.minX - 140, y: SoundSlider.frame.maxY + 30, width: 60, height: 60)
        
        Playbutton.frame = CGRect(x: (frame.width - 60)/2, y: SoundSlider.frame.maxY + 30, width: 60, height: 60)
        
        ForwardButton.frame = CGRect(x: Playbutton.frame.maxX + 80, y: SoundSlider.frame.maxY + 30, width: 60, height: 60)
    }
    
    
     @objc private func didTapPlayPause(){
         self.isPlaying = !self.isPlaying
         delegate?.PlayerControlsViewdidTapPlayPause(self)
         
         let playIcon = UIImage(systemName: "play.fill" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
         
         let PauseIcon = UIImage(systemName: "pause.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
         
         self.Playbutton.setImage(isPlaying ? PauseIcon : playIcon, for: .normal)
    }
    
     @objc private func didTapForward(){
         delegate?.PlayerControlsViewdidTapForward(self)
    }
     @objc private func didTapBackward(){
         delegate?.PlayerControlsViewdidTapBackward(self)
    }
    
    
    @objc private func didSlideSlider(_ slider: UISlider){
        let value = slider.value
        delegate?.playercontrolsview(self, didSlideSlider: value)
    }
    
}
