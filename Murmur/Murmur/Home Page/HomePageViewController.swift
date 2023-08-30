//
//  ViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/14.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

let defaultCurrentCoordinate = CLLocationCoordinate2D(latitude: 25.0385, longitude: 121.531)
let defaultImageUrlString = "https://firebasestorage.googleapis.com/v0/b/murmur-e5e16.appspot.com/o/0C97C374-BAC5-4A65-BFCE-D7479C0FA60C.jpg?alt=media&token=48ab6e8e-c032-4566-8a85-ce70cae32b71"
var currentCoordinate: CLLocationCoordinate2D? {
    didSet {
//        print("變動！目前位置", currentCoordinate)
    }
}
var currentUserUID = "djDaiZAAUtYCPMDr0JdqTtihUN02" // 可以用 Auth.auth().currentUser?.uid 取代
let database = Firestore.firestore()
let fullScreenSize = UIScreen.main.bounds


//// 設定每 120 秒 update 一次（自己） currentLocation
//func modifyCurrentLocation() {
//
//    let documentReference = database.collection("userTest").document(currentUserUID)
//
//    documentReference.getDocument { document, error in
//        guard let document,
//              document.exists,
//              var user = try? document.data(as: Users.self)
//        else {
//            return
//        }
//
//        user.location = ["latitude": Double(currentCoordinate!.latitude), "longitude": Double(currentCoordinate!.longitude)]
//
//        do {
//            try documentReference.setData(from: user)
//            print("更新目前位置為：", user.location)
//        } catch {
//            print(error)
//        }
//
//    }
//}


class HomePageViewController: UIViewController {
    
    var databaseRef: DatabaseReference!
    
    var timer = Timer()

    var userData: Users?

    let locationManager = CLLocationManager()
    
    private let userEmailTextField: UITextField = {
       let userEmailTextField = UITextField()
        userEmailTextField.text  = "libby@gmail.com"
        return userEmailTextField
    }()
    private let userPasswardTextField: UITextField = {
        let userPasswardTextField = UITextField()
        userPasswardTextField.text  = "333333"
        return userPasswardTextField
    }()
    
    let nearbyUsersContainerView: UIView = {
        let nearbyUsersContainerView = UIView()
        nearbyUsersContainerView.translatesAutoresizingMaskIntoConstraints = false
        nearbyUsersContainerView.isHidden = false
        return nearbyUsersContainerView
    }()
    let locationMessageContainerView: UIView = {
        let locationMessageContainerView = UIView()
        locationMessageContainerView.translatesAutoresizingMaskIntoConstraints = false
        locationMessageContainerView.isHidden = true
        return locationMessageContainerView
    }()
    var switchMode = false
    private let childNearbyUsersViewController = NearbyUsersViewController()
    private let childLocationMessageViewController = LocationMessageViewController()
    
    private let btnStack: UIStackView = {
        let btnStack = UIStackView()
        btnStack.axis = .vertical
        btnStack.layer.cornerRadius = 12
        btnStack.clipsToBounds = true
        return btnStack
    }()
    lazy var filterButton: UIButton = {
        let filterButton = UIButton()
        filterButton.backgroundColor = .PrimaryDefault
        filterButton.tintColor = .SecondaryLight
        filterButton.setImage(UIImage(named: "Icons_Filter"), for: .normal)
        filterButton.addTarget(self, action: #selector(filterButtonTouchUpInside), for: .touchUpInside)
        return filterButton
    }()
    lazy var switchModeButton: UIButton = {
        let switchModeButton = UIButton()
        switchModeButton.backgroundColor = .PrimaryDefault
        switchModeButton.tintColor = .SecondaryLight
        switchModeButton.setImage(UIImage(named: "Icons_Message"), for: .normal)
        switchModeButton.addTarget(self, action: #selector(switchModeButtonTouchUpInside), for: .touchUpInside)
        return switchModeButton
    }()
    private lazy var backToMyLocationButton: UIButton = {
        let backToMyLocationButton = UIButton()
        backToMyLocationButton.backgroundColor = .PrimaryDefault
        backToMyLocationButton.tintColor = .systemRed
        backToMyLocationButton.setImage(UIImage(named: "Icons_Locate"), for: .normal)
        backToMyLocationButton.addTarget(self, action: #selector(locateButtonTouchUpInside), for: .touchUpInside)
        return backToMyLocationButton
    }()
    private let separaterbar1: UIView = {
        let separaterbar = UIView()
        separaterbar.frame = CGRect(x: 0, y: 0, width: 48, height: 2)
        separaterbar.backgroundColor = .SecondaryShine
        return separaterbar
    }()
    private let separaterbar2: UIView = {
        let separaterbar = UIView()
        separaterbar.frame = CGRect(x: 0, y: 0, width: 48, height: 2)
        separaterbar.backgroundColor = .SecondaryShine
        return separaterbar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.view.backgroundColor = .PrimaryDark
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        // 先讓兩個 vc 跑好資料
        childLocationMessageViewController.fetchMurmur()
        childNearbyUsersViewController.fetchUserLocation()
        
        // 點擊 locationMessage 貼文，跳出 popup 時要讓右上選單隱藏
        childLocationMessageViewController.popupClosure = { _ in
            self.btnStack.isHidden = true
        }
        
        // locationMessage popup 關掉時要讓右上選單出現
        childLocationMessageViewController.popupView.showMenuClosure = { _ in
            self.btnStack.isHidden = false
        }
        
        childLocationMessageViewController.popupView.showMenuClosure = { _ in
            self.btnStack.isHidden = false
        }
        
        // 一開始進到 homePage，LocationMessagePage timer 就會開始跑，所以要先停掉
//        childLocationMessageViewController.stopTimer()
        
        modifyCurrentLocation()
        
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { (notification) in
            
            // 停止 modifyCurrentLocation
            self.stopTimer()
            
            // Modify user onlineState
            self.updateOnlineState(false)
            
            print("app did enter background")
            
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: nil) { (notification) in
            
            // 啟動 modifyCurrentLocation
            self.startTimer()
            
            // Modify user onlineState
            self.updateOnlineState(true)
            
            print("app back to foreground")
            
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: nil) { (notification) in
            
            // Modify user onlineState
            self.updateOnlineState(false)
            
            print("app terminate")
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("func modifyCurrentLocation 時間器啟動")
        startTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if locationManager.authorizationStatus == .denied {
            self.showAlert(title: "Ooops!", message: "This page is disabled because your location permission is off. Turn it on and you can experience the map features.", viewController: self)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("func modifyCurrentLocation 時間器暫停")
        stopTimer()
    }
    
    @objc func filterButtonTouchUpInside() {
        
        showAlert(title: "", message: "New feature is under development, coming soon!", viewController: self)
        
    }
    
    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 120, target: self, selector: #selector(modifyCurrentLocation), userInfo: nil, repeats: true)
    }
    
    // TODO: 清除 timer 的其他方式
    func stopTimer() {
        timer.invalidate()
    }
    
    // 設定每 120 秒 update 一次（自己） currentLocation
    @objc func modifyCurrentLocation() {

        let documentReference = database.collection("userTest").document(currentUserUID)
        
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  var user = try? document.data(as: Users.self)
            else {
                return
            }

            user.location = ["latitude": Double(currentCoordinate?.latitude ?? defaultCurrentCoordinate.latitude), "longitude": Double(currentCoordinate?.longitude ?? defaultCurrentCoordinate.longitude)]

            do {
                try documentReference.setData(from: user)
                print("更新目前位置為：", user.location)
            } catch {
                print(error)
            }
            
        }
    }
    
    func updateOnlineState(_ state: Bool) {
        
        database.collection("userTest").document(currentUserUID).setData([
            "onlineState": state
        ], merge: true)
        
    }
    
    func updateOnlineState1(_ state: Bool) {
        
        // Modify user onlineState
        database.collection("userTest").document(currentUserUID).getDocument { documentSnapshot, error in
            
            guard let documentSnapshot,
                  documentSnapshot.exists,
                  var user = try? documentSnapshot.data(as: Users.self)
            else {
                return
            }
            
            user.onlineState = state
            
            do {
                try database.collection("userTest").document(currentUserUID).setData(from: user)
            } catch {
                print(error)
            }
            
        }
    }
    
    // 切換模式
    @objc func switchModeButtonTouchUpInside() {
        
        if switchMode == false {
            switchMode.toggle()
            switchModeButton.setImage(UIImage(named: "Icons_People"), for: .normal)
            childLocationMessageViewController.startTimer()
            childNearbyUsersViewController.stopTimer()
        } else {
            switchMode.toggle()
            switchModeButton.setImage(UIImage(named: "Icons_Message"), for: .normal)
            childLocationMessageViewController.stopTimer()
            childNearbyUsersViewController.startTimer()
        }
        
        nearbyUsersContainerView.isHidden.toggle()
        locationMessageContainerView.isHidden.toggle()
    }
    
    // 回到自己的定位位置
    @objc func locateButtonTouchUpInside() {
        childLocationMessageViewController.relocateMyself()
        childNearbyUsersViewController.relocateMyself()
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
        [filterButton, separaterbar1, switchModeButton, separaterbar2, backToMyLocationButton].forEach { subview in
            btnStack.addArrangedSubview(subview)
        }
        
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
//            make.bottom.equalTo(self.view).offset(-80)
            make.bottom.equalTo(self.view)
        }
        btnStack.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(80)
            make.trailing.equalTo(self.view).offset(-24)
        }
        filterButton.snp.makeConstraints { make in
            make.width.equalTo(48)
            make.height.equalTo(filterButton.snp.width)
        }
        separaterbar1.snp.makeConstraints { make in
            make.width.equalTo(filterButton.snp.width)
            make.height.equalTo(1)
        }
        switchModeButton.snp.makeConstraints { make in
            make.width.equalTo(48)
            make.height.equalTo(switchModeButton.snp.width)
        }
        separaterbar2.snp.makeConstraints { make in
            make.width.equalTo(filterButton.snp.width)
            make.height.equalTo(1)
        }
        backToMyLocationButton.snp.makeConstraints { make in
            make.width.equalTo(48)
            make.height.equalTo(backToMyLocationButton.snp.width)
        }
    }
    
}

extension HomePageViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .denied, .restricted:
            // TODO: 要改成跳 alert
//            self.showAlertAndNav(title: "Ooops!", message: "Please turn on your location setting to get better experience with Murmur Wall.", viewController: self)
//            self.showAlert(title: "Ooops!", message: "Your location permission is off. You can go to Settings > Privacy & Security > Location Services > Murmur, and turn on location setting to get better experience with Murmur Wall.", viewController: self)
//            self.showAlert(title: "Ooops!", message: "This page is disabled because your location permission is off. Turn it on and you can experience the map features.", viewController: self)
            print("User denied location access")
            
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        updateRegionsWithLocation(locations[0])
        
        guard let location = locations.last else { return }
        currentCoordinate = location.coordinate
        
        guard let currentCoordinate else {
            print("currentCoordinate 是空的！")
            return
        }
        
//        modifyCurrentLocation()
        setMapView()
        setContainerView()
    }
    
}
