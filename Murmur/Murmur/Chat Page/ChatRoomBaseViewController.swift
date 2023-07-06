//
//  ChatBaseViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/26.
//

import UIKit
import SnapKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class ChatRoomBaseViewController: UIViewController {
    
    var otherUserUID = String()
    var otherUserName = String()
    var otherUserImageURL = String()
    var chatRoomID: String?
    
    let database = Firestore.firestore()

    private var messageTypeArray = [String]()
    private var messageDataArray = [String]()
    var messageDataResult: [Messages] = []
    private var meReplyText = String()
    
    let chatRoomTableView: SelfSizingTableView = {
        let chatRoomTableView = SelfSizingTableView()
        chatRoomTableView.separatorStyle = .none
        chatRoomTableView.allowsSelection = false
        chatRoomTableView.backgroundColor = .SecondaryLight
        return chatRoomTableView
    }()
    private let typingAreaView: UIView = {
        let typingAreaView = UIView()
        typingAreaView.backgroundColor = .PrimaryDefault
        typingAreaView.layer.shadowOpacity = 0.5
        typingAreaView.layer.shadowOffset = CGSizeMake(0, -4)
        typingAreaView.layer.shadowRadius = 10
        return typingAreaView
    }()
    private let typingTextField: MessageTypeTextField = {
        let typingTextField = MessageTypeTextField()
        typingTextField.backgroundColor = .GrayScale20
        typingTextField.textColor = .GrayScale90
        typingTextField.layer.cornerRadius = 15
        typingTextField.layer.borderColor = UIColor.SecondaryDefault?.cgColor
        typingTextField.layer.borderWidth = 2
        
        return typingTextField
    }()
    private let sendButton: UIButton = {
        let sendButton = UIButton()
        sendButton.setBackgroundImage(UIImage(named: "Icons_Unsend.png"), for: .normal)
        sendButton.setBackgroundImage(UIImage(named: "Icons_Send.png"), for: .highlighted)
        sendButton.tintColor = UIColor(cgColor: CGColor(red: 85/255, green: 107/255, blue: 47/255, alpha: 1))
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        sendButton.layer.addShineShadow()
        
        return sendButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatRoomTableView.delegate = self
        chatRoomTableView.dataSource = self
        typingTextField.delegate = self
        
        setNav()
        setTypingArea()
        setTableView()
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true

        getRealTimeChatMessages()  // 因為要隨時監聽是否有新訊息，所以跳到其他頁面就先不關掉監聽？
    }

    private func setNav() {

        // 创建自定义视图
        let customView = UIView()

        // 创建图像视图
        let imageView = UIImageView()
        imageView.kf.setImage(with: URL(string: otherUserImageURL))
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30) // 根据需要设置图像视图的尺寸
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderColor = UIColor.PrimaryMiddle?.cgColor
        imageView.layer.borderWidth = 2

        // 创建标签视图
        let label = UILabel()
        label.textAlignment = .left
        label.text = otherUserName
        label.textColor = .GrayScale20
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
    
    private func setTypingArea() {
        
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
    
        // 傳送訊息則 create chatroom data to firebase，chatroom document 名稱為 點擊的用戶 UUID
        // ?? create 三筆資料到：自己 chatRooms 的 document、對方 chatRooms 的 document、chatRooms 的 document (includes comments)
        // 刪除或編輯訊息，只要去 chatRooms 的 document 的 comments collection 去更改就好
        // 監聽到聊天室有資料變動，則 load 那一筆變動的資料
        
        guard let text = typingTextField.text,
              !(text.isEmpty) else { return }
        
        addChatMessages()

        typingTextField.text = ""
    }
    
    // 發送訊息
    private func addChatMessages() {
        guard let chatRoomID else {
            print("目前還沒有房間ID")
            return
        }
        print("聊天室 ID", chatRoomID)
        database.collection("chatRooms").document(chatRoomID).collection("messages").document().setData([
            "createTime": Timestamp(date: Date()),
            "messageContent": typingTextField.text,
            "senderUUID": currentUserUID
        ])
    }
    
    private func getRealTimeChatMessages() {
        print(chatRoomID)
        
        guard let chatRoomID else {
            print("目前還沒有房間ID")
            return
        }
        
        database.collection("chatRooms").document(chatRoomID).collection("messages").order(by: "createTime", descending: false).addSnapshotListener { documentSnapshot, error in
            if let documentSnapshot = documentSnapshot {
                for document in documentSnapshot.documents {
//                    print(document.data())
                }
            } else {
                return
            }
            let messages = documentSnapshot?.documents.compactMap { querySnapshot in
                try? querySnapshot.data(as: Messages.self)
            }
            
//            self.messageDataResult = messages!
//            print("?? 解析完後的資料", self.messageDataResult)
    
            DispatchQueue.main.async { [self] in
                
                self.messageTypeArray = [String]()
                self.messageDataArray = [String]()
                
                for message in messages! {
                    print("聊天室的每一則訊息", message.messageContent)
//                    self.messageTypeArray.append(message.senderUUID)
//                    self.messageDataArray.append(message.messageContent)
                    self.messageTypeArray.insert(message.senderUUID, at: 0)
                    self.messageDataArray.insert(message.messageContent, at: 0)
                }
                self.chatRoomTableView.reloadData()
                // tableView upsidedown 之後就不用 scroll 到最下面
//                self.chatRoomTableView.scrollToRow(at: IndexPath(row: self.messageTypeArray.count - 1, section: 0), at: .bottom, animated: true)
            }
            
        }
    }
    
    private func setTableView() {
        
        // MARK: tableView upsideDown
        chatRoomTableView.transform = CGAffineTransform(rotationAngle: .pi)
        
        chatRoomTableView.register(UserMeChatTableViewCell.self, forCellReuseIdentifier: "\(UserMeChatTableViewCell.self)")
        chatRoomTableView.register(UserTheOtherTableViewCell.self, forCellReuseIdentifier: "\(UserTheOtherTableViewCell.self)")
        
        self.view.addSubview(chatRoomTableView)
        
        chatRoomTableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.lessThanOrEqualTo(typingAreaView.snp.top)
//            make.bottom.equalTo(typingAreaView.snp.top)
            make.leading.equalTo(self.view.safeAreaLayoutGuide)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }

    }

}

extension ChatRoomBaseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("訊息數量", messageTypeArray.count)
        return messageTypeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let messageType = messageTypeArray[indexPath.row]
        print("訊息寄送者UUID為", messageTypeArray)
        
        switch messageType {
        case currentUserUID:
            // TODO: 寫法??
            if let cell = tableView.dequeueReusableCell(withIdentifier: "\(UserMeChatTableViewCell.self)", for: indexPath) as? UserMeChatTableViewCell {
                cell.dialogTextView.text = messageDataArray[indexPath.row]
                cell.layoutCell()
                cell.contentView.transform = CGAffineTransform(rotationAngle: .pi)
                return cell
            } else { return UITableViewCell.init() }
            
        case otherUserUID:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "\(UserTheOtherTableViewCell.self)", for: indexPath) as? UserTheOtherTableViewCell {
                cell.dialogTextView.text = messageDataArray[indexPath.row]
                cell.profileImageView.kf.setImage(with: URL(string: otherUserImageURL))
                cell.layoutCell()
                cell.contentView.transform = CGAffineTransform(rotationAngle: .pi)
                return cell
            } else { return UITableViewCell.init() }
            
        default:
            let cell = UserMeChatTableViewCell.init(style: .default, reuseIdentifier: "\(UserMeChatTableViewCell.self)")
            cell.contentView.transform = CGAffineTransform(rotationAngle: .pi)
            return cell
        }
    }
    
}

extension ChatRoomBaseViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       self.view.endEditing(true)
       return true
    }
    
}
