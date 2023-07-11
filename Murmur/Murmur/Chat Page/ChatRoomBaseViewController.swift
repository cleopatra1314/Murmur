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
    
    var keyboardSize = CGSize()
    
    var newChatRoomTableViewBottomConstraint = NSLayoutConstraint()
    var chatRoomTableViewTopConstraint = NSLayoutConstraint()
    var chatRoomTableViewBottomConstraint = NSLayoutConstraint()
    var typingAreaViewTopConstraint = NSLayoutConstraint()
    var typingAreaViewBottomConstraint = NSLayoutConstraint()
    var newTypingAreaViewTopConstraint = NSLayoutConstraint()
    var newTypingAreaViewBottomConstraint = NSLayoutConstraint()
    var safeAreaBottomInset = Double()
    var safeAreaHeight = Double()
    
    var isFirstMessage = false
    
    var rowOfindexPath: Int?
//    var latestMessageClosure: ((Messages, Int) -> Void)?
    
    var otherUserUID = String()
    var otherUserName = String()
    var otherUserImageURL = String()
    var chatRoomID: String?
    
    let database = Firestore.firestore()

    private var messageTypeArray = [String]()
    private var messageDataArray = [String]()
    private var messageCreateTimeArray = [Timestamp]()
//    var messageDataResult: [Messages] = []
//    private var meReplyText = String()

    let chatRoomTableView: SelfSizingTableView = {
        let chatRoomTableView = SelfSizingTableView()
        chatRoomTableView.separatorStyle = .none
        chatRoomTableView.allowsSelection = false
        chatRoomTableView.backgroundColor = .PrimaryLight
        return chatRoomTableView
    }()
    private let typingAreaView: UIView = {
        let typingAreaView = UIView()
        typingAreaView.backgroundColor = .PrimaryDefault
        typingAreaView.layer.shadowOpacity = 0.5
        typingAreaView.layer.shadowOffset = CGSizeMake(0, -4)
        typingAreaView.layer.shadowRadius = 10
        typingAreaView.layer.addBarShadow()
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        registerForKeyboardNotifications()
        
        chatRoomTableView.delegate = self
        chatRoomTableView.dataSource = self
        typingTextField.delegate = self
        
//        getRealTimeChatMessages()  // 因為要隨時監聽是否有新訊息，所以跳到其他頁面就先不關掉監聽？
//        setTypingArea()
        layoutView()
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFirstMessage == true {
            setNavCloseButton()
        }
        self.tabBarController?.tabBar.isHidden = true
        setNav()
        getRealTimeChatMessages()  // 因為要隨時監聽是否有新訊息，所以跳到其他頁面就先不關掉監聽？
    }
    
    // 取得 safeArea 距離
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        safeAreaBottomInset = view.safeAreaInsets.bottom
        safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.size.height
        print("size: \(view.safeAreaLayoutGuide.layoutFrame.size)")
        print("top: \(view.safeAreaInsets.top)")
        print("bottom: \(view.safeAreaInsets.bottom)")
        layoutView()
    }
    
    // 當點擊view任何喔一處鍵盤收起
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // 鍵盤收合
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // keyboard 出現時，輸入區跟著移動
    @objc func keyboardWasShown(_ notification: NSNotification) {
         guard let info = notification.userInfo,
               let keyboardFrameValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
         let keyboardFrame = keyboardFrameValue.cgRectValue
         keyboardSize = keyboardFrame.size
         let keyboardHeight = keyboardSize.height
        
        view.bringSubviewToFront(typingAreaView)
        
//        UIView.animate(withDuration: 0.3) { [self] in
//            self.typingAreaView.frame = CGRect(x: typingAreaView.frame.origin.x, y: keyboardHeight, width: self.view.frame.width, height: 94)
//        }
        
        // 訊息輸入區的移動
        UIView.animate(withDuration: 0.3) { [self] in
                // 更新 typingAreaView 的底部约束
            typingAreaViewTopConstraint.isActive = false
            typingAreaViewBottomConstraint.isActive = false
            newTypingAreaViewTopConstraint = typingAreaView.topAnchor.constraint(equalTo: self.typingTextField.topAnchor, constant: -8)
            newTypingAreaViewBottomConstraint = typingAreaView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -keyboardHeight)
            newTypingAreaViewTopConstraint.isActive = true
            newTypingAreaViewBottomConstraint.isActive = true
                self.view.layoutIfNeeded() // 触发自动布局更新，以实现动画效果
            }
        
        // 對話區的移動
        if chatRoomTableView.frame.height > (safeAreaHeight - keyboardHeight) {
            
            chatRoomTableViewTopConstraint.isActive = false
            chatRoomTableViewBottomConstraint.isActive = false
            newChatRoomTableViewBottomConstraint = chatRoomTableView.bottomAnchor.constraint(equalTo: typingAreaView.topAnchor)
            newChatRoomTableViewBottomConstraint.isActive = true
        }

    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
//        guard let info = notification.userInfo,
//              let keyboardFrameValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
//        let keyboardFrame = keyboardFrameValue.cgRectValue
//        let keyboardSize = keyboardFrame.size
//        let keyboardHeight = keyboardSize.height
//
//        UIView.animate(withDuration: 0.3) { [self] in
//            // 更新 typingAreaView 的底部约束
//            typingAreaView.topAnchor.constraint(equalTo: self.typingTextField.topAnchor, constant: -8).isActive = false
//                typingAreaView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -keyboardHeight).isActive = false
//            typingAreaView.topAnchor.constraint(equalTo: self.typingTextField.topAnchor, constant: -8).isActive = true
//            typingAreaView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//            self.view.layoutIfNeeded() // 触发自动布局更新，以实现动画效果
//        }
        
        // 移除底部约束，使 typingAreaView 回到原始位置
//            typingAreaView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        // 訊息輸入區的移動
            UIView.animate(withDuration: 0.3) { [self] in
                typingAreaViewTopConstraint.isActive = true
                typingAreaViewBottomConstraint.isActive = true
                newTypingAreaViewTopConstraint.isActive = false
                newTypingAreaViewBottomConstraint.isActive = false
                self.view.layoutIfNeeded() // 触发自动布局更新，以实现动画效果
            }
        
        // TODO: 對話區的移動
        if chatRoomTableView.frame.height > ( keyboardSize.height + 100) {
            
            chatRoomTableViewTopConstraint.isActive = true
            chatRoomTableViewBottomConstraint.isActive = true
            newChatRoomTableViewBottomConstraint.isActive = false
        }
    }
    
    // 跟用戶傳出第一封訊息才要執行
    private func createChatRoom(textSending: String) {
        
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
            "theOtherUserUID": otherUserUID,
            "latestMessageCreateTime": Timestamp(date: Date()),
            "latestMessageContent": textSending,
            "latestMessageSenderUUID": currentUserUID
        ])
        
        // 對方 chatRooms 的 document
        database.collection("userTest").document(otherUserUID).collection("chatRooms").document(chatRoomID).setData([
            "createTime": Timestamp(date: Date()),
            "theOtherUserUID": currentUserUID,
            "latestMessageCreateTime": Timestamp(date: Date()),
            "latestMessageContent": textSending,
            "latestMessageSenderUUID": currentUserUID
        ])
        
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
    
    private func setNavCloseButton() {
        
        self.navigationController?.navigationBar.isTranslucent = true
        
        let closeButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeBtnTouchUpInside))
        closeButtonItem.tintColor = .GrayScale20
        self.navigationItem.leftBarButtonItem = closeButtonItem
        
    }
    
    @objc func closeBtnTouchUpInside() {
        dismiss(animated: true)
    }
    
//    private func setTypingArea() {
//
//        self.view.addSubview(typingAreaView)
//        typingAreaView.addSubview(typingTextField)
//        typingAreaView.addSubview(sendButton)
//
//        typingAreaView.translatesAutoresizingMaskIntoConstraints = false
//        typingTextField.translatesAutoresizingMaskIntoConstraints = false
//        sendButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
////            typingAreaView.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -94),
//            typingAreaView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            typingAreaView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
////            typingAreaView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
//            typingTextField.leadingAnchor.constraint(equalTo: typingAreaView.leadingAnchor, constant: 16),
//            typingTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -16),
//            typingTextField.topAnchor.constraint(equalTo: typingAreaView.topAnchor, constant: 12),
//            typingTextField.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
//            sendButton.trailingAnchor.constraint(equalTo: typingAreaView.trailingAnchor, constant: -16),
//            //            sendButton.topAnchor.constraint(equalTo: typingAreaView.topAnchor, constant: 8),
//            //            sendButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
//            sendButton.centerYAnchor.constraint(equalTo: typingTextField.centerYAnchor),
//            sendButton.heightAnchor.constraint(equalToConstant: 28),
//            sendButton.widthAnchor.constraint(equalTo: sendButton.heightAnchor, multiplier: 1)
//        ])
//        let typingAreaViewTopConstraint = typingAreaView.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -94)
//        let typingAreaViewBottomConstraint = typingAreaView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
//        typingAreaViewTopConstraint.isActive = true
//        typingAreaViewBottomConstraint.isActive = true
//
//    }
    
    @objc func sendButtonTapped() {
        // 傳送訊息則 create chatroom data to firebase，chatroom document 名稱為 點擊的用戶 UUID
        // ?? create 三筆資料到：自己 chatRooms 的 document、對方 chatRooms 的 document、chatRooms 的 document (includes comments)
        // 刪除或編輯訊息，只要去 chatRooms 的 document 的 comments collection 去更改就好
        // 監聽到聊天室有資料變動，則 load 那一筆變動的資料
        
        guard let text = typingTextField.text,
              !(text.isEmpty) else { return }
  
        if isFirstMessage == true {
            createChatRoom(textSending: typingTextField.text!)
            isFirstMessage.toggle()
            
        } else {
            addChatMessages(textSending: typingTextField.text!)
        }
        
        typingTextField.text = ""
       
    }
    
    // 發送訊息
    private func addChatMessages(textSending: String) {
        guard let chatRoomID else {
            print("目前還沒有房間ID")
            return
        }
        
        // chatRooms 建立 messages 檔案
        database.collection("chatRooms").document(chatRoomID).collection("messages").document().setData([
            "createTime": Timestamp(date: Date()),
            "messageContent": textSending,
            "senderUUID": currentUserUID
        ])
        
        // 在自己的 chatRooms 建立 latestMessages 檔案
        database.collection("userTest").document(currentUserUID).collection("chatRooms").document(chatRoomID).getDocument { [self] documentSnapshot, error in
            
            guard let documentSnapshot,
                  documentSnapshot.exists,
                  var chatRoomResult = try? documentSnapshot.data(as: ChatRooms.self)
            else {
                return
            }
            
            chatRoomResult.latestMessageCreateTime = Timestamp(date: Date())
            chatRoomResult.latestMessageContent = textSending
            chatRoomResult.latestMessageSenderUUID = currentUserUID
            
            // 修改 最新訊息info 資料
            self.database.collection("userTest").document(currentUserUID).collection("chatRooms").document(chatRoomID).updateData([
                
                "latestMessageCreateTime": Timestamp(date: Date()),
                "latestMessageContent": textSending,
                "latestMessageSenderUUID": currentUserUID
                
            ])
            
        }
        
        // 在對方的 chatRooms 建立 messages 檔案
        database.collection("userTest").document(otherUserUID).collection("chatRooms").document(chatRoomID).getDocument { [self] documentSnapshot, error in
            
            guard let documentSnapshot,
                  documentSnapshot.exists,
                  var chatRoomResult = try? documentSnapshot.data(as: ChatRooms.self)
            else {
                return
            }
            
            chatRoomResult.latestMessageCreateTime = Timestamp(date: Date())
            chatRoomResult.latestMessageContent = textSending
            chatRoomResult.latestMessageSenderUUID = currentUserUID
            
            // 修改 firebase 上大頭貼資料
            self.database.collection("userTest").document(self.otherUserUID).collection("chatRooms").document(chatRoomID).updateData([
                
                "latestMessageCreateTime": Timestamp(date: Date()),
                "latestMessageContent": textSending,
                "latestMessageSenderUUID": currentUserUID
                
            ])
            
        }
        
        
    }
    
    private func getRealTimeChatMessages() {
      
        guard let chatRoomID else {
            print("目前還沒有房間ID")
            return
        }
        
        database.collection("chatRooms").document(chatRoomID).collection("messages").order(by: "createTime", descending: false).addSnapshotListener { [self] documentSnapshot, error in
            
            if let documentSnapshot = documentSnapshot {
                
                let messages = documentSnapshot.documents.compactMap { querySnapshot in
                    
                        try? querySnapshot.data(as: Messages.self)
                }
                
                // 將聊天室的最新訊息相關資料，以及是哪個indexPathRow的聊天室傳給 ChatViewController
//                self.latestMessageClosure?(messages.last!, self.rowOfindexPath!)
                
                DispatchQueue.main.async { [self] in
                    
                    self.messageTypeArray = [String]()
                    self.messageDataArray = [String]()
                    self.messageCreateTimeArray = [Timestamp]()
                    
                    for message in messages {
                        //                    self.messageTypeArray.append(message.senderUUID)
                        //                    self.messageDataArray.append(message.messageContent)
                        self.messageTypeArray.insert(message.senderUUID, at: 0)
                        self.messageDataArray.insert(message.messageContent, at: 0)
                        self.messageCreateTimeArray.insert(message.createTime, at: 0)
                        
                    }
                    self.chatRoomTableView.reloadData()
                    // tableView upsidedown 之後就不用 scroll 到最下面
                    //                self.chatRoomTableView.scrollToRow(at: IndexPath(row: self.messageTypeArray.count - 1, section: 0), at: .bottom, animated: true)
                }
                
                
            } else {
                return
            }
            
            
        }
            
    }

    private func layoutView() {
        
        self.view.backgroundColor = .PrimaryLight
        
        self.view.addSubview(chatRoomTableView)
        self.view.addSubview(typingAreaView)
        typingAreaView.addSubview(typingTextField)
        typingAreaView.addSubview(sendButton)
        
        typingAreaView.translatesAutoresizingMaskIntoConstraints = false
        typingTextField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        chatRoomTableView.translatesAutoresizingMaskIntoConstraints = false

//        typingAreaView.frame = CGRect(x: 0, y: Int(fullScreenSize.height - bottomInset), width: <#T##Int#>, height: <#T##Int#>)
        NSLayoutConstraint.activate([
//            typingAreaView.topAnchor.constraint(equalTo: typingTextField.topAnchor, constant: -12),
            typingAreaView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            typingAreaView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
//            typingAreaView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            typingTextField.leadingAnchor.constraint(equalTo: typingAreaView.leadingAnchor, constant: 16),
            typingTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -16),
//            typingTextField.topAnchor.constraint(equalTo: typingAreaView.topAnchor, constant: 12),
            typingTextField.bottomAnchor.constraint(equalTo: typingAreaView.bottomAnchor, constant: -(8 + safeAreaBottomInset)),
            sendButton.trailingAnchor.constraint(equalTo: typingAreaView.trailingAnchor, constant: -16),
            //            sendButton.topAnchor.constraint(equalTo: typingAreaView.topAnchor, constant: 8),
            //            sendButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            sendButton.centerYAnchor.constraint(equalTo: typingTextField.centerYAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 28),
            sendButton.widthAnchor.constraint(equalTo: sendButton.heightAnchor, multiplier: 1)
        ])
        typingAreaViewTopConstraint = typingAreaView.topAnchor.constraint(equalTo: typingTextField.topAnchor, constant: -12)
        typingAreaViewBottomConstraint = typingAreaView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        typingAreaViewTopConstraint.isActive = true
        typingAreaViewBottomConstraint.isActive = true
        
        // MARK: tableView upsideDown
        chatRoomTableView.transform = CGAffineTransform(rotationAngle: .pi)
        
        chatRoomTableView.register(UserMeChatTableViewCell.self, forCellReuseIdentifier: "\(UserMeChatTableViewCell.self)")
        chatRoomTableView.register(UserTheOtherTableViewCell.self, forCellReuseIdentifier: "\(UserTheOtherTableViewCell.self)")

        NSLayoutConstraint.activate([
            chatRoomTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            chatRoomTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        ])
        chatRoomTableViewTopConstraint = chatRoomTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        chatRoomTableViewBottomConstraint = chatRoomTableView.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor, constant: -98)
        chatRoomTableViewTopConstraint.isActive = true
        chatRoomTableViewBottomConstraint.isActive = true
        
        
//        chatRoomTableView.snp.makeConstraints { make in
//            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
//            // TODO: 如何取得距離
//            make.bottom.lessThanOrEqualTo(self.view).offset(-98)
//        }

    }

}

extension ChatRoomBaseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageTypeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let messageType = messageTypeArray[indexPath.row]
    
        switch messageType {
        case currentUserUID:
            // TODO: 寫法??
            if let cell = tableView.dequeueReusableCell(withIdentifier: "\(UserMeChatTableViewCell.self)", for: indexPath) as? UserMeChatTableViewCell {
                cell.dialogTextView.text = messageDataArray[indexPath.row]
                cell.layoutCell()
                
                let timestamp: Timestamp = messageCreateTimeArray[indexPath.row] // 從 Firestore 中取得的 Timestamp 值
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH : mm" // 例如："yyyy-MM-dd HH:mm" -> 2023-06-10 15:30
                let date = timestamp.dateValue()
                let formattedTime = dateFormatter.string(from: date)
                cell.createdTimeLabel.text = formattedTime
                
                cell.contentView.transform = CGAffineTransform(rotationAngle: .pi)
                return cell
            } else { return UITableViewCell.init() }
            
        case otherUserUID:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "\(UserTheOtherTableViewCell.self)", for: indexPath) as? UserTheOtherTableViewCell {
                cell.dialogTextView.text = messageDataArray[indexPath.row]
                cell.profileImageView.kf.setImage(with: URL(string: otherUserImageURL))
                cell.layoutCell()
                
                let timestamp: Timestamp = messageCreateTimeArray[indexPath.row] // 從 Firestore 中取得的 Timestamp 值
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm" // 例如："yyyy-MM-dd HH:mm" -> 2023-06-10 15:30
                let date = timestamp.dateValue()
                let formattedTime = dateFormatter.string(from: date)
                cell.createdTimeLabel.text = formattedTime
                
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
