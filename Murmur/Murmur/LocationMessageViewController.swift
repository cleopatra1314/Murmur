//
//  LocationMessageViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/16.
//

import UIKit

class LocationMessageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        self.view.addSubview(testView)
        testView.backgroundColor = .white
    }

}
