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
    
    // 獲取所有可用的攝像頭設備
    let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
    lazy var availableDevices = discoverySession.devices
    
    var switchToFrontCamera = true
    // 相機照相功能
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureOutput: AVCapturePhotoOutput?
    var seclectedImageUrl: String?
    
    let murmurTextField: UITextField = {
        let murmurTextField = UITextField()
        murmurTextField.placeholder = "Speak up your mind"
        murmurTextField.contentVerticalAlignment = .top
        murmurTextField.textColor = .GrayScale20
        murmurTextField.layer.addTypingShadow()
        return murmurTextField
    }()
    let murmurView: UIView = {
        let murmurView = UIView()
        murmurView.backgroundColor = .black
        murmurView.clipsToBounds = true
        return murmurView
    }()
    lazy var murmurImageView: UIImageView = {
        let murmurImageView = UIImageView()
        murmurImageView.contentMode = .scaleAspectFill
        murmurImageView.clipsToBounds = true
        return murmurImageView
    }()
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.layer.cornerRadius = 20
        stack.clipsToBounds = true
        return stack
    }()
    private let separaterbar: UIView = {
        let separaterbar = UIView()
        separaterbar.frame = CGRect(x: 0, y: 0, width: 48, height: 2)
        separaterbar.backgroundColor = .PrimaryLight
        return separaterbar
    }()
    private lazy var albumButton: UIButton = {
        let albumButton = UIButton()
//        albumButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        albumButton.backgroundColor = .GrayScale20?.withAlphaComponent(0.7)
        albumButton.tintColor = .SecondaryMiddle
        albumButton.setImage(UIImage(named: "Icons_Album1.png"), for: .normal)
        albumButton.addTarget(self, action: #selector(albumButtonTouchUpInside), for: .touchUpInside)
        return albumButton
    }()
    lazy var captureButton: UIButton = {
        let captureButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 50))
        captureButton.backgroundColor = .SecondaryMiddle?.withAlphaComponent(0.7)
        captureButton.tintColor = .GrayScale20
        captureButton.setImage(UIImage(named: "Icons_Camera1.png"), for: .normal)
        captureButton.addTarget(self, action: #selector(captureButtonTouchUpInside), for: .touchUpInside)
        return captureButton
    }()
    private lazy var trashButton: UIButton = {
        let trashButton = UIButton(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        trashButton.tintColor = .GrayScale60
        trashButton.setImage(UIImage(named: "Icons_Trash.png"), for: .normal)
        trashButton.addTarget(self, action: #selector(trashButtonTouchUpInside), for: .touchUpInside)
        return trashButton
    }()
    private lazy var frontCameraButton: UIButton = {
        let frontCameraButton = UIButton(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        frontCameraButton.tintColor = .GrayScale60
        frontCameraButton.setImage(UIImage(named: "Icons_FrontCamera.png"), for: .normal)
        frontCameraButton.addTarget(self, action: #selector(frontCameraButtonTouchUpInside), for: .touchUpInside)
        return frontCameraButton
    }()
    
    let postTagVC = PostTagViewController()
    
    var sendMurmurMessageClosure: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        self.tabBarController?.tabBar.isHidden
        murmurImageView.isHidden = true
        setNav()
//        layout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        layout()
//        captureSession = AVCaptureSession()
//        setupCaptureSession()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        murmurImageView.layer.cornerRadius = murmurImageView.frame.width / 2
        murmurImageView.layer.borderColor = UIColor.lightGray.cgColor
        murmurImageView.layer.borderWidth = 3
        murmurView.layer.cornerRadius = murmurView.frame.width / 2
        murmurView.layer.borderColor = UIColor.lightGray.cgColor
        murmurView.layer.borderWidth = 3
        
//        captureSession = AVCaptureSession()
//        setupCaptureSession()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        captureSession = AVCaptureSession()
        setupCaptureSession()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 停止取用相機
        captureSession?.stopRunning()
    }
    
    // 當點擊view任何一處鍵盤收起
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func setUpFrontCameraSession() {
        
        // 選擇前置鏡頭設備
        if let frontCamera = availableDevices.first(where: { $0.position == .front }) {
            do {
                // 建立 AVCaptureDeviceInput
                let input = try AVCaptureDeviceInput(device: frontCamera)
                
                guard let captureSession = captureSession else { return }
                
                // 移除現有的 AVCaptureDeviceInput
                if let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput {
                    captureSession.removeInput(currentInput)
                }

                // 將 AVCaptureDeviceInput 設定為輸入裝置
                do {
                    let newInput = try AVCaptureDeviceInput(device: frontCamera)
                    captureSession.addInput(newInput)
                } catch {
                    print("無法創建 AVCaptureDeviceInput: \(error.localizedDescription)")
                }

                // 重新開始擷取
                captureSession.startRunning()
            } catch {
                print("無法創建 AVCaptureDeviceInput: \(error.localizedDescription)")
            }
        } else {
            print("找不到前置鏡頭")
        }
        
    }
    
    @objc func frontCameraButtonTouchUpInside() {
        
        // 獲取所有可用的攝像頭設備
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        let availableDevices = discoverySession.devices
        
        if switchToFrontCamera == true {
            
            // 選擇前置鏡頭設備
            if let frontCamera = availableDevices.first(where: { $0.position == .front }) {
                do {
                    // 建立 AVCaptureDeviceInput
                    let input = try AVCaptureDeviceInput(device: frontCamera)
                    
                    guard let captureSession = captureSession else { return }
                    
                    // 移除現有的 AVCaptureDeviceInput
                    if let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput {
                        print(currentInput)
                        captureSession.removeInput(currentInput)
                    }

                    // 將 AVCaptureDeviceInput 設定為輸入裝置
                    do {
                        let newInput = try AVCaptureDeviceInput(device: frontCamera)
                        captureSession.addInput(newInput)
                    } catch {
                        print("無法創建 AVCaptureDeviceInput: \(error.localizedDescription)")
                    }

                    // 重新開始擷取
                    captureSession.startRunning()
                } catch {
                    print("無法創建 AVCaptureDeviceInput: \(error.localizedDescription)")
                }
            } else {
                print("找不到前置鏡頭")
            }
            
        } else {
            
            // 選擇前置鏡頭設備
            if let backCamera = availableDevices.first(where: { $0.position == .back }) {
                do {
                    // 建立 AVCaptureDeviceInput
                    let input = try AVCaptureDeviceInput(device: backCamera)
                    
                    guard let captureSession = captureSession else { return }
                    
                    // 移除現有的 AVCaptureDeviceInput
                    if let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput {
                        print(currentInput)
                        captureSession.removeInput(currentInput)
                        print("🍸", availableDevices)
                    }

                    // 將 AVCaptureDeviceInput 設定為輸入裝置
                    do {
                        let newInput = try AVCaptureDeviceInput(device: backCamera)
                        captureSession.addInput(newInput)
                    } catch {
                        print("無法創建 AVCaptureDeviceInput: \(error.localizedDescription)")
                    }

                    // 重新開始擷取
                    captureSession.startRunning()
                } catch {
                    print("無法創建 AVCaptureDeviceInput: \(error.localizedDescription)")
                }
            } else {
                print("找不到鏡頭")
            }
            
        }
        
        switchToFrontCamera.toggle()
    }

    @objc func albumButtonTouchUpInside() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @objc func trashButtonTouchUpInside() {
        murmurImageView.isHidden = true
        murmurView.isHidden = false
        self.captureButton.isEnabled = true
    }
    
    @objc func captureButtonTouchUpInside() {
            guard let captureOutput = captureOutput else { return }
            
            let settings = AVCapturePhotoSettings()
            captureOutput.capturePhoto(with: settings, delegate: self)
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
        
        // 設定輸出
        captureOutput = AVCapturePhotoOutput()
        captureSession.addOutput(captureOutput!)
        
        // 設定預覽層
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer?.frame = murmurView.layer.bounds
        murmurView.layer.addSublayer(previewLayer!)
        
        // 啟動 AVCaptureSession
        DispatchQueue.global().async {
            captureSession.startRunning()
        }
        
    }
    
//    @objc func cameraButtonTouchUpInside() {
//        // 建立一個 UIImagePickerController 的實體
//        let imagePickerController = UIImagePickerController()
//
//        // 委任代理
//        imagePickerController.delegate = self
//
//        // 建立一個 UIAlertController 的實體
//        // 設定 UIAlertController 的標題與樣式為 動作清單 (actionSheet)
//        let imagePickerAlertController = UIAlertController(title: "上傳圖片", message: "請選擇要上傳的圖片", preferredStyle: .actionSheet)
//
//        // 建立三個 UIAlertAction 的實體
//        // 新增 UIAlertAction 在 UIAlertController actionSheet 的 動作 (action) 與標題
//        let imageFromLibAction = UIAlertAction(title: "照片圖庫", style: .default) { (void) in
//
//            // 判斷是否可以從照片圖庫取得照片來源
//            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//
//                // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.photoLibrary)，並 present UIImagePickerController
//                imagePickerController.sourceType = .photoLibrary
//                self.present(imagePickerController, animated: true, completion: nil)
//            }
//        }
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
//
//        // 新增一個取消動作，讓使用者可以跳出 UIAlertController
//        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (void) in
//
//            imagePickerAlertController.dismiss(animated: true, completion: nil)
//        }
//
//        // 將上面三個 UIAlertAction 動作加入 UIAlertController
//        imagePickerAlertController.addAction(imageFromLibAction)
//        imagePickerAlertController.addAction(imageFromCameraAction)
//        imagePickerAlertController.addAction(cancelAction)
//
//        // 當使用者按下 uploadBtnAction 時會 present 剛剛建立好的三個 UIAlertAction 動作與
//        present(imagePickerAlertController, animated: true, completion: nil)
//    }
    
    private func setNav() {

        self.navigationItem.title = "Murmurs" //"塗鴉留言"
        
        let closeButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonItemTouchUpInside))
        closeButtonItem.tintColor = .SecondaryLight
        navigationItem.leftBarButtonItem = closeButtonItem
        
        let nextButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonItemTouchUpInside))
        nextButtonItem.setTitleTextAttributes([NSAttributedString.Key.kern: 0, .font: UIFont.systemFont(ofSize: 18, weight: .medium)], for: .normal)
        nextButtonItem.tintColor = .GrayScale20
        navigationItem.rightBarButtonItem = nextButtonItem
    }
    
    @objc func closeButtonItemTouchUpInside() {
//        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.selectedIndex = 0
    }
    
    @objc func nextButtonItemTouchUpInside() {

        if murmurTextField.text == "" {
            murmurTextField.placeholder = "Speak up your mind to do next step"
            return
        } else {
            postTagVC.murmurData["murmurMessage"] = murmurTextField.text
            postTagVC.murmurData["murmurImage"] = self.seclectedImageUrl ?? ""
            self.seclectedImageUrl = ""
            self.navigationController?.pushViewController(postTagVC, animated: true)
        }
        
    }
    
    private func layout() {
        
        self.view.backgroundColor = .PrimaryLight
        
        [murmurTextField, murmurImageView, murmurView, trashButton, frontCameraButton, stack].forEach { subview in
            self.view.addSubview(subview)
        }
        [albumButton, separaterbar, captureButton].forEach { subview in
            stack.addArrangedSubview(subview)
        }
        
        murmurTextField.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(self.view).offset(16)
            make.trailing.equalTo(self.view).offset(-16)
            make.bottom.equalTo(murmurView.snp.top).offset(-8)
//            make.height.equalTo(160)
        }
        murmurView.snp.makeConstraints { make in
//            make.top.equalTo(murmurTextField.snp.bottom).offset(8)
            make.leading.equalTo(self.view).offset(24)
            make.trailing.equalTo(self.view).offset(-24)
            make.height.equalTo(murmurView.snp.width)
        }
        murmurImageView.snp.makeConstraints { make in
//            make.top.equalTo(murmurTextField.snp.bottom).offset(8)
            make.leading.equalTo(self.view).offset(24)
            make.trailing.equalTo(self.view).offset(-24)
            make.height.equalTo(murmurImageView.snp.width)
            make.bottom.equalTo(murmurView)
        }
//        trashButton.snp.makeConstraints { make in
//            make.width.height.equalTo(28)
//            make.top.equalTo(murmurView).offset(6)
//            make.trailing.equalTo(murmurView).offset(-6)
//        }
        trashButton.snp.makeConstraints { make in
            make.width.height.equalTo(28)
            make.bottom.equalTo(murmurView).offset(8)
            make.leading.equalTo(murmurView).offset(32)
        }
        frontCameraButton.snp.makeConstraints { make in
            make.width.height.equalTo(28)
            make.bottom.equalTo(murmurView).offset(8)
            make.trailing.equalTo(murmurView).offset(-32)
        }
        stack.snp.makeConstraints { make in
            make.top.equalTo(murmurView.snp.bottom).offset(24)
            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-24)
        }
        captureButton.snp.makeConstraints { make in
            make.width.equalTo(64)
            make.height.equalTo(48)
        }
        separaterbar.snp.makeConstraints { make in
            make.width.equalTo(2)
            make.height.equalTo(48)
        }
        albumButton.snp.makeConstraints { make in
            make.width.equalTo(64)
            make.height.equalTo(48)
        }
    }

}

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // [String : Any]
        
        var selectedImageFromPicker: UIImage?
        
        // 取得從 UIImagePickerController 選擇的檔案
//        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            
//            selectedImageFromPicker = pickedImage
//        }
        
        // 可以自動產生一組獨一無二的 ID 號碼，方便等一下上傳圖片的命名
        let uniqueString = NSUUID().uuidString
        
        // 當判斷有 selectedImage 時，我們會在 if 判斷式裡將圖片上傳
//        if let selectedImage = selectedImageFromPicker {
//
//            print("\(uniqueString), \(selectedImage)")
//        }
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // 在此處理選取的照片
            murmurImageView.isHidden = false
            murmurView.isHidden = true
            murmurImageView.image = selectedImage
            self.captureButton.isEnabled = false
            postTagVC.uploadImage = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension PostViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            
            let originalImage = UIImage(data: imageData)
            
//            guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
            print("📷", availableDevices)
            print("📷", availableDevices.first!.position.rawValue)
//            if let captureDeviceInput = captureSession!.inputs.first as? AVCaptureDeviceInput {
//                let backCamera = captureDeviceInput.device
//               
//            }
            guard let captureDeviceInput = captureSession!.inputs.first as? AVCaptureDeviceInput else { return }
            let backCamera = captureDeviceInput.device
            
            do {
                if captureDeviceInput.device.position.rawValue == 2 {
//                let currentInput = try AVCaptureDeviceInput(device: captureDevice)
//                if captureSession?.inputs.first != currentInput {
                    
                    // 如果是前置鏡頭拍攝，進行水平翻轉
                    if let flippedImage = originalImage?.flippedHorizontally() {
                        // 在此處理拍攝後的照片
                        murmurImageView.isHidden = false
                        murmurView.isHidden = true
                        murmurImageView.image = flippedImage
                        self.captureButton.isEnabled = false
                        
                        // 將照片傳給下一頁 postTagVC
                        postTagVC.uploadImage = flippedImage
                    }
                    
                } else {
                    
                    // 非前置鏡頭拍攝的照片不進行處理，直接顯示在畫面上
                    murmurImageView.isHidden = false
                    murmurView.isHidden = true
                    murmurImageView.image = originalImage
                    self.captureButton.isEnabled = false
                    
                    // 將照片傳給下一頁 postTagVC
                    postTagVC.uploadImage = originalImage
                    
                }
            } catch {
                print("無法獲取 currentInput")
            }
            
        }
        
    }
}

extension UIImage {
    
    func flippedHorizontally() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // 繪製翻轉的圖片
        context.translateBy(x: size.width, y: 0)
        context.scaleBy(x: -1, y: 1)
        draw(in: CGRect(origin: .zero, size: size))
        
        let flippedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return flippedImage
    }
}
