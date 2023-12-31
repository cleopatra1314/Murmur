//
//  ChatBaseViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/26.
//
/*
import UIKit
import SnapKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class ChatRoomBaseViewController: UIViewController {
    
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
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 300, right: 0)
        scrollView.backgroundColor = .clear
        return scrollView
    }()
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
    
    // 當點擊view任何喔一處鍵盤收起
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // 鍵盤收合
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // keyboard 出現時，輸入區跟著移動
    @objc func keyboardWasShown(_ notification: NSNotification) {
         guard let info = notification.userInfo,
               let keyboardFrameValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
         let keyboardFrame = keyboardFrameValue.cgRectValue
         let keyboardSize = keyboardFrame.size
         let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
         scrollView.contentInset = contentInsets
         scrollView.scrollIndicatorInsets = contentInsets
         if typingTextField.isFirstResponder {
             scrollView.scrollRectToVisible(typingTextField.frame, animated: true)
         }
        
        
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
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
        
        self.view.addSubview(chatRoomTableView)
        self.view.addSubview(scrollView)
        scrollView.addSubview(typingAreaView)
        typingAreaView.addSubview(typingTextField)
        typingAreaView.addSubview(sendButton)
        
        typingAreaView.translatesAutoresizingMaskIntoConstraints = false
        typingTextField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            typingAreaView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -94),
//            typingAreaView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
//            typingAreaView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
//            typingAreaView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            typingTextField.leadingAnchor.constraint(equalTo: typingAreaView.leadingAnchor, constant: 16),
            typingTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -16),
            typingTextField.topAnchor.constraint(equalTo: typingAreaView.topAnchor, constant: 12),
            typingTextField.bottomAnchor.constraint(equalTo: typingAreaView.bottomAnchor, constant: -8),
            sendButton.trailingAnchor.constraint(equalTo: typingAreaView.trailingAnchor, constant: -16),
            //            sendButton.topAnchor.constraint(equalTo: typingAreaView.topAnchor, constant: 8),
            //            sendButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            sendButton.centerYAnchor.constraint(equalTo: typingTextField.centerYAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 28),
            sendButton.widthAnchor.constraint(equalTo: sendButton.heightAnchor, multiplier: 1)
        ])
        
        // MARK: tableView upsideDown
        chatRoomTableView.transform = CGAffineTransform(rotationAngle: .pi)
        
        chatRoomTableView.register(UserMeChatTableViewCell.self, forCellReuseIdentifier: "\(UserMeChatTableViewCell.self)")
        chatRoomTableView.register(UserTheOtherTableViewCell.self, forCellReuseIdentifier: "\(UserTheOtherTableViewCell.self)")
        
        
//        scrollView.snp.makeConstraints { make in
//            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
//            make.bottom.equalTo(self.view)
//        }
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: chatRoomTableView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
//            scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
//            scrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
//            scrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
//            scrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
//            scrollView.contentLayoutGuide.topAnchor.constraint(equalTo: chatRoomTableView.topAnchor),
//            scrollView.contentLayoutGuide.leadingAnchor.constraint(equalTo: chatRoomTableView.leadingAnchor),
//            scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: chatRoomTableView.trailingAnchor),
//            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: typingAreaView.bottomAnchor),
            
            typingAreaView.heightAnchor.constraint(equalToConstant: 94),
            typingAreaView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            typingAreaView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 600),
            typingAreaView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            typingAreaView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            typingAreaView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
        chatRoomTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.lessThanOrEqualTo(self.view.safeAreaLayoutGuide).offset(-94)
        }
        
//        chatRoomTableView.snp.makeConstraints { make in
//            make.top.equalTo(self.view.safeAreaLayoutGuide)
//            make.bottom.lessThanOrEqualTo(typingAreaView.snp.top)
////            make.bottom.equalTo(typingAreaView.snp.top)
//            make.leading.equalTo(self.view.safeAreaLayoutGuide)
//            make.trailing.equalTo(self.view.safeAreaLayoutGuide)
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
*/
