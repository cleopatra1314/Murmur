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
    var messagesDataResult: [Messages]?
    
    var chatRoomOtherUsersDataResult: [Users]?
    var chatRoomsDataResult: [ChatRooms]?
//    var selectedChatOtherUserUID: String?
    
    private let chatRoomTableView: UITableView = {
        let chatRoomTableView = UITableView()
        chatRoomTableView.separatorStyle = .none
        chatRoomTableView.allowsSelection = true
        return chatRoomTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
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
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithDefaultBackground()
        //        navBarAppearance.backgroundColor = .red
        navBarAppearance.backgroundEffect = UIBlurEffect(style: .regular)
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 18, weight: .medium)
        ]
        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        self.navigationItem.title = "破冰室"
        
        //        let closeButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonItemTouchUpInside))
        //        closeButtonItem.tintColor = .black
        //        navigationItem.leftBarButtonItem = closeButtonItem
        
        //        let nextButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonItemTouchUpInside))
        //        nextButtonItem.setTitleTextAttributes([NSAttributedString.Key.kern: 0, .font: UIFont.systemFont(ofSize: 18, weight: .medium)], for: .normal)
        //        nextButtonItem.tintColor = .purple
        //        navigationItem.rightBarButtonItem = nextButtonItem
    }
    
    private func setTableView() {
        
        chatRoomTableView.register(ChatRoomTableViewCell.self, forCellReuseIdentifier: "\(ChatRoomTableViewCell.self)")
        chatRoomTableView.register(SearchBarTableHeaderView.self, forHeaderFooterViewReuseIdentifier: "\(SearchBarTableHeaderView.self)")
        
        self.view.addSubview(chatRoomTableView)
        
        chatRoomTableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalTo(self.view.safeAreaLayoutGuide)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
        
    }
    
    private func getRealTimeChatData() {
        
        database.collection("userTest").document(currentUserUID).collection("chatRooms").order(by: "createTime", descending: false).addSnapshotListener { [self] documentSnapshot, error in
            
            let chatRooms = documentSnapshot?.documents.compactMap { querySnapshot in
                try? querySnapshot.data(as: ChatRooms.self)
            }
            print("解析資料為", chatRooms)
            
//            self.chatRoomsDataResult = chatRooms
//            // 注意要先把原本宣告 [String]()? 改為 [String]()，才能 append(element)
//            chatRoomsArray = [String]()
//            chatRoomOtherUserNameArray = [String]()
//            print("聊天室有哪些：", chatRoomsArray, chatRoomsArray.count)
//            for chatRoom in chatRooms! {
//                self.chatRoomsArray.append(chatRoom.id!)
//                self.chatRoomOtherUserNameArray?.append(chatRoom.theOtherUserUID)
//            }
//            print("更新後的聊天室有哪些：", chatRoomsArray, chatRoomsArray.count)
            self.chatRoomsArray = [String]()
            self.chatRoomOtherUserNameArray = [String]()
            self.chatRoomOtherUserPortraitArray = [String]()
            self.chatRoomLatestMessageArray = [String]()
            self.chatRoomOtherUserUIDArray = [String]()
            
            // 找每個聊天室的對方名稱及大頭照
            for chatRoom in chatRooms! {
                print("聊天室數量為", chatRooms!.count)
                self.chatRoomsDataResult = chatRooms

                self.chatRoomsArray.append(chatRoom.id!)
                self.chatRoomOtherUserUIDArray?.append(chatRoom.theOtherUserUID)

                database.collection("userTest").document(chatRoom.theOtherUserUID).getDocument { documentSnapshot, error in
                    if let document = documentSnapshot, document.exists {

                        let data = document.data()

                        if let userName = data?["userName"] as? String {

                            self.chatRoomOtherUserNameArray?.append(userName)
                        }
                        if let userPortrait = data?["userPortrait"] as? String {

                            self.chatRoomOtherUserPortraitArray?.append(userPortrait)
                        }

//                        DispatchQueue.main.async {
//                            self.chatRoomTableView.reloadData()
//                        }

                    } else {
                        print("文档不存在")
                    }
                }
            }
            
            self.chatRoomLatestMessageArray = [String]()
            // 取得每個聊天室的最新一則訊息
            for chatRoom in chatRoomsArray {
                print("聊天室ID為", chatRoom)
                database.collection("chatRooms").document(chatRoom).collection("messages").order(by: "createTime", descending: true).getDocuments { querySnapshot, error in
                    
                    let messages = querySnapshot?.documents.compactMap { queryDocumentSnapshot in
                        try? queryDocumentSnapshot.data(as: Messages.self)
                    }
                    
                    self.messagesDataResult = messages
                    print("第一則訊息為", (messages?.first)!.messageContent)
                 
                    // TODO: ?? 當 chatRoomLatestMessageArray 為 [String]? 時，append 無效，要先 = [String]() 才行（移到上面 for in loop 外）
                    self.chatRoomLatestMessageArray?.append((messages?.first)!.messageContent)
                    print("第一則訊息陣列為", self.chatRoomLatestMessageArray)

                    DispatchQueue.main.async {
                        self.chatRoomTableView.reloadData()
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
        cell.otherUserImageView.image = UIImage(named: "User2Portrait.png")
        cell.otherUserNameLabel.text = chatRoomOtherUserNameArray?[indexPath.row]
        cell.otherUserFirstMessageLabel.text = chatRoomLatestMessageArray?[indexPath.row]
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
        
        let chatRoomVC = ChatBaseViewController()
        
        chatRoomVC.chatRoomID = chatRoomsArray[indexPath.row]
//        chatRoomsDataResult![indexPath.row]
        chatRoomVC.otherUserUID = chatRoomOtherUserUIDArray![indexPath.row]
        chatRoomVC.otherUserName = chatRoomOtherUserNameArray![indexPath.row]
        chatRoomVC.otherUserImageURL = chatRoomOtherUserPortraitArray![indexPath.row]
        
        // 找到父视图控制器
        if let tabBarController = self.tabBarController {
            // 设置tabbar的隐藏状态为false
            tabBarController.tabBar.isHidden = false
        }
        self.navigationController?.pushViewController(chatRoomVC, animated: true)
    }
    
}
