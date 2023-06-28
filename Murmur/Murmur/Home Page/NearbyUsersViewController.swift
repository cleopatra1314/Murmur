//
//  NearbyUsersViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/17.
//

import UIKit
import SnapKit
import MapKit
import CoreLocation
import FirebaseFirestore

class NearbyUsersViewController: UIViewController {
    
    let regionRadius = 200.0 // 範圍半徑
    
    var userData: [Users]?
    let database = Firestore.firestore()
    var timer = Timer()
    
    // 1.創建 locationManager
    let locationManager = CLLocationManager()
    private var monitoredRegions: Dictionary<String, Date> = [:]
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.backgroundColor = .white

        return mapView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        relocateMyself()

        // 啟動 locationManager，才會執行 CLLocationManagerDelegate 的 func
        self.locationManager.startUpdatingLocation()
        
        layoutView()
        setLocationManager()
    }
    
    private func layoutView() {
        self.view.addSubview(mapView)
        mapView.frame = view.bounds
        
        // TODO: 以下寫法在小雞型會跑版
//        mapView.snp.makeConstraints { make in
//            make.edges.equalTo(self.view.snp.margins)
//        }
    }
    
    // 設定每 30 秒 fetch 一次有上線用戶們的位置，記得每次要先清掉全部再加
    @objc func fetchUserLocation() {
        
        database.collectionGroup("userTest").getDocuments { querySnapshot, error in
            
//            if let querySnapshot = querySnapshot {
//                for document in querySnapshot.documents {
////                    print("JSON 資料", document.data())
//                }
//            } else {
//                return
//            }
            
            guard let querySnapshot else { return }
            for document in querySnapshot.documents {
//                    print("JSON 資料", document.data())
            }
            
            let users = querySnapshot.documents.compactMap { querySnapshot in
                do {
                    return try querySnapshot.data(as: Users.self)
                } catch {
                    print("fetchUserLocation", error)
                    return nil
                }
            }
            
            self.userData = users
            print("解析完後的資料", self.userData)
            
            DispatchQueue.main.async { [self] in
                
                mapView.removeAnnotations(mapView.annotations)
                
                for user in self.userData! {
                    self.showOtherUsersOnMap(user.id!, user.userName, user.userPortrait, CLLocationCoordinate2D(latitude: user.location["latitude"]!, longitude: user.location["longitude"]!))
                }
                print("共有哪些小怪獸", self.mapView.annotations, self.mapView.annotations.count, "隻")
                
            }
            
        }
        
    }
    
    func startTimer() {
        stopTimer()
        print("func fetchUserLocation 時間器啟動")
        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(fetchUserLocation), userInfo: nil, repeats: true)
    }
    
    // TODO: 清除 timer 的其他方式
    func stopTimer() {
        print("func fetchUserLocation 時間器暫停")
        timer.invalidate()
    }
    
    func showOtherUsersOnMap(_ userUID: String, _ name: String, _ imageURL: String, _ coordinate: CLLocationCoordinate2D) {
        
        if userUID == currentUserUID {
            return
        }
        
        let userUID = userUID
        let coordinate = coordinate
        let annotation = OtherUsersAnnotation(userUID: userUID, userName: name, userImage: imageURL, coordinate: coordinate)
        print("showOtherUsersOnMap 的小怪獸名稱", name)
        mapView.addAnnotation(annotation)
        print("showOtherUsersOnMap 的小怪獸數量", mapView.annotations.count)
    }
    
    // 5. 繪製一個以自己為中心的圓圈範圍
    private func drawCircleRegion() {
        let circle = MKCircle(center: currentCoordinate!, radius: regionRadius)
        mapView.removeOverlays(mapView.overlays)
        mapView.addOverlay(circle)
    }
    
    func relocateMyself() {
        // 設定初始地圖區域為使用者當前位置
        let region = MKCoordinateRegion(center: currentCoordinate!, latitudinalMeters: 800, longitudinalMeters: 800)
        mapView.setRegion(region, animated: false)
    }
    
//    private func setupData() {
//        // 1. 檢查系統是否能夠監視 region
//        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
//
//            // 2.準備 region 會用到的相關屬性
//            let title = "未知玩家"
//            let coordinate = CLLocationCoordinate2DMake(25.03889164303853, 121.53317942146191)
//            let regionRadius = 200.0 // 範圍半徑
//
//            // 3. 設置 region 的相關屬性
//            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude,
//                longitude: coordinate.longitude), radius: regionRadius, identifier: title)
//            locationManager.startMonitoring(for: region)
//
//            // 4. 創建大頭釘(annotation)
//            let restaurantAnnotation = OtherUsersAnnotation(coordinate: coordinate)
//            restaurantAnnotation.title = title
//            mapView.addAnnotation(restaurantAnnotation)
//
//            // 5. 繪製一個圓圈圖形（用於表示 region 的範圍）
//            let circle = MKCircle(center: coordinate, radius: regionRadius)
//            mapView.addOverlay(circle)
//        } else {
//            print("System can't track regions")
//        }
//    }
    
    private func setupData() {
        // 1. 检查系统是否支持监视区域
        guard CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) else {
            print("System can't track regions")
            return
        }

        // 2. 准备区域相关属性
        let title = "自我"
        let coordinate = CLLocationCoordinate2D(latitude: 25.09119, longitude: 121.45720)
        let regionRadius = 200.0 // 区域半径

        // 3. 设置区域
//        let region = CLCircularRegion(center: coordinate, radius: regionRadius, identifier: title)
//        region.notifyOnEntry = true // 当用户进入区域时触发通知
//        locationManager.startMonitoring(for: region)

        // 4. 创建大头针
        let annotation = MeAnnotation(coordinate: coordinate)
        annotation.title = title
        mapView.addAnnotation(annotation)

        // 5. 绘制区域圆形
//        let circle = MKCircle(center: coordinate, radius: regionRadius)
//        mapView.addOverlay(circle)
    }

    private func setupMyRangeMonitor() {
        // 1. 檢查系統是否能夠監視 region
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {

            // 2.準備 region 會用到的相關屬性
            let title = "It's me"
//            let coordinate = CLLocationCoordinate2DMake(25.03889164303853, 121.53317942146191)

            // 3. 設置 region 的相關屬性
            let region = CLCircularRegion(center: currentCoordinate!, radius: regionRadius, identifier: title)
            region.notifyOnEntry = true // 当用户进入区域时触发通知
            locationManager.startMonitoring(for: region)

            // 4. 創建大頭釘(annotation)
//            let meAnnotation = MeAnnotation(coordinate: currentCoordinate!)
//            meAnnotation.title = title
//            mapView.addAnnotation(meAnnotation)
            
        } else {
            print("System can't track regions")
        }
    }
    
    // MARK: - Comples business logic
    func updateRegionsWithLocation(_ location: CLLocation) {

        let regionMaxVisiting = 10.0
        var regionsToDelete: [String] = []

        for regionIdentifier in monitoredRegions.keys {
            if Date().timeIntervalSince(monitoredRegions[regionIdentifier]!) > regionMaxVisiting {
                print("Thanks for visiting our restaurant")

                regionsToDelete.append(regionIdentifier)
            }
        }

        for regionIdentifier in regionsToDelete {
            monitoredRegions.removeValue(forKey: regionIdentifier)
        }
    }

}

extension NearbyUsersViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    private func setLocationManager() {
        
        // 2. 配置 locationManager
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyBestForNavigation
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // 3. 配置 mapView
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        // 4. 加入測試數據
//        setupData()
        setupMyRangeMonitor()
        
    }
    
    // MARK: - MKMapViewDelegate
    // 6. 繪製圓圈
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
//        circleRenderer.strokeColor = UIColor(red: 171/255, green: 130/255, blue: 255/255, alpha: 1)
        circleRenderer.fillColor = UIColor(red: 147/255, green: 112/255, blue: 219/255, alpha: 0.15)
//        circleRenderer.lineWidth = 1
        return circleRenderer
    }
    
    // 自訂標註視圖
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is OtherUsersAnnotation {
            let identifier = "\(OtherUsersAnnotation.self)"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = OtherUsersAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
             }
            return annotationView
        } else {
            let identifier = "MeAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MeAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        }
        
    }
    
    // 點擊用戶小怪獸可跟他對話
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // ??检查是否点击的是标注视图
        guard let annotation = view.annotation else {
            return
        }
        
        if view.annotation is MeAnnotation {
            return
        }
        
        guard let selectedAnnotation = view.annotation as? OtherUsersAnnotation else {
            print("選到自己：selectedAnnotation is nil")
            return
        }
        print("點擊的用戶 UUID", selectedAnnotation.userUID)
        // 拿到點擊的用戶 UUID 後
        // present chatRoom VC
        // 將 用戶 UUID 傳值給 chatRoom VC
        // chatRoom VC 會先撈 用戶 UUID，顯示該用戶名稱、塗鴉紀錄等
        // 若傳送了第一則訊息，則 create chatroom data to firebase，chatroom document 名稱為 點擊的用戶 UUID
        // chatRoom VC 再藉由這個 用戶 UUID fetch 對話資料
        
        // 实例化目标视图控制器
        let chatRoomVC = ChatRoomViewController()
        let navigationControllerOfNearbyUsersVC = UINavigationController(rootViewController: chatRoomVC)
        
        // 在这里可以将标注的信息传递给目标视图控制器，將點擊的那個用戶資料傳到聊天室頁面
        // 例如，如果标注包含特定的标识符或数据，您可以将其传递给目标视图控制器进行相关操作
        chatRoomVC.otherUserUID = selectedAnnotation.userUID
        chatRoomVC.otherUserName = selectedAnnotation.userName
        chatRoomVC.otherUserImageURL = selectedAnnotation.userImage
        
        // 执行视图控制器的跳转
        navigationControllerOfNearbyUsersVC.modalPresentationStyle = .fullScreen
        navigationControllerOfNearbyUsersVC.modalTransitionStyle = .crossDissolve
        present(navigationControllerOfNearbyUsersVC, animated: true)
        
//        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    // MARK: - CLLocationManagerDelegate
    // 1. 當用戶進入一個 region
    private func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        print("enter \(region.identifier)")
//        monitoredRegions[region.identifier] = Date()
        
        if let annotation = mapView.annotations.first(where: { $0.title == region.identifier }) as? OtherUsersAnnotation {
                // 在此处理其他用户进入区域的逻辑
                // 可以更新UI、发送通知等操作
                print("Other user entered the region: \(region.identifier)")
            }
    }

    // 2. 當用戶退出一個 region
    private func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("exit \(region.identifier)")
        monitoredRegions.removeValue(forKey: region.identifier)
    }
    
    // TODO: internal
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // ?? 自己位置一有變動就更新到 currentCoordinate，目前交由 HomePageViewController 執行，測試後可刪掉
//        guard let location = locations.last else { return }
//        currentCoordinate = location.coordinate
        
        drawCircleRegion()
        
    }
    
}
