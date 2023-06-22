//
//  ChatRoomViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/15.
//

import UIKit

class ChatRoomViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .orange
        setNav()
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
           .font: UIFont.systemFont(ofSize: 18, weight: .regular)
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
        label.font = UIFont.boldSystemFont(ofSize: 16)
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
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
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

}
