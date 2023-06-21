//
//  PostViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/15.
//

import UIKit

class PostViewController: UIViewController {
    
    private let murmurTextField: UITextField = {
        let murmurTextField = UITextField()
        murmurTextField.placeholder = "想說什麼大聲說出來"
        murmurTextField.contentVerticalAlignment = .top
        return murmurTextField
    }()
    private let murmurImageView: UIImageView = {
        let murmurImageView = UIImageView()
        murmurImageView.image = UIImage(named: "test1.jpg")
        murmurImageView.contentMode = .scaleAspectFill
        murmurImageView.clipsToBounds = true
        return murmurImageView
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
    private let cameraButton: UIButton = {
        let cameraButton = UIButton(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        cameraButton.setImage(UIImage(named: "Icons_Camera.png"), for: .normal)
        return cameraButton
    }()
    
    let postTagVC = PostTagViewController()
    
    var sendMurmurMessageClosure: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        setNav()
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        murmurImageView.layer.cornerRadius = murmurImageView.frame.width / 2
        murmurImageView.layer.borderColor = UIColor.lightGray.cgColor
        murmurImageView.layer.borderWidth = 3
    }
    
    private func setNav() {
//        let navigationController = UINavigationController(rootViewController: self)
//        navigationController.modalPresentationStyle = .fullScreen
//        navigationController.navigationBar.barStyle = .default
//        navigationController.navigationBar.backgroundColor = .blue
        
//        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.backgroundColor = .white
//        UINavigationBar.appearance().isTranslucent = false
//        UINavigationBar.appearance().barTintColor = .red
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithDefaultBackground()
//        navBarAppearance.backgroundColor = .red
        navBarAppearance.backgroundEffect = UIBlurEffect(style: .regular)
        navBarAppearance.titleTextAttributes = [
           .foregroundColor: UIColor.black,
           .font: UIFont.systemFont(ofSize: 18, weight: .regular)
        ]
        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        self.navigationItem.title = "塗鴉留言"
        
        let closeButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonItemTouchUpInside))
        closeButtonItem.tintColor = .black
        navigationItem.leftBarButtonItem = closeButtonItem
        
        let nextButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonItemTouchUpInside))
        nextButtonItem.setTitleTextAttributes([NSAttributedString.Key.kern: 0, .font: UIFont.systemFont(ofSize: 18, weight: .medium)], for: .normal)
        nextButtonItem.tintColor = .purple
        navigationItem.rightBarButtonItem = nextButtonItem
    }
    
    @objc func closeButtonItemTouchUpInside() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func nextButtonItemTouchUpInside() {
//        self.sendMurmurMessageClosure?(murmurTextField.text!)
        postTagVC.murmurData["murmurMessage"] = murmurTextField.text
        self.navigationController?.pushViewController(postTagVC, animated: true)
    }
    
    private func layout() {
        [murmurTextField, murmurImageView, stack].forEach { subview in
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
        murmurImageView.snp.makeConstraints { make in
            make.top.equalTo(murmurTextField.snp.bottom).offset(8)
            make.leading.equalTo(self.view).offset(32)
            make.trailing.equalTo(self.view).offset(-32)
            make.height.equalTo(murmurImageView.snp.width)
        }
        stack.snp.makeConstraints { make in
            make.top.equalTo(murmurImageView.snp.bottom).offset(24)
            make.centerX.equalTo(self.view.snp.centerX)
        }
    }

}
