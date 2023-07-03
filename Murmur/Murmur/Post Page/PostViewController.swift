//
//  PostViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/15.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import AVFoundation

class PostViewController: UIViewController {
    
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    let murmurTextField: UITextField = {
        let murmurTextField = UITextField()
        murmurTextField.placeholder = "想說什麼大聲說出來"
        murmurTextField.contentVerticalAlignment = .top
        murmurTextField.textColor = .GrayScale20
        murmurTextField.layer.addTypingShadow()
        return murmurTextField
    }()
    private let murmurView: UIView = {
        let murmurView = UIView()
//        murmurImageView.image = UIImage(named: "test1.jpg")
        murmurView.contentMode = .scaleAspectFill
        murmurView.clipsToBounds = true
        return murmurView
    }()
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 40
        return stack
    }()
    private let albumButton: UIButton = {
        let albumButton = UIButton()
        albumButton.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        albumButton.setImage(UIImage(named: "Icons_Album.png"), for: .normal)
        return albumButton
    }()
    private lazy var cameraButton: UIButton = {
        let cameraButton = UIButton(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        cameraButton.setImage(UIImage(named: "Icons_Camera.png"), for: .normal)
        cameraButton.addTarget(self, action: #selector(cameraButtonTouchUpInside), for: .touchUpInside)
        return cameraButton
    }()
    
    let postTagVC = PostTagViewController()
    
    var sendMurmurMessageClosure: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNav()
        layout()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        murmurView.layer.cornerRadius = murmurView.frame.width / 2
        murmurView.layer.borderColor = UIColor.lightGray.cgColor
        murmurView.layer.borderWidth = 3
        
        captureSession = AVCaptureSession()
        setupCaptureSession()
    }
    
    func setupCaptureSession() {
        guard let captureSession = captureSession else { return }
        
        // 設定輸入裝置為相機
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
        } catch {
            print(error.localizedDescription)
            return
        }
        
        // 設定預覽層
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer?.frame = murmurView.layer.bounds
        murmurView.layer.addSublayer(previewLayer!)
        
        // 啟動 AVCaptureSession
        captureSession.startRunning()
    }
    
    @objc func cameraButtonTouchUpInside() {
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
        let imageFromCameraAction = UIAlertAction(title: "相機", style: .default) { (void) in

            // 判斷是否可以從相機取得照片來源
            if UIImagePickerController.isSourceTypeAvailable(.camera) {

                // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.camera)，並 present UIImagePickerController
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }

        // 新增一個取消動作，讓使用者可以跳出 UIAlertController
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (void) in

            imagePickerAlertController.dismiss(animated: true, completion: nil)
        }

        // 將上面三個 UIAlertAction 動作加入 UIAlertController
        imagePickerAlertController.addAction(imageFromLibAction)
        imagePickerAlertController.addAction(imageFromCameraAction)
        imagePickerAlertController.addAction(cancelAction)

        // 當使用者按下 uploadBtnAction 時會 present 剛剛建立好的三個 UIAlertAction 動作與
        present(imagePickerAlertController, animated: true, completion: nil)
    }
    
    private func setNav() {

//        let navBarAppearance = UINavigationBarAppearance()
//        navBarAppearance.configureWithDefaultBackground()
////        navBarAppearance.backgroundColor = .red
//        navBarAppearance.backgroundEffect = UIBlurEffect(style: .regular)
//        navBarAppearance.titleTextAttributes = [
//           .foregroundColor: UIColor.black,
//           .font: UIFont.systemFont(ofSize: 18, weight: .medium)
//        ]
//        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
//
        self.navigationItem.title = "塗鴉留言"
        
        let closeButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonItemTouchUpInside))
        closeButtonItem.tintColor = .SecondaryDefault
        navigationItem.leftBarButtonItem = closeButtonItem
        
        let nextButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonItemTouchUpInside))
        nextButtonItem.setTitleTextAttributes([NSAttributedString.Key.kern: 0, .font: UIFont.systemFont(ofSize: 18, weight: .medium)], for: .normal)
        nextButtonItem.tintColor = .SecondaryShine
        navigationItem.rightBarButtonItem = nextButtonItem
    }
    
    @objc func closeButtonItemTouchUpInside() {
//        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.selectedIndex = 0
    }
    
    @objc func nextButtonItemTouchUpInside() {
//        self.sendMurmurMessageClosure?(murmurTextField.text!)
        postTagVC.murmurData["murmurMessage"] = murmurTextField.text
        self.navigationController?.pushViewController(postTagVC, animated: true)
    }
    
    private func layout() {
        
        self.view.backgroundColor = .PrimaryLight
        
        [murmurTextField, murmurView, stack].forEach { subview in
            self.view.addSubview(subview)
        }
        [albumButton, cameraButton].forEach { subview in
            stack.addArrangedSubview(subview)
        }
        
        murmurTextField.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(self.view).offset(16)
            make.trailing.equalTo(self.view).offset(-16)
            make.height.equalTo(180)
        }
        murmurView.snp.makeConstraints { make in
            make.top.equalTo(murmurTextField.snp.bottom).offset(8)
            make.leading.equalTo(self.view).offset(24)
            make.trailing.equalTo(self.view).offset(-24)
            make.height.equalTo(murmurView.snp.width)
        }
        stack.snp.makeConstraints { make in
            make.top.equalTo(murmurView.snp.bottom).offset(24)
            make.centerX.equalTo(self.view.snp.centerX)
        }
    }

}

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        // 取得從 UIImagePickerController 選擇的檔案
//        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            
//            selectedImageFromPicker = pickedImage
//        }
        
        // 可以自動產生一組獨一無二的 ID 號碼，方便等一下上傳圖片的命名
        let uniqueString = NSUUID().uuidString
        
        // 當判斷有 selectedImage 時，我們會在 if 判斷式裡將圖片上傳
        if let selectedImage = selectedImageFromPicker {
            
            print("\(uniqueString), \(selectedImage)")
        }
        
        dismiss(animated: true, completion: nil)
    }
}
