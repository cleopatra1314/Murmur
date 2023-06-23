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

var currentCoordinate: CLLocationCoordinate2D? {
    didSet {
        print("目前位置", currentCoordinate)
    }
}

class HomePageViewController: UIViewController {
    
    let testButton: UIButton = {
       let testButton = UIButton()
        testButton.frame = CGRect(x: 100, y: 100, width: 200, height: 60)
        testButton.backgroundColor = .white
        testButton.layer.borderColor = UIColor.red.cgColor
        testButton.layer.borderWidth = 3
        testButton.setTitle("Test", for: .normal)
        testButton.setTitleColor(.red, for: .normal)
        testButton.addTarget(self, action: #selector(modifyCurrentLocation), for: .touchUpInside)
        return testButton
    }()
    
    var currentUserUID = String()
    
    let database = Firestore.firestore()
    var timer = Timer()
    
    var userData1: [String: Any] = [
        "userName": "nickName",
        "userPortrait": "imageURL",
        "location": ["latitude": 25.040094628617304, "longitude": 121.53261288219679]
//        "postedMurmur": [String: Any].self,
//        "savedMurmur": [String: Any].self
    ]
    var userData: Users?
    // 從首頁登入時就給
    let user1 = Users(userName: "Angela", userPortrait: "AngelaImageURL", location: ["latitude": 25.061607251329995, "longitude": 121.43349484382925])
    
    private let locationManager = CLLocationManager()
    
    private let userEmailTextField: UITextField = {
       let userEmailTextField = UITextField()
        userEmailTextField.text  = "user2@gmail.com"
        return userEmailTextField
    }()
    private let userPasswardTextField: UITextField = {
        let userPasswardTextField = UITextField()
        userPasswardTextField.text  = "222222"
        return userPasswardTextField
    }()
    
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
//    let alertController: UIAlertController = {
//        let alertController = UIAlertController(title: "建議", message: "請開啟你的定位服務以繼續使用 app", preferredStyle: .alert)
//        // swiftlint:disable line_length
//        //    let alertController = UIAlertController(title: "建議", message: "Location services were previously denied. Please enable location services for this app in Settings.", preferredStyle: .alert)
//        // swiftlint:enable line_length
//        alertController.addAction(UIAlertAction(title: "確定", style: .default))
//        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
//        // TODO: 加上 handler closure 引導使用者開定位功能
//        return alertController
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userData = user1
        self.view.backgroundColor = .red
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        // 一開始進到 homePage，LocationMessagePage timer 就會開始跑，所以要先停掉
        childLocationMessageViewController.stopTimer()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
    
    func startTimer() {
        stopTimer()
        print("時間器啟動")
        timer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(modifyCurrentLocation), userInfo: nil, repeats: true)
    }
    
    // TODO: 清除 timer 的其他方式
    func stopTimer() {
        timer.invalidate()
    }
    
    // MARK: Sign up through programmer，建立帳號成功後使用者將是已登入狀態，下次重新啟動 App 也會是已登入狀態
    func userSignUp() {
        
        Auth.auth().createUser(withEmail: "user11@gmail.com", password: "111111") { result, error in
            guard let user = result?.user,
                  error == nil else {
                print(error?.localizedDescription ?? "no error?.localizedDescription")
                return
            }
            print("\(result?.user.uid)，\(result?.user.email) 註冊成功")
            self.currentUserUID = user.uid
            DispatchQueue.main.async {
                self.createUsers(userUID: user.uid)
            }
        }
        
    }
    
    // MARK: Sign in，登入後使用者將維持登入狀態，就算我們重新啟動 App ，使用者還是能保持登入
    func userSignIn() {
        
        // text 屬於 UI，所以要在 main thread 執行
//        DispatchQueue.main.async {
            guard let userEmail = self.userEmailTextField.text else { return }
            guard let userPassward = self.userPasswardTextField.text else { return }
            
            Auth.auth().signIn(withEmail: userEmail, password: userPassward) { result, error in
                guard error == nil else {
                    print(error?.localizedDescription ?? "no error?.localizedDescription")
                    print(userEmail, userPassward)
                    print("登入 failed")
                    return
                }
                guard let userID = result?.user.uid else { return }
                self.currentUserUID = userID
                print("\(result?.user.uid) 登入成功")
 
//            }
        }
    
    }
    
    // 新增使用者資料到 firebase
    func createUsers(userUID: String) {

//        userData["userName"] = "Libby"
//        userData["userPortrait"] = "LibbyimageURL"
//        userData["location"] = ["latitude": currentCoordinate?.latitude, "longitude": currentCoordinate?.longitude]
        //        userData["postedMurmur"] = [String: Any].self
        //        userData["savedMurmur"] = [String: Any].self
//        print("準備上推的 userName", userData["user"], userData["location"], "使用者", currentUserUID)
//        database.collection("userTest").document(userUUID).setData(userData)
        
//        let documentReference = database.collection("userTest").document(userUUID)

        // setData 會更新指定 documentID 的那個 document 的資料，如果沒有那個 collection 或 document id，則會新增
        database.collection("userTest").document(userUID).setData([
            
            "userName": userData?.userName,
            "userPortrait": userData?.userPortrait,
            "location": ["latitude": userData?.location["latitude"], "longitude": userData?.location["longitude"]]

        ])
        
    }
    
    // 設定每 300 秒 update 一次 currentLocation
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
        [filterButton, switchModeButton, backToMyLocationButton].forEach { subview in
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
    
    func showAlert(title: String, message: String, viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
}

extension HomePageViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            // TODO: 要改成跳 alert
            showAlert(title: "Oops!", message: "Please check your location setting to get better experience with Murmur Wall.", viewController: self)
        case .authorizedWhenInUse:
            userSignIn()
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        updateRegionsWithLocation(locations[0])
        
        guard let location = locations.last else { return }
        currentCoordinate = location.coordinate
        
        setMapView()
        setContainerView()
        self.view.addSubview(testButton)
    }
    
}
