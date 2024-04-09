//
//  HomeHeaderCollectionReusableView.swift
//  SPOTIFY
//
//  Created by milad marandi on 3/9/24.
//

import UIKit

class HomeHeaderCollectionReusableView: UICollectionReusableView {
    
    
    static let identifier = "HomeHeaderCollectionReusableView"
    
    private var TitleLabel:UILabel = {
       let label = UILabel()
        label.font  = .systemFont(ofSize: 18 , weight: .semibold)
        return label
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(TitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        TitleLabel.frame = CGRect(x: 10, y: 15, width: frame.width, height: frame.height)
    }
    
    public func configure(title String:String){
        self.TitleLabel.text = String
    }
}
