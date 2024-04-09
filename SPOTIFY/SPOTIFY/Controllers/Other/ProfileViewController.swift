//
//  ProfileViewController.swift
//  SPOTIFY
//
//  Created by milad marandi on 1/13/24.
//

import UIKit
import SDWebImage


class ProfileViewController: UIViewController, UITableViewDelegate , UITableViewDataSource{
    
    
    let tableview:UITableView = {
       let tableview = UITableView()
        tableview.isHidden = true
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableview
    }()
    
    private var models = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        fetchProfile()
        tableview.delegate = self
        tableview.dataSource = self
        view.addSubview(tableview)
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        self.tableview.frame = view.frame
        self.tableview.center = view.center
    }
    
    
    private func fetchProfile()
    {
        
        APICaller.share.GetCurrentuserProfiel(completion: { [weak self] result in
            
            DispatchQueue.main.async {
             
                switch result{
                case .success(let model):
                    self?.updateUI(with: model)
                    
                case .failure(let error):
                    self?.failedtoGetProfile()
                }
            }
            
        })
        
    }
    
    private func createtableHeader(with string: String?) {
        #warning("optimize this part milad")
        guard let urlString = string , let url = URL(string: urlString) else {
            let headerview = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width / 1.5))
            let imagesize = view.frame.width / 2
            let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: imagesize, height: imagesize))
            imageview.contentMode = .scaleAspectFill
            imageview.center = headerview.center
            imageview.image = UIImage(systemName: "person")
            headerview.addSubview(imageview)
            imageview.layer.masksToBounds = true
            imageview.layer.cornerRadius = imagesize / 2
            self.tableview.tableHeaderView = headerview
            
            return
        }
        
        let headerview = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width / 1.5))
        let imagesize = view.frame.height / 2
        let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: imagesize, height: imagesize))
        imageview.contentMode = .scaleAspectFit
        imageview.center = headerview.center
        imageview.sd_setImage(with: url, completed: nil)
        imageview.layer.masksToBounds = true
        imageview.layer.cornerRadius = imagesize / 2
        headerview.addSubview(imageview)
        
        self.tableview.tableHeaderView = headerview
    }
    
    private func updateUI(with model: UserProfile){
        
          self.tableview.isHidden = false
          self.models.append("Full Name: \(model.display_name)")
          self.models.append("Email: \(model.email)")
          self.models.append("User ID: \(model.id)")
          self.models.append("Plan : \(model.product)")
          self.createtableHeader(with: model.images.first?.url)
          self.tableview.reloadData()
        
    }
    
    private func failedtoGetProfile(){
        
        let label = UILabel(frame: .zero)
        label.text = "Failed to Load"
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    
}
