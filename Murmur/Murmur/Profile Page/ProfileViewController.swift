//
//  ProfileViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/15.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    
    var selectedSegmentButton: UIButton?
    
    private let backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "profileBackground.jpg")
        backgroundImageView.contentMode = .scaleAspectFill
        return backgroundImageView
    }()
    private let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 52/255, green: 104/255, blue: 95/255, alpha: 0.8)
        return backgroundView
    }()
    private let profileTableView: UITableView = {
        let profileTableView = UITableView()
        profileTableView.separatorStyle = .none
        return profileTableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutBackground()
        layoutTableView()
        layoutGradient()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchUserData()
    }
    
    private func layoutGradient() {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.SecondaryMiddle?.withAlphaComponent(0.4).cgColor, UIColor.PrimaryMiddle?.withAlphaComponent(1).cgColor]
        backgroundView.layer.addSublayer(gradientLayer)
        
    }
    
    private func fetchUserData() {
        database.collection("userTest").document(currentUserUID).getDocument { documentSnapshot, error in
            
            print("fetch 回來的自己資料", documentSnapshot?.data())
            
        }
    }
    
    private func layoutBackground() {
        [backgroundImageView, backgroundView].forEach { subview in
            self.view.addSubview(subview)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
    }
    
    private func layoutTableView() {
        
        profileTableView.backgroundColor = UIColor.clear
 
        profileTableView.dataSource = self
        profileTableView.delegate = self
        
//        profileTableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "\(ProfileTableViewCell.self)")
//        profileTableView.register(HeaderOfProfileTableViewCell.self, forHeaderFooterViewReuseIdentifier: "\(HeaderOfProfileTableViewCell.self)")
        
        self.view.addSubview(profileTableView)
        
//        profileTableView.snp.makeConstraints { make in
//            make.top.equalTo(self.view.safeAreaLayoutGuide)
//            make.leading.equalTo(self.view.safeAreaLayoutGuide)
//            make.trailing.equalTo(self.view.safeAreaLayoutGuide)
//            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
//        }
        
        profileTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let cell = SegmentButtonTableViewCell(style: .default, reuseIdentifier: "\(SegmentButtonTableViewCell.self)")
            return cell
            
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath == IndexPath(row: 0, section: 0) {
            let cell = ProfileTableViewCell()
            cell.backgroundColor = .clear
            cell.layoutView()
            cell.selectionStyle = .none
            return cell
            
        } else if indexPath == IndexPath(row: 0, section: 1) {
            let cell = ScrollTableViewCell()
            cell.layoutView(viewController: self)
//            cell.selectionStyle = .none
            return cell
            
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 0
        } else {
            // TODO: UITableView.automaticDimension
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath == IndexPath(row: 0, section: 0) {
            return fullScreenSize.height * 2/5
            
        } else if indexPath == IndexPath(row: 0, section: 1){
            return fullScreenSize.height
            
        } else {
            // TODO: UITableView.automaticDimension
            return UITableView.automaticDimension
        }
    }

}
