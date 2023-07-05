//
//  ProfileViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/15.
//

import UIKit
import SnapKit
import Kingfisher

class ProfileViewController: UIViewController {
    
//    var scrollToFootPrintPage = false
    var scrollToFootPrintPage = false {
        didSet {
            profileTableView.reloadData()
        }
    }
    
    var selectedSegmentButton: UIButton?
    var userData: Users? {
        didSet {
            profileTableView.reloadData()
        }
    }
    
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
            guard let documentSnapshot else {
                print("documentSnapshot is nil.")
                return
            }
            
            do {
                let user = try documentSnapshot.data(as: Users.self)
                self.userData = user
            } catch {
                print("Error: ", error)
            }
            
//            DispatchQueue.main.async {
                
//            }
            
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
            make.leading.trailing.equalTo(self.view)
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
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
           
            cell.footPrintClosure = { cell in
                self.scrollToFootPrintPage = true
            }
            cell.postsClosure = { cell in
                self.scrollToFootPrintPage = false
            }
            cell.clipsToBounds = false
            return cell
            
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath == IndexPath(row: 0, section: 0) {
            let cell = ProfileTableViewCell()
            cell.backgroundColor = .clear
            
            if let portrait = userData?.userPortrait {
                cell.profileImageView.kf.setImage(with: URL(string: userData!.userPortrait))
            } else {
                cell.profileImageView.image = UIImage(named: "User1Portrait.jpg")
            }
            
            cell.userNameLabel.text = userData?.userName
            cell.murmurLabel.text = userData?.murmur ?? "🖋️"
            cell.layoutView()
            cell.selectionStyle = .none
            
            cell.settingClosure = { cell in
                let settingViewController = SettingViewController()
                if let sheetPresentationController = settingViewController.sheetPresentationController {
                    sheetPresentationController.detents = [.medium()]
                    sheetPresentationController.preferredCornerRadius = 80
                    // 顯示下拉的灰色長條
                    sheetPresentationController.prefersGrabberVisible = true
                }
                self.present(settingViewController, animated: true, completion: nil)
            }
            
            return cell
            
        } else if indexPath == IndexPath(row: 0, section: 1) {
            let cell = ScrollTableViewCell()
            cell.layoutView(viewController: self)
            
            // 控制 scrollView 捲動到哪
            if scrollToFootPrintPage {
                cell.scrollView.setContentOffset(CGPoint(x: fullScreenSize.width, y: 0), animated: true)
            } else {
                cell.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
            
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
