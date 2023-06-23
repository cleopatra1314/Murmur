//
//  ChatViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/23.
//

import UIKit

class ChatViewController: UIViewController {
    
    private let chatRoomTableView: UITableView = {
        let chatRoomTableView = UITableView()
        chatRoomTableView.separatorStyle = .none
        chatRoomTableView.allowsSelection = false
        return chatRoomTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        chatRoomTableView.delegate = self
        chatRoomTableView.dataSource = self
        
        setNav()
        setTableView()
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
        chatRoomTableView.register(SearchBarTableViewCell.self, forCellReuseIdentifier: "\(SearchBarTableViewCell.self)")
        
        self.view.addSubview(chatRoomTableView)
        
        chatRoomTableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalTo(self.view.safeAreaLayoutGuide)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }

    }
    
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        <#code#>
    }
}
