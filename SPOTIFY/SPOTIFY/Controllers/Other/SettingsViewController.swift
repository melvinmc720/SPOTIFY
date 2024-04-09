//
//  SettingsViewController.swift
//  SPOTIFY
//
//  Created by milad marandi on 1/13/24.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {
    
    
    let tableview : UITableView = {
        let tableview = UITableView(frame: .zero , style: .grouped)
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableview
    }()
    
    var sections = [section]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureModels()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.frame = view.frame
    
        view.addSubview(tableview)
    }
    
    private func configureModels(){
        sections.append(section(title: "Profile", option: [options(title: "View your profile", handler: {[weak self] in
            self?.ViewProfile()
        })]))
        
        sections.append(section(title: "Account", option: [options(title: "Sign out", handler: {[weak self] in
            self?.SignOut()
        })]))

        
    }
    
    
    private func SignOut(){
        
        let Alert = UIAlertController(title: "SignOut", message: "Are you sure?", preferredStyle: .alert)
        Alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        Alert.addAction(UIAlertAction(title: "SignOut", style: UIAlertAction.Style.default, handler: { _ in
            
            AuthManager.shared.signOut { signedOut in
                if signedOut{
                    DispatchQueue.main.async {
                        let navVC = UINavigationController(rootViewController: WelcomeViewController())
                        navVC.navigationBar.prefersLargeTitles = true
                        navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
                        navVC.modalPresentationStyle = .fullScreen
                        self.present(navVC, animated: true) {
                            
                            self.navigationController?.popToRootViewController(animated: false)
                        }
                    }
                }
            }
        }))
        
        present(Alert ,animated: true)
        
    }
    
    
    private func ViewProfile(){
        let vc = ProfileViewController()
        vc.title = "Profile"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].option.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = sections[indexPath.section].option[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = sections[indexPath.section].option[indexPath.row]
        
        model.handler()
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = sections[section]
        return model.title
    }
    

}
