//
//  ViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/14.
//

import UIKit

class HomePageViewController: UIViewController {
    
    let mapView: UIView = {
        let mapView = UIView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.backgroundColor = .white
        
        return mapView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .red
        setMapView()
    }
    
    func setMapView() {
        self.view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80)
        ])
    }

}
