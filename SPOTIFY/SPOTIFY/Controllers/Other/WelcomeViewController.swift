//
//  WelcomeViewController.swift
//  SPOTIFY
//
//  Created by milad marandi on 1/13/24.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let WelcomeText:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Listen to the Millons of Songs on the go"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: UIFont.Weight.bold)
        return label
        
    }()
    
    private let backgroundImageView:UIImageView = {
       let imageview = UIImageView()
        imageview.image = UIImage(named: "background_image")
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    
    private let overlayview:UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.7
        return view
    }()
    
    private let SignIn:UIButton = {
        let button = UIButton()
        
        button.setTitle("Sign In", for: UIControl.State.normal)
        button.backgroundColor = .label
        button.setTitleColor(.systemBackground, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(SignInAction), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        self.view.backgroundColor = .white
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = .green
        view.addSubview(backgroundImageView)
        view.addSubview(overlayview)
        view.addSubview(SignIn)
        view.addSubview(WelcomeText)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        SignIn.frame = CGRect(x: 10, y: view.frame.height - 100, width: view.frame.width - 20, height: 50)
        backgroundImageView.frame = view.bounds
        overlayview.frame = view.bounds
        WelcomeText.frame.size = CGSize(width: 250, height: 150)
        WelcomeText.center = view.center
    }
    
    @objc private func SignInAction(){
        let vc = AuthViewController()
        vc.CompletionHandler = { success in
            DispatchQueue.main.async {
                self.handleSignin(success:success)
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignin(success:Bool){
        //log user in or yell at them for error
        guard success else {
            
            let alert = UIAlertController(title: "Oops", message: "something went wrong when signing in", preferredStyle: .alert)
            let okButtonAction = UIAlertAction(title: "Dismiss", style: .cancel)
            alert.addAction(okButtonAction)
            present(alert, animated: true)
            
            return
        }
        
        let tabBarvc = TabViewController()
        tabBarvc.modalPresentationStyle = .fullScreen
        present(tabBarvc , animated: true)

        
    }

}
