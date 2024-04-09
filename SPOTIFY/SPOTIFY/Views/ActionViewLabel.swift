//
//  ActionViewLabel.swift
//  SPOTIFY
//
//  Created by milad marandi on 4/1/24.
//

import UIKit

struct ActionViewLabelViewModel{
    let title:String
    let actionTitle:String
}

protocol ActionViewLabelDelegate:AnyObject{
    func actionLableViewDidTapButton(_ view:ActionViewLabel)
}

class ActionViewLabel: UIView {
    
    weak var delegate:ActionViewLabelDelegate?
    
    private let Label:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let Button:UIButton = {
       let button = UIButton()
        button.setTitleColor(.link, for: .normal)
       return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(Label)
        addSubview(Button)
        isHidden = true
        Button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        Label.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - 45)
        Button.frame = CGRect(x: 0, y: frame.height - 40, width: frame.width, height: 40)
    }
    
    func configure(with viewmodel:ActionViewLabelViewModel){
        Label.text = viewmodel.title
        Button.setTitle(viewmodel.actionTitle, for: .normal)
    }
    
    @objc func didTapButton(){
        delegate?.actionLableViewDidTapButton(self)
    }
    
}
