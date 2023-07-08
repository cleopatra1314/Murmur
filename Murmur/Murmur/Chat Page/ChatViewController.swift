//
//  ChatViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/23.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift


class ChatViewController: UIViewController {
    
    var chatRoomCreateTimeArray = [Timestamp]()
    var timer = Timer()
    
    var chatRooms = [ChatRooms]()
    var latestMessagesData = [Messages]()
    var chatRoomMessagesData = [ChatRoomMessages]()
    var orderedChatRoomMessagesData = [ChatRoomMessages]()
    var chatRoomsData = [ChatRooms]()

    var chatRoomsArray = [String]()
    var chatRoomOtherUserNameArray: [String]?
    var chatRoomOtherUserUIDArray: [String]?
    var chatRoomOtherUserPortraitArray: [String]?
    var chatRoomLatestMessageArray: [String]?
    let defaultOtherUserImageURLString = "https://firebasestorage.googleapis.com/v0/b/murmur-e5e16.appspot.com/o/23BE2607-13B4-4E70-9415-1308A077C396.jpg?alt=media&token=eca45cc1-8904-4319-a527-e6085569293c"
    
    var messageSenderDictionary = [String: String]()
    var chatRoomLatestMessageDictionary = [Timestamp: String]()
    
    var messagesDataResult: [Messages]?
    
    var chatRoomOtherUsersDataResult: [Users]?
    var chatRoomsDataResult: [ChatRooms]?
//    var selectedChatOtherUserUID: String?
    
    private let chatRoomTableView: UITableView = {
        let chatRoomTableView = UITableView()
        chatRoomTableView.separatorStyle = .none
        chatRoomTableView.allowsSelection = true
        chatRoomTableView.backgroundColor = .PrimaryLight
        return chatRoomTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .SecondaryLight
        
        chatRoomTableView.delegate = self
        chatRoomTableView.dataSource = self
        
        setNav()
        getRealTimeChatData()
        setTableView()
        setMessagesCountDownTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setMessagesCountDownTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(messagesCountDown), userInfo: nil, repeats: true)
        
    }
    
    @objc func messagesCountDown() {
        
        chatRoomTableView.reloadData()
        print("計算聊天室時間")

    }
    
    private func setNav() {
        self.navigationItem.title = "破冰室茶集"
    }
    
    private func setTableView() {
        
        chatRoomTableView.register(ChatRoomTableViewCell.self, forCellReuseIdentifier: "\(ChatRoomTableViewCell.self)")
        chatRoomTableView.register(SearchBarTableHeaderView.self, forHeaderFooterViewReuseIdentifier: "\(SearchBarTableHeaderView.self)")
        
        self.view.addSubview(chatRoomTableView)
        
        chatRoomTableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view)
            make.leading.equalTo(self.view.safeAreaLayoutGuide)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
        
    }
    
    private func getRealTimeChatData() {
        
//        database.collection("userTest").document(currentUserUID).collection("chatRooms").document("NwchiCNf5pSYanW3BbYR").getDocument { document, error in
//            guard let document,
//                  document.exists,
//                  let test = try? document.data(as: Users.self) else {
//                return
//            }
//            print("神奇的檔案", test)
//        }
        
//        self.chatRoomMessagesData = [ChatRoomMessages]()
        database.collection("userTest").document(currentUserUID).collection("chatRooms").addSnapshotListener { [self] documentSnapshot, error in
            
            let chatRooms = documentSnapshot?.documents.compactMap { querySnapshot in
                try? querySnapshot.data(as: ChatRooms.self)
            }

//            self.chatRoomsArray = [String]()
//            self.chatRoomOtherUserNameArray = [String]()
//            self.chatRoomOtherUserPortraitArray = [String]()
//            self.chatRoomLatestMessageArray = [String]()
//            self.chatRoomOtherUserUIDArray = [String]()
            
            self.chatRoomMessagesData = [ChatRoomMessages]()
            // 找每個聊天室的對方名稱及大頭照
            for chatRoom in chatRooms! {
                print("🌵", chatRoom)
//                self.chatRoomsDataResult = chatRooms
//
//                self.chatRoomsArray.append(chatRoom.id!)
//                self.chatRoomOtherUserUIDArray?.append(chatRoom.theOtherUserUID)
           
                // 取得每個聊天室的使用者名稱及頭貼
                database.collection("userTest").document(chatRoom.theOtherUserUID).getDocument { document, error in
                    
                    guard let document,
                          document.exists,
                          let otherUser = try? document.data(as: Users.self) else {
                        return
                    }
                    print("🍁", otherUser)
                    // 取得每個聊天室的第一則訊息 info
                    database.collection("userTest").document(currentUserUID).collection("chatRooms").document(chatRoom.id!).getDocument { [self] documentSnapshot, error in
                        
                        guard let documentSnapshot,
                              documentSnapshot.exists,
                              var chatRoomResult = try? documentSnapshot.data(as: ChatRooms.self)
                        else {
                            return
                        }
                        
                        let chatRoomMessagesResult = ChatRoomMessages(chatRoomCreateTime:chatRoomResult.createTime, latestMessageCreateTime: chatRoomResult.latestMessageCreateTime ?? Timestamp(date: Date()), theOtherUserUID: chatRoom.theOtherUserUID, theOtherUserName: otherUser.userName, theOtherUserPortraitUrlString: otherUser.userPortrait, senderUUID: chatRoomResult.latestMessageSenderUUID ?? currentUserUID, latestMessage: chatRoomResult.latestMessageContent ?? "資料是空，一切是空", roomID: chatRoom.id!, otherUserOnlineState: otherUser.onlineState)
                        
                        self.chatRoomMessagesData.append(chatRoomMessagesResult)
                        
                        orderedChatRoomMessagesData = chatRoomMessagesData.sorted(by: { $0.latestMessageCreateTime > $1.latestMessageCreateTime })
                        
                        DispatchQueue.main.async {
                            self.chatRoomTableView.reloadData()
                        }
                    }
                    
                    
                    
                    /*
                    // 取得每個聊天室的第一則訊息
                    database.collection("chatRooms").document(chatRoom.id!).collection("messages").order(by: "createTime", descending: true).getDocuments { querySnapshot, error in
                        
                        let messages = querySnapshot?.documents.compactMap { queryDocumentSnapshot in
                            try? queryDocumentSnapshot.data(as: Messages.self)
                        }
                        
                        self.chatRoomLatestMessageDictionary[(messages?.first!.createTime)!] = messages?.first?.messageContent
                        
                        self.messageSenderDictionary[chatRoom.theOtherUserUID] = (messages?.first)!.senderUUID
                        //                                self.chatRoomLatestMessageDictionary[chatRoom.theOtherUserUID] = (messages?.first)!.messageContent
                        
                        let chatRoomMessagesResult = ChatRoomMessages(createTime: messages![0].createTime, theOtherUserUID: chatRoom.theOtherUserUID, theOtherUserName: otherUser.userName, theOtherUserPortraitUrlString: otherUser.userPortrait, senderUUID: messages![0].senderUUID, latestMessage: messages![0].messageContent, roomID: chatRoom.id!, otherUserOnlineState: otherUser.onlineState)
                        
                        self.chatRoomMessagesData.append(chatRoomMessagesResult)
                        
                        orderedChatRoomMessagesData = chatRoomMessagesData.sorted(by: { $0.createTime > $1.createTime })
                        print("跑進來")
//                        chatRoomVC.latestMessageClosure = { [self] latestMessage, rowOfIndexPath in
//
//                            orderedChatRoomMessagesData[rowOfIndexPath].createTime = latestMessage.createTime
//                            orderedChatRoomMessagesData[rowOfIndexPath].senderUUID = latestMessage.senderUUID
//                            orderedChatRoomMessagesData[rowOfIndexPath].latestMessage = latestMessage.messageContent
//                            for index in orderedChatRoomMessagesData {
//                                print("🌺closure 改好的", index.theOtherUserName, index.latestMessage)
//                            }
//                            //                                        print("🌼🌼🌼🌼closure 排序好的資料", orderedChatRoomMessagesData)
//                            orderedChatRoomMessagesData = orderedChatRoomMessagesData.sorted(by: { $0.createTime > $1.createTime })
//                            for index in orderedChatRoomMessagesData {
//                                print("🌼closure 排序好的資料", index.theOtherUserName, index.latestMessage)
//                            }
//                            //                                        print("🌼closure 排序好的資料", orderedChatRoomMessagesData)
//
//                            self.chatRoomTableView.reloadData()
//                        }
                        
                        DispatchQueue.main.async {
                            print("🌼🌼排序好的資料", orderedChatRoomMessagesData)
                            self.chatRoomTableView.reloadData()
                        }
                        
                    }
                    */
                    
                }
                
            }
            
        }
        
    }
    
}


extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderedChatRoomMessagesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ChatRoomTableViewCell.self)", for: indexPath) as? ChatRoomTableViewCell else { return UITableViewCell.init() }
        
        let messageSender = orderedChatRoomMessagesData[indexPath.row].senderUUID
        
        //        let messageSender = messageSenderDictionary[(chatRoomOtherUserUIDArray![indexPath.row])]
        
        if messageSender == currentUserUID {
            cell.messageSendStateImageView.image = UIImage(named: "Icons_SendOut.png")
        } else {
            cell.messageSendStateImageView.image = UIImage(named: "Icons_Receive.png")
        }
        
        let chatRoomOtherUserPortraitUrlString = orderedChatRoomMessagesData[indexPath.row].theOtherUserPortraitUrlString
//        let chatRoomOtherUserPortraitUrlString = chatRoomOtherUserPortraitArray?[indexPath.row]
        if chatRoomOtherUserPortraitUrlString != "" {
            cell.otherUserImageView.kf.setImage(with: URL(string: chatRoomOtherUserPortraitUrlString))
        } else {
            cell.otherUserImageView.kf.setImage(with: URL(string: defaultOtherUserImageURLString))
        }
        cell.otherUserNameLabel.text = orderedChatRoomMessagesData[indexPath.row].theOtherUserName
        cell.otherUserFirstMessageLabel.text = orderedChatRoomMessagesData[indexPath.row].latestMessage

        
//        cell.otherUserNameLabel.text = chatRoomOtherUserNameArray?[indexPath.row]
//        cell.otherUserFirstMessageLabel.text = chatRoomLatestMessageArray?[indexPath.row]
//        cell.otherUserFirstMessageLabel.text = chatRoomLatestMessageDictionary[(chatRoomOtherUserUIDArray![indexPath.row])]
        
        // 計算聊天室創立了多久時間
        let timestampNow = Timestamp(date: Date())
        let timestampFromChatRoomCreated = orderedChatRoomMessagesData[indexPath.row].chatRoomCreateTime

        let dateNow = timestampNow.dateValue()
        let dateFromChatRoomCreated = timestampFromChatRoomCreated.dateValue()

        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: dateFromChatRoomCreated, to: dateNow)

        let passedHours = components.hour ?? 0
        let passedMinutes = components.minute ?? 0
        let passedSeconds = components.second ?? 0
        
        // 如果 passedHours < 0，則 delete 這個 row
        cell.progressCircleView.passedTimeHr = passedHours
//        cell.progressCircleView.setProgress(frameWidth: 32)
        
        cell.layoutCell()
        
        // 使 cell 在选中单元格时没有灰色背景
        cell.selectionStyle = .default
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "\(SearchBarTableHeaderView.self)") as? SearchBarTableHeaderView else {
                return nil
        }
        headerView.layoutView()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chatRoomVC = ChatRoomBaseViewController()
        
//        chatRoomVC.latestMessageClosure = { [self] latestMessage, rowOfIndexPath in
//            
//            orderedChatRoomMessagesData[rowOfIndexPath].createTime = latestMessage.createTime
//            orderedChatRoomMessagesData[rowOfIndexPath].senderUUID = latestMessage.senderUUID
//            orderedChatRoomMessagesData[rowOfIndexPath].latestMessage = latestMessage.messageContent
//            for index in orderedChatRoomMessagesData {
//                print("🌺closure 改好的", index.theOtherUserName, index.latestMessage)
//            }
//            //                                        print("🌼🌼🌼🌼closure 排序好的資料", orderedChatRoomMessagesData)
//            orderedChatRoomMessagesData = orderedChatRoomMessagesData.sorted(by: { $0.createTime > $1.createTime })
//            for index in orderedChatRoomMessagesData {
//                print("🌼closure 排序好的資料", index.theOtherUserName, index.latestMessage)
//            }
//            //                                        print("🌼closure 排序好的資料", orderedChatRoomMessagesData)
//            
//            self.chatRoomTableView.reloadData()
//        }
        
        
        chatRoomVC.rowOfindexPath = indexPath.row
        chatRoomVC.chatRoomID = orderedChatRoomMessagesData[indexPath.row].roomID
        chatRoomVC.otherUserUID = orderedChatRoomMessagesData[indexPath.row].theOtherUserUID
        chatRoomVC.otherUserName = orderedChatRoomMessagesData[indexPath.row].theOtherUserName
        if orderedChatRoomMessagesData[indexPath.row].theOtherUserPortraitUrlString != "" {
            chatRoomVC.otherUserImageURL = orderedChatRoomMessagesData[indexPath.row].theOtherUserPortraitUrlString
        } else {
            chatRoomVC.otherUserImageURL = self.defaultOtherUserImageURLString
        }
        
        // 找到父视图控制器
        if let tabBarController = self.tabBarController {
            // 设置tabbar的隐藏状态为false
            tabBarController.tabBar.isHidden = false
        }
        self.navigationController?.pushViewController(chatRoomVC, animated: true)
    }
    
}
