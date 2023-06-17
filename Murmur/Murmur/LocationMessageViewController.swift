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

class LocationMessageViewController: UIViewController {
    
    private let items = [
        IdentifiablePlace(lat: 25.03853373485767, long: 121.53185851373266, name: "這日料難吃別去"),
        IdentifiablePlace(lat: 25.038903111815653, long: 121.53256662420604, name: "四海雲集八方遊龍每次都搞不清楚")
    ]
    
    // 1.創建 locationManager
    private let locationManager = CLLocationManager()
    private var monitoredRegions: Dictionary<String, Date> = [:]
//    private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.500702, longitude: -0.124562), latitudinalMeters: 1000, longitudinalMeters: 1000)
    private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 25.038722870138926, longitude: 121.53239166252195), latitudinalMeters: 300, longitudinalMeters: 300)
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
                
        return mapView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
   
        layoutView()
        addAnnotations()
        setLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.startUpdatingLocation()
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
    
    private func layoutView() {
//        self.view.addSubview(mapView)
//        mapView.snp.makeConstraints { make in
//            make.edges.equalTo(self.view)
//        }
        mapView.frame = view.bounds
        
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        
        // 設定初始地圖區域
//        mapView.setRegion(region, animated: true)
    }
    
    private func addAnnotations() {
            for item in items {
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.location
                annotation.title = item.name
                mapView.addAnnotation(annotation)
            }
        }
    
    private func setupData() {
        // 1. 檢查系統是否能夠監視 region
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {

            // 2.準備 region 會用到的相關屬性
            let title = "未知玩家"
            let coordinate = CLLocationCoordinate2DMake(25.03889164303853, 121.53317942146191)
            let regionRadius = 200.0 // 範圍半徑

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
            let circle = MKCircle(center: coordinate, radius: regionRadius)
            mapView.addOverlay(circle)
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
        setupData()
        
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
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
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
        guard let location = locations.last else { return }
        
        // 停止更新位置
        locationManager.stopUpdatingLocation()
        
        // 設定初始地圖區域為使用者當前位置
//        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: false)
    }
    
}
