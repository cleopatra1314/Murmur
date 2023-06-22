//
//  ChatRoomViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/15.
//

import UIKit
import SnapKit

class ChatRoomViewController: UIViewController {
    
    var dataTypeArray = ["default1", "default2"]
//    var dataResult: [Model] = []
    
    let chatRoomTableView: UITableView = {
        let chatRoomTableView = UITableView()
        chatRoomTableView.separatorStyle = .none
        chatRoomTableView.allowsSelection = false
        return chatRoomTableView
    }()
    let typingAreaView: UIView = {
        let typingAreaView = UIView()
        typingAreaView.backgroundColor = .white
        typingAreaView.layer.shadowOpacity = 0.5
        typingAreaView.layer.shadowOffset = CGSizeMake(0, -4)
        typingAreaView.layer.shadowRadius = 10
        
        return typingAreaView
    }()
    let typingTextField: MessageTypeTextField = {
        let typingTextField = MessageTypeTextField()
        typingTextField.backgroundColor = UIColor(cgColor: CGColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1))
        typingTextField.layer.cornerRadius = 20
        
        return typingTextField
    }()
    let sendButton: UIButton = {
        let sendButton = UIButton()
        sendButton.setBackgroundImage(UIImage(named: "Icons_Unsend.png"), for: .normal)
        sendButton.setBackgroundImage(UIImage(named: "Icons_Send.png"), for: .highlighted)
        sendButton.tintColor = UIColor(cgColor: CGColor(red: 85/255, green: 107/255, blue: 47/255, alpha: 1))
        
        return sendButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatRoomTableView.delegate = self
        chatRoomTableView.dataSource = self
        
        self.view.backgroundColor = .orange
        setNav()
        setTypingArea()
        setTableView()
    }

    func setNav() {
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor(cgColor: CGColor(red: 1, green: 1, blue: 1, alpha: 1))
        
        let closeButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeBtnTouchUpInside))
        closeButtonItem.tintColor = .black
        self.navigationItem.leftBarButtonItem = closeButtonItem
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithDefaultBackground()
//        navBarAppearance.backgroundColor = .red
        navBarAppearance.backgroundEffect = UIBlurEffect(style: .regular)
        navBarAppearance.titleTextAttributes = [
           .foregroundColor: UIColor.black,
           .font: UIFont(name: "Roboto", size: 24)
//           .font: UIFont.systemFont(ofSize: 40, weight: .regular)
           
        ]
        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
//        self.navigationItem.title = "塗鴉留言"
        
        // 创建自定义视图
        let customView = UIView()

        // 创建图像视图
        let imageView = UIImageView(image: UIImage(named: "User1Portrait.png"))
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30) // 根据需要设置图像视图的尺寸
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderColor = UIColor.green.cgColor
        imageView.layer.borderWidth = 2

        // 创建标签视图
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Libby"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.sizeToFit()

        // 将图像视图和标签视图添加到自定义视图
        customView.addSubview(imageView)
        customView.addSubview(label)

        // 设置自定义视图的布局约束
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false

        // 图像视图的约束
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: customView.leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: customView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 36),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1)
        ])

        // 标签视图的约束
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: customView.centerYAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: customView.trailingAnchor),
            label.widthAnchor.constraint(equalToConstant: 240)
        ])

        // 将自定义视图设置为导航栏的标题视图
        navigationItem.titleView = customView

    }
    
    @objc func closeBtnTouchUpInside() {
        dismiss(animated: true)
    }
    
    func setTypingArea() {
        
        self.view.addSubview(typingAreaView)
        typingAreaView.addSubview(typingTextField)
        typingAreaView.addSubview(sendButton)
        
        typingAreaView.translatesAutoresizingMaskIntoConstraints = false
        typingTextField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            typingAreaView.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -94),
            typingAreaView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            typingAreaView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            typingAreaView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            typingTextField.leadingAnchor.constraint(equalTo: typingAreaView.leadingAnchor, constant: 16),
            typingTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -16),
            typingTextField.topAnchor.constraint(equalTo: typingAreaView.topAnchor, constant: 12),
            typingTextField.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            sendButton.trailingAnchor.constraint(equalTo: typingAreaView.trailingAnchor, constant: -16),
            //            sendButton.topAnchor.constraint(equalTo: typingAreaView.topAnchor, constant: 8),
            //            sendButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            sendButton.centerYAnchor.constraint(equalTo: typingTextField.centerYAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 28),
            sendButton.widthAnchor.constraint(equalTo: sendButton.heightAnchor, multiplier: 1)
        ])
        
    }
    
    @objc func sendButtonTapped() {
        guard let text = typingTextField.text,
              !(text.isEmpty) else { return }
        print(text)
        typingTextField.text = ""
        dataTypeArray.append("meReply")
//        dataResult.append(Model.product(Product(id: 0, title: text, description: "", price: 0, texture: "", wash: "", place: "", note: "", story: "", colors: [], sizes: [], variants: [], mainImage: "", images: [], type: "")))
//        chatBotTableView.reloadData()
//        chatBotTableView.scrollToRow(at: IndexPath(row: dataTypeArray.count - 1, section: 0), at: .bottom, animated: true)
    }
    
    func setTableView() {
        
        chatRoomTableView.register(UserMeChatTableViewCell.self, forCellReuseIdentifier: "\(UserMeChatTableViewCell.self)")
        chatRoomTableView.register(UserTheOtherTableViewCell.self, forCellReuseIdentifier: "\(UserTheOtherTableViewCell.self)")
        
        self.view.addSubview(chatRoomTableView)
        
        chatRoomTableView.snp.makeConstraints { make in
//            make.top.equalTo((self.navigationController?.navigationBar.snp.bottom)!)
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(typingAreaView.snp.top)
            make.leading.equalTo(self.view.safeAreaLayoutGuide)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }

    }

}

extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
}
