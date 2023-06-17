//
//  NearbyUsersViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/17.
//

import UIKit

class NearbyUsersViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        self.view.addSubview(testView)
        testView.backgroundColor = .systemPink
        
    }

}
