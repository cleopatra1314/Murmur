//
//  ProfileViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/15.
//

import UIKit
import SnapKit
import Kingfisher
import FirebaseFirestore
import FirebaseCore

class ProfileViewController: UIViewController {
    
    var choosedPortraitFromAlbum: UIImage?
    
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
    
    let popupView: PostDetailsPopupView = {
        let popupView = PostDetailsPopupView()
        popupView.backgroundColor = .PrimaryLighter
        return popupView
    }()
    let blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView()
        blurView.effect = UIBlurEffect(style: .light)
        return blurView
    }()
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
        
        popupView.closeClosure = { [self] view, rowOfindexPath in
            self.animateScaleOut(desiredView: self.popupView)
            self.animateScaleOut(desiredView: self.blurView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        blurView.bounds = self.view.bounds
        popupView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width*0.9, height: self.view.bounds.height*0.8)
        
        fetchUserData()
    }
    
    /// Animates a view to scale in and display
    func animateScaleIn(desiredView: UIView) {
        let backgroundView = self.view!
        backgroundView.addSubview(desiredView)
        backgroundView.bringSubviewToFront(desiredView)
        desiredView.center = backgroundView.center
        desiredView.isHidden = false
        
        desiredView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        desiredView.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desiredView.alpha = 1
//            desiredView.transform = CGAffineTransform.identity
        }
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    /// Animates a view to scale out remove from the display
    func animateScaleOut(desiredView: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            desiredView.alpha = 0
            
        }, completion: { (success: Bool) in
            self.tabBarController?.tabBar.isHidden = false
            desiredView.removeFromSuperview()
        })
        
        UIView.animate(withDuration: 0.2, animations: {
            
        }, completion: { _ in
            
        })
        
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
    
    private func changePortraitFromAlbum(cell: UITableViewCell) {
        
        // 建立一個 UIImagePickerController 的實體
        let imagePickerController = UIImagePickerController()

        // 委任代理
        imagePickerController.delegate = self

        // 建立一個 UIAlertController 的實體
        // 設定 UIAlertController 的標題與樣式為 動作清單 (actionSheet)
        let imagePickerAlertController = UIAlertController(title: "上傳圖片", message: "請選擇要上傳的圖片", preferredStyle: .actionSheet)

        // 建立三個 UIAlertAction 的實體
        // 新增 UIAlertAction 在 UIAlertController actionSheet 的 動作 (action) 與標題
        let imageFromLibAction = UIAlertAction(title: "照片圖庫", style: .default) { (void) in

            // 判斷是否可以從照片圖庫取得照片來源
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {

                // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.photoLibrary)，並 present UIImagePickerController
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
//        let imageFromCameraAction = UIAlertAction(title: "相機", style: .default) { (void) in
//
//            // 判斷是否可以從相機取得照片來源
//            if UIImagePickerController.isSourceTypeAvailable(.camera) {
//
//                // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.camera)，並 present UIImagePickerController
//                imagePickerController.sourceType = .camera
//                self.present(imagePickerController, animated: true, completion: nil)
//            }
//        }

        // 新增一個取消動作，讓使用者可以跳出 UIAlertController
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (void) in

            imagePickerAlertController.dismiss(animated: true, completion: nil)
        }

        // 將上面三個 UIAlertAction 動作加入 UIAlertController
        imagePickerAlertController.addAction(imageFromLibAction)
//        imagePickerAlertController.addAction(imageFromCameraAction)
        imagePickerAlertController.addAction(cancelAction)

        // 當使用者按下 uploadBtnAction 時會 present 剛剛建立好的三個 UIAlertAction 動作與
        present(imagePickerAlertController, animated: true, completion: nil)
        
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
            
            let portrait = userData?.userPortrait
            if portrait == nil || portrait == ""{
                cell.profileImageView.image = UIImage(named: "User1Portrait.png")
            } else {
                cell.profileImageView.kf.setImage(with: URL(string: portrait!))
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
            
            cell.changePortraitClosure = { cell in
                self.changePortraitFromAlbum(cell: cell)
                
//                cell.profileImageView.image = self.choosedPortraitFromAlbum?.image
//                cell.profileImageView.isHidden = false
//                cell.profileView.isHidden = true
            }
            cell.profileImageView.image = self.choosedPortraitFromAlbum ?? UIImage(named: "User1Portrait.png")
            
            return cell
            
        } else if indexPath == IndexPath(row: 0, section: 1) {
            
            let cell = ScrollTableViewCell()
            cell.layoutView(viewController: self)
            cell.postsVC.showPostsDetailsPopupClosure = { [self] data, rowOfIndexPath in
                popupView.postImageView.kf.setImage(with: URL(string: data[rowOfIndexPath].murmurImage))
                popupView.postContentTextView.text = data[rowOfIndexPath].murmurMessage
                popupView.currentRowOfIndexpath = rowOfIndexPath
                
                reverseGeocodeLocation(latitude: data[rowOfIndexPath].location["latitude"]!, longitude: data[rowOfIndexPath].location["longitude"]!) { address in
                    print("地址", data[rowOfIndexPath].location["latitude"]!, data[rowOfIndexPath].location["longitude"]!)
                    self.popupView.postCreatedSiteLabel.text = address
                    
                }
                
                let timestamp: Timestamp = data[rowOfIndexPath].createTime // 從 Firestore 中取得的 Timestamp 值
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy MM dd" // 例如："yyyy-MM-dd HH:mm" -> 2023-06-10 15:30
                let date = timestamp.dateValue()
                let formattedTime = dateFormatter.string(from: date)
                popupView.postCreatedTimeLabel.text = formattedTime
                
                self.animateScaleIn(desiredView: self.blurView)
                self.animateScaleIn(desiredView: self.popupView)
            }
            
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

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // [String : Any]
        
        
//        presentCancelAlert(message: "確定要更換頭貼嗎？", viewController: self)
//        showAlert(title: "", message: "確定要更換頭貼嗎？", viewController: self)
        
        var selectedImageFromPicker: UIImage?
          
        // 可以自動產生一組獨一無二的 ID 號碼，方便等一下上傳圖片的命名
        let uniqueString = NSUUID().uuidString

        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            presentCancelAlert(message: "確定要更換頭貼嗎？", viewController: self)
            
            // 在此處理選取的照片
            self.choosedPortraitFromAlbum = selectedImage
            profileTableView.reloadData()
            
            // Upload to fireStorage
            uploadPhoto(image: selectedImage) { result in
                switch result {
                    
                case .success(let url):
                    
                    // url 轉 string
                    let selectedImageUrlString = url.absoluteString
                    
                    // modify firebase data
                    database.collection("userTest").document(currentUserUID).getDocument { documentSnapshot, error in
                        
                        guard let documentSnapshot,
                              documentSnapshot.exists,
                              var user = try? documentSnapshot.data(as: Users.self)
                        else {
                            return
                        }
                        
                        user.userPortrait = selectedImageUrlString
                        
                        // 修改 firebase 上大頭貼資料
                        do {
                            try database.collection("userTest").document(currentUserUID).setData(from: user)
                        } catch {
                            print(error)
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                    
                }
            }
            
        }
        
        dismiss(animated: true, completion: nil)
    }
}
