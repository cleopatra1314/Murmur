//
//  FootPrintViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/27.
//

import Foundation
import UIKit
import MapKit
import SnapKit

class FootPrintViewController: UIViewController {
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.layer.cornerRadius = 14
        mapView.clipsToBounds = true
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutView()
    }
    
    func layoutView() {
        
        self.view.backgroundColor = UIColor(red: 28/255, green: 38/255, blue: 45/255, alpha: 1)
        
        self.view.addSubview(mapView)
//        mapView.frame = self.view.bounds
        self.mapView.snp.makeConstraints { make in
            make.top.leading.equalTo(self.view).offset(16)
            make.bottom.trailing.equalTo(self.view).offset(-16)
        }
        
    }
    
}
