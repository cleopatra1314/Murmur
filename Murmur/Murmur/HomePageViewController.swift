//
//  ViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/14.
//

import UIKit
import SnapKit

class HomePageViewController: UIViewController {
    
    let mapView: UIView = {
        let mapView = UIView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.backgroundColor = .white
        
        return mapView
    }()
    
    let btnStack: UIStackView = {
        let btnStack = UIStackView()
        btnStack.axis = .vertical
        return btnStack
    }()
    let filterButton: UIButton = {
        let filterButton = UIButton()
        filterButton.backgroundColor = .black
        filterButton.setImage(UIImage(named: "Icons_Filter"), for: .normal)
        return filterButton
    }()
    let locationMessageButton: UIButton = {
        let locationMessageButton = UIButton()
        locationMessageButton.backgroundColor = .blue
        locationMessageButton.setImage(UIImage(named: "Icons_People"), for: .normal)
        return locationMessageButton
    }()
    let locateButton: UIButton = {
        let locateButton = UIButton()
        locateButton.backgroundColor = .red
        locateButton.setImage(UIImage(named: "Icons_Locate"), for: .normal)
        return locateButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .red
        setMapView()
    }
    
    func setMapView() {
        self.view.addSubview(mapView)
        self.view.addSubview(btnStack)
        [filterButton, locationMessageButton, locateButton].forEach { subview in
            btnStack.addArrangedSubview(subview)
        }
        
        //        NSLayoutConstraint.activate([
        //            mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
        //            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
        //            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        //            mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80)
        //        ])
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(self.view)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-80)
        }
        btnStack.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(100)
            make.trailing.equalTo(self.view).offset(-24)
        }
        filterButton.snp.makeConstraints { make in
            make.width.equalTo(48)
            make.height.equalTo(filterButton.snp.width)
        }
        locationMessageButton.snp.makeConstraints { make in
            make.width.equalTo(48)
            make.height.equalTo(locationMessageButton.snp.width)
        }
        locateButton.snp.makeConstraints { make in
            make.width.equalTo(48)
            make.height.equalTo(locateButton.snp.width)
        }
        
    }
}
