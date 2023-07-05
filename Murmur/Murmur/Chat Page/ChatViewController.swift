//
//  ChatViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/23.
//

import UIKit
import FirebaseFirestore

class ChatViewController: UIViewController {
    
    var chatRoomsArray = [String]()
    var chatRoomOtherUserNameArray: [String]?
    var chatRoomOtherUserUIDArray: [String]?
    var chatRoomOtherUserPortraitArray: [String]?
    var chatRoomLatestMessageArray: [String]?
    let defaultOtherUserImageURLString = "https://firebasestorage.googleapis.com/v0/b/murmur-e5e16.appspot.com/o/23BE2607-13B4-4E70-9415-1308A077C396.jpg?alt=media&token=eca45cc1-8904-4319-a527-e6085569293c"
    
    var messageSenderDictionary = [String: String]()
    var chatRoomLatestMessageDictionary = [String: String]()
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
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
        
        database.collection("userTest").document(currentUserUID).collection("chatRooms").order(by: "createTime", descending: true).addSnapshotListener { [self] documentSnapshot, error in
            
            let chatRooms = documentSnapshot?.documents.compactMap { querySnapshot in
                try? querySnapshot.data(as: ChatRooms.self)
            }

            self.chatRoomsArray = [String]()
            self.chatRoomOtherUserNameArray = [String]()
            self.chatRoomOtherUserPortraitArray = [String]()
            self.chatRoomLatestMessageArray = [String]()
            self.chatRoomOtherUserUIDArray = [String]()
            
            // 找每個聊天室的對方名稱及大頭照
            for chatRoom in chatRooms! {
                self.chatRoomsDataResult = chatRooms

                self.chatRoomsArray.append(chatRoom.id!)
                self.chatRoomOtherUserUIDArray?.append(chatRoom.theOtherUserUID)

                let serialQueue = DispatchQueue(label: "SerialQueue")
                
                    // 取得每個聊天室的使用者名稱及頭貼
                    database.collection("userTest").document(chatRoom.theOtherUserUID).getDocument { documentSnapshot, error in
                        if let document = documentSnapshot, document.exists {
                            
                            let data = document.data()
                            
                                                    if let userName = data?["userName"] as? String {
                            
                                                        self.chatRoomOtherUserNameArray?.append(userName)
                                                    }
                            
//                            username = data?["userName"] as? String
//                            self.chatRoomOtherUserNameArray?.append(username!)
                            
                            if let userPortrait = data?["userPortrait"] as? String {
                                
                                self.chatRoomOtherUserPortraitArray?.append(userPortrait)
                            }
                            
                            //                        DispatchQueue.main.async {
                            //                            self.chatRoomTableView.reloadData()
                            //                        }
                            
                            // 取得每個聊天室的第一則訊息
                            database.collection("chatRooms").document(chatRoom.id!).collection("messages").order(by: "createTime", descending: true).addSnapshotListener { querySnapshot, error in
                                
                                let messages = querySnapshot?.documents.compactMap { queryDocumentSnapshot in
                                    try? queryDocumentSnapshot.data(as: Messages.self)
                                }
                                
            //                                self.messagesDataResult = messages
            //                                print("第一則訊息為", (messages?.first)!.messageContent)
                                
                                self.messageSenderDictionary[chatRoom.theOtherUserUID] = (messages?.first)!.senderUUID
                                self.chatRoomLatestMessageDictionary[chatRoom.theOtherUserUID] = (messages?.first)!.messageContent
                             
                                // TODO: ?? 當 chatRoomLatestMessageArray 為 [String]? 時，append 無效，要先 = [String]() 才行（移到上面 for in loop 外）
            //                                self.chatRoomLatestMessageArray?.append((messages?.first)!.messageContent)
            //                                print("第一則訊息陣列為", self.chatRoomLatestMessageArray)
                                
                                DispatchQueue.main.async {
                                    self.chatRoomTableView.reloadData()
                                }
                                
                            }
                            
                            
                        } else {
                            print("文档不存在")
                        }
                        
                    }
                
                
                
                
                    
                }
                
            }
            
        
        
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chatRoomsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ChatRoomTableViewCell.self)", for: indexPath) as? ChatRoomTableViewCell else { return UITableViewCell.init() }
        
        let messageSender = messageSenderDictionary[(chatRoomOtherUserUIDArray![indexPath.row])]
        
        if messageSender == currentUserUID {
            cell.messageSendStateImageView.image = UIImage(named: "Icons_SendOut.png")
    
        } else {
            cell.messageSendStateImageView.kf.setImage(with: URL(string: chatRoomOtherUserPortraitArray![indexPath.row]))
        }
        
        let chatRoomOtherUserPortraitUrlString = chatRoomOtherUserPortraitArray?[indexPath.row]
        if chatRoomOtherUserPortraitUrlString != "" {
            cell.otherUserImageView.kf.setImage(with: URL(string: chatRoomOtherUserPortraitUrlString!))
        } else {
            cell.otherUserImageView.kf.setImage(with: URL(string: defaultOtherUserImageURLString))
        }
        
        cell.otherUserNameLabel.text = chatRoomOtherUserNameArray?[indexPath.row]
//        cell.otherUserFirstMessageLabel.text = chatRoomLatestMessageArray?[indexPath.row]
        cell.otherUserFirstMessageLabel.text = chatRoomLatestMessageDictionary[(chatRoomOtherUserUIDArray![indexPath.row])]
        cell.layoutCell()
        
        // 使 cell 在选中单元格时没有灰色背景
        cell.selectionStyle = .none
        
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
        
        chatRoomVC.chatRoomID = chatRoomsArray[indexPath.row]
        chatRoomVC.otherUserUID = chatRoomOtherUserUIDArray![indexPath.row]
        chatRoomVC.otherUserName = chatRoomOtherUserNameArray![indexPath.row]
        if chatRoomOtherUserPortraitArray![indexPath.row] != "" {
            chatRoomVC.otherUserImageURL = chatRoomOtherUserPortraitArray![indexPath.row]
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
