//
//  LocationMessageViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/16.
//

import UIKit
import SnapKit
import MapKit
import CoreLocation
import FirebaseFirestore
import FirebaseCore

class LocationMessageViewController: UIViewController {
    
    private let dataBase = Firestore.firestore()
    private var murmurData: [Murmur]?
    
    // 1.創建 locationManager
    let locationManager = CLLocationManager()
    private var monitoredRegions: Dictionary<String, Date> = [:]
//    private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.500702, longitude: -0.124562), latitudinalMeters: 1000, longitudinalMeters: 1000)
//    private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 25.038722870138926, longitude: 121.53239166252195), latitudinalMeters: 300, longitudinalMeters: 300)
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchMurmur()
//         创建一个定时器，每隔5秒执行一次函数
//        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
//
//            self.fetchMurmur()
//        }
        
//         将定时器添加到当前运行循环中
//        RunLoop.current.add(timer, forMode: .common)
   
//        currentCoordinate = locationManager.location?.coordinate
        
        layoutView()
//        addAnnotations()
        filterLocationMessage()
        setLocation()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        relocateMyself()
//        // 1. 還沒有詢問過用戶以獲得權限
//        if CLLocationManager.authorizationStatus() == .notDetermined {
//            locationManager.requestAlwaysAuthorization()
//        }
//        // 2. 用戶不同意
//        else if CLLocationManager.authorizationStatus() == .denied {
//            present(alertController, animated: true)
//        }
//        // 3. 用戶已經同意
//        else if CLLocationManager.authorizationStatus() == .authorizedAlways {
//            locationManager.startUpdatingLocation()
//        }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
                // 取得定位服務授權
                locationManager.requestWhenInUseAuthorization()
                // 開始定位自身位置
                locationManager.startUpdatingLocation()
            }
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        fetchMurmur()
//    }

    private func layoutView() {

        mapView.frame = view.bounds
//        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        
        // 設定初始地圖區域
//        mapView.setRegion(region, animated: true)
    }
    
    // 為什麼沒寫 stopTimer() 就會無效
    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(fetchMurmur), userInfo: nil, repeats: true)
    }
    
    // TODO: 清除 timer 的其他方式
    func stopTimer() {
        timer.invalidate()
    }
    
    func relocateMyself() {
        // 設定初始地圖區域為使用者當前位置
        let region = MKCoordinateRegion(center: currentCoordinate!, latitudinalMeters: 300, longitudinalMeters: 300)
        mapView.setRegion(region, animated: false)
    }
    
//    private func addAnnotations() {
//
//        for item in murmurData! {
//
//            // TODO: 需要先把之前的全部清除 嗎？
//            if let annotations = mapView.annotations as? [MKAnnotation] {
//                mapView.removeAnnotations(annotations)
//            }
//
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = item.location.coordinate
//            annotation.title = item.murmurMessage
//            mapView.addAnnotation(annotation)
//
//        }
//    }
    
    private func setupData() {
        
        // 1. 檢查系統是否能夠監視 region
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {

            // 2.準備 region 會用到的相關屬性
            let title = "未知玩家"
            //            let coordinate = CLLocationCoordinate2DMake(25.03889164303853, 121.53317942146191)
            guard let coordinate = currentCoordinate else { return }
            let regionRadius = 300.0 // 範圍半徑
            
            // 3. 設置 region 的相關屬性
            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude,
                                                                         longitude: coordinate.longitude), radius: regionRadius, identifier: title)
            locationManager.startMonitoring(for: region)
            
            // 4. 創建大頭釘(annotation)
            let restaurantAnnotation = MKPointAnnotation()
            restaurantAnnotation.coordinate = coordinate
            restaurantAnnotation.title = "\(title)"
            mapView.addAnnotation(restaurantAnnotation)

            // 5. 繪製一個圓圈圖形（用於表示 region 的範圍）
//            let circle = MKCircle(center: coordinate, radius: regionRadius)
//            mapView.addOverlay(circle)
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
    
    // 使用者在這個頁面時，每隔幾秒 fetch 一次資料
    @objc func fetchMurmur() {
        
        dataBase.collection("murmurs").getDocuments { snapshot, error in
            
            guard let snapshot else { return }
            
            //            let murmurs = snapshot.documents.compactMap { snapshot in
            //                try? snapshot.data(as: Murmur.self)
            //            }
            let murmurs = snapshot.documents.compactMap { snapshot in
                do {
                    return try snapshot.data(as: Murmur.self)
                } catch {
                    print("******", error)
                    return nil
                }
            }
            // ??
            self.murmurData = murmurs
            
        }
        
        DispatchQueue.main.async {
//                self.addAnnotations()
            self.filterLocationMessage()
        }
    }
    
    @objc func filterLocationMessage() {
        
//        fetchMurmur()
        
        guard let murmurData else { return }
        
        // TODO: 先把之前的 annotation 全部清除
        if let annotations = mapView.annotations as? [MKAnnotation] {
            mapView.removeAnnotations(annotations)
        }
        
        for item in murmurData {
            
//            let latSquare = pow(item.location.coordinate.latitude - currentCoordinate.latitude, 2)
//            let longSquare = pow(item.location.coordinate.longitude - currentCoordinate.longitude, 2)
//            let distanceBetweenMeAndMessage = sqrt(latSquare + longSquare)
//            print(distanceBetweenMeAndMessage)
            
            let coordinate1 = CLLocationCoordinate2D(latitude: item.location["latitude"]!, longitude: item.location["longitude"]!)
            guard let coordinate2 = currentCoordinate else { return }
            let distanceBetweenMeAndMessage = calculateDistance(from: coordinate1, to: coordinate2)
            
            if distanceBetweenMeAndMessage <= 200 {
                let annotation = InsideMessageAnnotation(coordinate: coordinate1)
                annotation.title = item.murmurMessage
                mapView.addAnnotation(annotation)
                print("範圍內的塗鴉", item.murmurMessage, coordinate1)
            } else {
                let annotation = OutsideMessageAnnotation(coordinate: coordinate1)
                annotation.title = item.murmurMessage
                mapView.addAnnotation(annotation)
            }
        }
        
        // 讓範圍跟著用戶移動更新
        let circle = MKCircle(center: currentCoordinate!, radius: 200)
        mapView.removeOverlays(mapView.overlays)
        mapView.addOverlay(circle)
        
    }
    
}

extension LocationMessageViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    private func setLocation() {
        
        // 2. 配置 locationManager
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyBestForNavigation
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // 3. 配置 mapView
        mapView.delegate = self
        mapView.mapType = .mutedStandard
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        // 4. 加入測試數據
//        setupData()
        
    }
    
    // MARK: - MKMapViewDelegate
    // 6. 繪製圓圈
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.fillColor = UIColor(red: 102/255, green: 205/255, blue: 170/255, alpha: 0.15)
        circleRenderer.strokeColor = UIColor(red: 64/255, green: 224/255, blue: 208/255, alpha: 1)
        circleRenderer.lineWidth = 1.0
        return circleRenderer
    }
    
    // 自訂標註視圖
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        guard annotation is MKPointAnnotation else { return nil }
        
        if annotation is InsideMessageAnnotation {
            let identifier = "\(InsideMessageAnnotation.self)"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                print("範圍內的頭標標題", annotation.title)
                // 是否要讓點擊 annotation 時顯示 title
                annotationView?.canShowCallout = true
            }
//            else {
//                annotationView?.annotation = annotation
//             }
            return annotationView
            
        } else if annotation is OutsideMessageAnnotation {
            let identifier = "\(OutsideMessageAnnotation.self)"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = DialogAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = false
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
    
    // MARK: - CLLocationManagerDelegate
    // 1. 當用戶進入一個 region
    private func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("enter \(region.identifier)")
        monitoredRegions[region.identifier] = Date()
    }

    // 2. 當用戶退出一個 region
    private func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("exit \(region.identifier)")
        monitoredRegions.removeValue(forKey: region.identifier)
    }
    
    // TODO: internal
//    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        updateRegionsWithLocation(locations[0])
//    }
    
    // CLLocationManagerDelegate 方法，當位置更新時呼叫
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        updateRegionsWithLocation(locations[0])
        
        guard let location = locations.last else { return }
        currentCoordinate = location.coordinate
        // 停止更新位置
//        locationManager.stopUpdatingLocation()
    
    }
    
}

extension LocationMessageViewController {
    
    func calculateDistance(from coordinate1: CLLocationCoordinate2D, to coordinate2: CLLocationCoordinate2D) -> CLLocationDistance {
        let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
        let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)
        
        return location1.distance(from: location2)
    }

}
