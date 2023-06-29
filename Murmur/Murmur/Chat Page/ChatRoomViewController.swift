//
//  ChatRoomViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/15.
//

import UIKit
import SnapKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class ChatRoomViewController: UIViewController {
    
    var isFirstMessage = true
    var otherUserUID = String()
    var otherUserName = String()
    var otherUserImageURL = String()
    var chatRoomID: String?
    
    let database = Firestore.firestore()

    private var messageTypeArray = [String]()
    private var messageDataArray = [String]()
    var messageDataResult: [Messages] = []
    private var meReplyText = String()
    
    private let chatRoomTableView: UITableView = {
        let chatRoomTableView = UITableView()
        chatRoomTableView.separatorStyle = .none
        chatRoomTableView.allowsSelection = false
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
        typingTextField.textColor = .GrayScale80
        typingTextField.backgroundColor = .GrayScale20
        typingTextField.layer.cornerRadius = 20
        
        return typingTextField
    }()
    private let sendButton: UIButton = {
        let sendButton = UIButton()
        sendButton.setBackgroundImage(UIImage(named: "Icons_Unsend.png"), for: .normal)
        sendButton.setBackgroundImage(UIImage(named: "Icons_Send.png"), for: .highlighted)
        sendButton.setTitleColor(.SecondaryDark, for: .normal)
        sendButton.setTitleColor(.SecondaryDefault, for: .highlighted)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        
        return sendButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatRoomTableView.delegate = self
        chatRoomTableView.dataSource = self
        typingTextField.delegate = self
        
        self.view.backgroundColor = .orange
        setNav()
        setTypingArea()
        setTableView()
        
    }

    private func setNav() {
        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.barTintColor = .PrimaryDark
        
        let closeButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeBtnTouchUpInside))
        closeButtonItem.tintColor = .GrayScale20
        self.navigationItem.leftBarButtonItem = closeButtonItem
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithDefaultBackground()
        navBarAppearance.backgroundColor = .PrimaryDark
        navBarAppearance.backgroundEffect = UIBlurEffect(style: .regular)
        navBarAppearance.titleTextAttributes = [
           .foregroundColor: UIColor.GrayScale20,
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
        imageView.layer.borderColor = UIColor.PrimaryMiddle?.cgColor
        imageView.layer.borderWidth = 2

        // 创建标签视图
        let label = UILabel()
        label.textAlignment = .left
        label.text = otherUserName
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
        
        if isFirstMessage {
            createChatRoom()
            getRealTimeChatMessages()
            isFirstMessage.toggle()
        } else {
            addChatMessages()
        }
    
        messageDataArray.append(text)
        messageTypeArray.append("meReply")
        typingTextField.text = ""

        chatRoomTableView.reloadData()
        chatRoomTableView.scrollToRow(at: IndexPath(row: messageTypeArray.count - 1, section: 0), at: .bottom, animated: true)
    }
    
    private func createChatRoom() {
        
        // chatRooms 的 document (includes comments)
        let documentReference = database.collection("chatRooms").document()
        let documentReferenceOfMessages = documentReference.collection("messages").document()
        
        documentReference.setData([
            "createTime": Timestamp(date: Date())
        ])
        
        documentReferenceOfMessages.setData([
            "createTime": Timestamp(date: Date()),
            "messageContent": typingTextField.text,
            "senderUUID": currentUserUID
        ])
        
        chatRoomID = documentReference.documentID
        let messageID = documentReferenceOfMessages.documentID
        guard let chatRoomID else {
            print("Error: ChatRoomID is nil.")
            return
        }
        
        // 自己 chatRooms 的 document
        database.collection("userTest").document(currentUserUID).collection("chatRooms").document(chatRoomID).setData([
            "createTime": Timestamp(date: Date()),
            "theOtherUserUID": otherUserUID
        ])
        
        // 對方 chatRooms 的 document
        database.collection("userTest").document(otherUserUID).collection("chatRooms").document(chatRoomID).setData([
            "createTime": Timestamp(date: Date()),
            "theOtherUserUID": currentUserUID
        ])
        
    }
    
    private func addChatMessages() {
        guard let chatRoomID else {
            print("Error: ChatRoomID is nil.")
            return
        }
       
        database.collection("chatRooms").document(chatRoomID).collection("messages").document().setData([
            "createTime": Timestamp(date: Date()),
            "messageContent": typingTextField.text,
            "senderUUID": currentUserUID
        ])
    }
    
    private func getRealTimeChatMessages() {
        print(chatRoomID)
        
        guard let chatRoomID else {
            print("Error: ChatRoomID is nil.")
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
            
            self.messageDataResult = messages!
            
            DispatchQueue.main.async {
                
                self.messageTypeArray = [String]()
                self.messageDataArray = [String]()
                
                for message in self.messageDataResult {
                    self.messageTypeArray.append(message.senderUUID)
                    self.messageDataArray.append(message.messageContent)
                }
                self.chatRoomTableView.reloadData()
            }
            
        }
    }
    
    private func setTableView() {
        
//        chatRoomTableView.backgroundColor = .PrimaryDefault
        
        chatRoomTableView.register(UserMeChatTableViewCell.self, forCellReuseIdentifier: "\(UserMeChatTableViewCell.self)")
        chatRoomTableView.register(UserTheOtherTableViewCell.self, forCellReuseIdentifier: "\(UserTheOtherTableViewCell.self)")
        
        self.view.addSubview(chatRoomTableView)
        
        chatRoomTableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(typingAreaView.snp.top)
            make.leading.equalTo(self.view.safeAreaLayoutGuide)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }

    }

}

extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messageTypeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let messageType = messageTypeArray[indexPath.row]
        
        switch messageType {
        case currentUserUID:
            // TODO: 寫法??
            if let cell = tableView.dequeueReusableCell(withIdentifier: "\(UserMeChatTableViewCell.self)", for: indexPath) as? UserMeChatTableViewCell {
                cell.dialogTextView.text = messageDataResult[indexPath.row].messageContent
                
                return cell
            } else {
                print("Error: tableView fails to dequeueReusableCell to type UserMeChatTableViewCell.")
                return UITableViewCell.init()
            }
            
        case otherUserUID:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "\(UserTheOtherTableViewCell.self)", for: indexPath) as? UserTheOtherTableViewCell {
                cell.dialogTextView.text = messageDataArray[indexPath.row]
                cell.profileImageView.image = UIImage(named: "User1Portrait.png")
                cell.layoutCell()
                cell.layoutIfNeeded()
                
                return cell
            } else {
                print("Error: tableView fails to dequeueReusableCell to type UserTheOtherTableViewCell.")
                return UITableViewCell.init()
            }
            
        default:
            let cell = UserMeChatTableViewCell.init(style: .default, reuseIdentifier: "\(UserMeChatTableViewCell.self)")
            return cell
        }
    }
    
}

extension ChatRoomViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       self.view.endEditing(true)
       return true
    }
    
}
