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

let defaultCurrentCoordinate = CLLocationCoordinate2D(latitude: 25.0385, longitude: 121.531)
var currentCoordinate: CLLocationCoordinate2D? {
    didSet {
        print("變動！目前位置", currentCoordinate)
    }
}
var currentUserUID = "djDaiZAAUtYCPMDr0JdqTtihUN02" // 可以用 Auth.auth().currentUser?.uid 取代
let database = Firestore.firestore()
let fullScreenSize = UIScreen.main.bounds

class HomePageViewController: UIViewController {
    
    var timer = Timer()

    var userData: Users?

    private let locationManager = CLLocationManager()
    
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
        btnStack.layer.cornerRadius = 10
        btnStack.clipsToBounds = true
        return btnStack
    }()
    private let filterButton: UIButton = {
        let filterButton = UIButton()
        filterButton.backgroundColor = .PrimaryDefault
        filterButton.tintColor = .SecondaryLight
        filterButton.setImage(UIImage(named: "Icons_Filter"), for: .normal)
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
        separaterbar.backgroundColor = .SecondaryDefault
        return separaterbar
    }()
    private let separaterbar2: UIView = {
        let separaterbar = UIView()
        separaterbar.frame = CGRect(x: 0, y: 0, width: 48, height: 2)
        separaterbar.backgroundColor = .SecondaryDefault
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
        
        // 一開始進到 homePage，LocationMessagePage timer 就會開始跑，所以要先停掉
        childLocationMessageViewController.stopTimer()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("func modifyCurrentLocation 時間器啟動")
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("func modifyCurrentLocation 時間器暫停")
        stopTimer()
    }
    
    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(modifyCurrentLocation), userInfo: nil, repeats: true)
    }
    
    // TODO: 清除 timer 的其他方式
    func stopTimer() {
        timer.invalidate()
    }
    
//    // MARK: Sign up through programmer，建立帳號成功後使用者將是已登入狀態，下次重新啟動 App 也會是已登入狀態
//    func userSignUp() {
//
//        Auth.auth().createUser(withEmail: "libby@gmail.com", password: "333333") { result, error in
//            guard let user = result?.user,
//                  error == nil else {
//                print(error?.localizedDescription ?? "no error?.localizedDescription")
//                return
//            }
//            print("\(result?.user.uid)，\(result?.user.email) 註冊成功")
//            currentUserUID = user.uid
//            DispatchQueue.main.async {
//                self.createUsers(userUID: user.uid)
//            }
//        }
//
//    }
//
//    // MARK: Sign in，登入後使用者將維持登入狀態，就算我們重新啟動 App ，使用者還是能保持登入
//    func userSignIn() {
//
//        // text 屬於 UI，所以要在 main thread 執行
////        DispatchQueue.main.async {
//            guard let userEmail = self.userEmailTextField.text else { return }
//            guard let userPassward = self.userPasswardTextField.text else { return }
//
//            Auth.auth().signIn(withEmail: userEmail, password: userPassward) { result, error in
//                guard error == nil else {
//                    print(error?.localizedDescription ?? "no error?.localizedDescription")
//                    print(userEmail, userPassward)
//                    print("登入 failed")
//                    return
//                }
//                guard let userID = result?.user.uid else { return }
//                currentUserUID = userID
//                print("\(result?.user.uid) 登入成功")
//
////            }
//        }
//
//    }
//
//    // 新增使用者資料到 firebase
//    func createUsers(userUID: String) {
//
//        // setData 會更新指定 documentID 的那個 document 的資料，如果沒有那個 collection 或 document id，則會新增
//        database.collection("userTest").document(userUID).setData([
//
//            // TODO: userData 無值這邊不會報錯，但會 build 不起來
//            "userName": userData?.userName,
//            "userPortrait": userData?.userPortrait,
//            "location": ["latitude": userData?.location["latitude"], "longitude": userData?.location["longitude"]]
//
//        ])
//
//    }
    
    // 設定每 300 秒 update 一次（自己） currentLocation
    @objc func modifyCurrentLocation() {

        let documentReference = database.collection("userTest").document(currentUserUID)
        
        documentReference.getDocument { document, error in
            guard let document,
                  document.exists,
                  var user = try? document.data(as: Users.self)
            else {
                return
            }
            
            user.location = ["latitude": Double(currentCoordinate!.latitude), "longitude": Double(currentCoordinate!.longitude)]
    
            do {
                try documentReference.setData(from: user)
                print("更新目前位置為：", user.location)
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
            make.bottom.equalTo(self.view).offset(-80)
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
            self.showAlert(title: "Oops!", message: "Please check your location setting to get better experience with Murmur Wall.", viewController: self)
        case .authorizedWhenInUse:
//            userSignIn()
//            userSignUp()
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

        setMapView()
        setContainerView()

    }
    
}
