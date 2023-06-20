//
//  ViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/14.
//

import UIKit
import MapKit
import CoreLocation

var currentCoordinate: CLLocationCoordinate2D! {
    didSet {
        print("目前位置", currentCoordinate)
    }
}

class HomePageViewController: UIViewController {
    
    private let locationManager = CLLocationManager()
    
    let nearbyUsersContainerView: UIView = {
        let nearbyUsersContainerView = UIView()
        nearbyUsersContainerView.translatesAutoresizingMaskIntoConstraints = false
        nearbyUsersContainerView.backgroundColor = .blue
        nearbyUsersContainerView.isHidden = false
        return nearbyUsersContainerView
    }()
    let locationMessageContainerView: UIView = {
        let locationMessageContainerView = UIView()
        locationMessageContainerView.translatesAutoresizingMaskIntoConstraints = false
        locationMessageContainerView.backgroundColor = .black
        locationMessageContainerView.isHidden = true
        return locationMessageContainerView
    }()
    var switchMode = false
    private let childNearbyUsersViewController = NearbyUsersViewController()
    private let childLocationMessageViewController = LocationMessageViewController()
    
    private let btnStack: UIStackView = {
        let btnStack = UIStackView()
        btnStack.axis = .vertical
        return btnStack
    }()
    private let filterButton: UIButton = {
        let filterButton = UIButton()
        filterButton.backgroundColor = .black
        filterButton.setImage(UIImage(named: "Icons_Filter"), for: .normal)
        return filterButton
    }()
    let switchModeButton: UIButton = {
        let switchModeButton = UIButton()
        switchModeButton.backgroundColor = .blue
        switchModeButton.setImage(UIImage(named: "Icons_Message"), for: .normal)
        switchModeButton.addTarget(self, action: #selector(switchModeButtonTouchUpInside), for: .touchUpInside)
        return switchModeButton
    }()
    private let backToMyLocationButton: UIButton = {
        let backToMyLocationButton = UIButton()
        backToMyLocationButton.backgroundColor = .red
        backToMyLocationButton.setImage(UIImage(named: "Icons_Locate"), for: .normal)
        backToMyLocationButton.addTarget(self, action: #selector(locateButtonTouchUpInside), for: .touchUpInside)
        return backToMyLocationButton
    }()
    let alertController: UIAlertController = {
        let alertController = UIAlertController(title: "建議", message: "請開啟你的定位服務以繼續使用 app", preferredStyle: .alert)
        // swiftlint:disable line_length
        //    let alertController = UIAlertController(title: "建議", message: "Location services were previously denied. Please enable location services for this app in Settings.", preferredStyle: .alert)
        // swiftlint:enable line_length
        alertController.addAction(UIAlertAction(title: "確定", style: .default))
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        // TODO: 加上 handler closure 引導使用者開定位功能
        return alertController
    }()
    private var backToMyLocationClosure: ((Void) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        currentCoordinate = locationManager.location?.coordinate
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        // 一開始進到 homePage，LocationMessagePage timer 就會開始跑，所以要先停掉
        childLocationMessageViewController.stopTimer()
        
        setMapView()
        setContainerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TODO: 為什麼這邊不會先跑
        currentCoordinate = locationManager.location?.coordinate
    }
    
    // 切換模式
    @objc func switchModeButtonTouchUpInside() {
        
        if switchMode == false {
            switchMode.toggle()
            switchModeButton.setImage(UIImage(named: "Icons_People"), for: .normal)
            childLocationMessageViewController.startTimer()
        } else {
            switchMode.toggle()
            switchModeButton.setImage(UIImage(named: "Icons_Message"), for: .normal)
            childLocationMessageViewController.stopTimer()
        }
        
        nearbyUsersContainerView.isHidden.toggle()
        locationMessageContainerView.isHidden.toggle()
    }
    
    // 回到自己的定位位置
    @objc func locateButtonTouchUpInside() {
//        self.backToMyLocationClosure!(<#Void#>)
        childLocationMessageViewController.locationManager.startUpdatingLocation()
        childNearbyUsersViewController.locationManager.startUpdatingLocation()
    }
    
    private func setContainerView() {
        
        addChild(childNearbyUsersViewController)
        addChild(childLocationMessageViewController)
        nearbyUsersContainerView.addSubview(childNearbyUsersViewController.view)
        locationMessageContainerView.addSubview(childLocationMessageViewController.view)
        
        childNearbyUsersViewController.view.snp.makeConstraints { make in
            // 四邊一模一樣貼齊
            make.edges.equalTo(nearbyUsersContainerView)
        }
        childLocationMessageViewController.view.snp.makeConstraints { make in
            // 四邊一模一樣貼齊
            make.edges.equalTo(locationMessageContainerView)
        }
        
    }
    
    private func setMapView() {
        [nearbyUsersContainerView, locationMessageContainerView, btnStack].forEach { subview in
            self.view.addSubview(subview)
        }
        [filterButton, switchModeButton, backToMyLocationButton].forEach { subview in
            btnStack.addArrangedSubview(subview)
        }
        
        //        NSLayoutConstraint.activate([
        //            mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
        //            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
        //            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        //            mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80)
        //        ])
        
        nearbyUsersContainerView.snp.makeConstraints { make in
            make.top.equalTo(self.view)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-80)
        }
        locationMessageContainerView.snp.makeConstraints { make in
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
        switchModeButton.snp.makeConstraints { make in
            make.width.equalTo(48)
            make.height.equalTo(switchModeButton.snp.width)
        }
        backToMyLocationButton.snp.makeConstraints { make in
            make.width.equalTo(48)
            make.height.equalTo(backToMyLocationButton.snp.width)
        }
    }
    
}

extension HomePageViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        updateRegionsWithLocation(locations[0])
        
        guard let location = locations.last else { return }
        currentCoordinate = location.coordinate
        // 在这里处理获取到的坐标（currentCoordinate）
    }
}
