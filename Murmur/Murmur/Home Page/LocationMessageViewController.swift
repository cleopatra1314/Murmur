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
//import SwiftUI
//
// 預覽 swiftUI 畫面
//struct PreviewViewController: UIViewControllerRepresentable {
//    typealias UIViewControllerType = UIViewController
//
//    func makeUIViewController(context: Context) -> UIViewController {
//        // 在此處初始化並返回您要預覽的 UIKit ViewController
//        let viewController = HomePageViewController() // viewController 為您要預覽的實際 ViewController
//        return viewController
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        // 這個方法留空，因為您不需要在此處更新預覽的 UIKit ViewController
//    }
// }
//
// struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        PreviewViewController().previewDevice("iPhone 14") // 根據您的需求選擇預覽的裝置
//    }
// }

class LocationMessageViewController: UIViewController {
    
    private let dataBase = Firestore.firestore()
    private var murmurData: [Murmurs]?
    
    var popupClosure: ((UIViewController) -> Void)?
    // 1.創建 locationManager
    let locationManager = CLLocationManager()
    
    let myRegionRadius = 300.0 // 範圍半徑
    let screenRegionRadius = 550.0
    
    var timer = Timer()
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()
    lazy var popupView: PostDetailsPopupView = {
        let popupView = PostDetailsPopupView()
        popupView.backgroundColor = .PrimaryLighter
        popupView.delegate = self
        return popupView
    }()
    let blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView()
        blurView.effect = UIBlurEffect(style: .light)
        return blurView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView.closeClosure = { [self] view, rowOfindexPath in
            self.animateScaleOut(desiredView: self.popupView)
            self.animateScaleOut(desiredView: self.blurView)
        }
        
        relocateMyself()
        
        // 啟動 locationManager，才會執行 CLLocationManagerDelegate 的 func
        self.locationManager.startUpdatingLocation()
        
//        fetchMurmur()
        layoutView()
        filterLocationMessage()
        setLocation()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchMurmur()
        
        blurView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
//        blurView.bounds = self.view.bounds
        popupView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width*0.9, height: self.view.bounds.height*0.85)
//        drawCircleRegion()
    }

    private func layoutView() {

        mapView.frame = view.bounds
//        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: "\(CustomAnnotationView.self)")
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: "\(CustomAnnotationView.self)")

    }
    
    // 為什麼沒寫 stopTimer() 就會無效
    func startTimer() {
        stopTimer()
        print("func fetchMurmur 時間器啟動")
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(fetchMurmur), userInfo: nil, repeats: true)
    }
    
    // TODO: 清除 timer 的其他方式
    func stopTimer() {
        print("func fetchMurmur 時間器暫停")
        timer.invalidate()
    }
    
    func relocateMyself() {
        
        // 設定初始地圖區域為使用者當前位置
        let region = MKCoordinateRegion(center: currentCoordinate ?? defaultCurrentCoordinate, latitudinalMeters: screenRegionRadius, longitudinalMeters: screenRegionRadius)
        mapView.setRegion(region, animated: true)
    }
    
    // 使用者在這個頁面時，每隔幾秒 fetch 一次資料
    @objc func fetchMurmur() {
        
        dataBase.collection("murmurTest").getDocuments { snapshot, error in
            
            guard let snapshot else {
                // ??
                print(error)
                return
            }

            let murmurTest = snapshot.documents.compactMap { snapshot in
                do {
                    return try snapshot.data(as: Murmurs.self)
                } catch {
                    print("fetchMurmur", error)
                    return nil
                }
            }
            self.murmurData = murmurTest
//            print(self.murmurData ?? [Murmurs]())
            DispatchQueue.main.async {
                self.filterLocationMessage()
            }
            
        }
        
    }
    
    @objc func filterLocationMessage() {
        
        guard let murmurData else { return }
        
        // TODO: 先把之前的 annotation 全部清除
        mapView.removeAnnotations(mapView.annotations)
        
        for murmurItem in murmurData {

            let coordinateOfMessage = CLLocationCoordinate2D(latitude: murmurItem.location["latitude"] ?? defaultCurrentCoordinate.latitude, longitude: murmurItem.location["longitude"] ?? defaultCurrentCoordinate.longitude)
            
            guard let coordinateOfMe = currentCoordinate else { return }
            
            let distanceBetweenMeAndMessage = calculateDistance(from: coordinateOfMessage, to: coordinateOfMe)
            
            if distanceBetweenMeAndMessage <= myRegionRadius {
                let annotation = InsideMessageAnnotation(murmurData: murmurItem, coordinate: coordinateOfMessage)
                annotation.title = murmurItem.murmurMessage
                mapView.addAnnotation(annotation)
                
            } else {
                let annotation = OutsideMessageAnnotation(coordinate: coordinateOfMessage)
                annotation.title = murmurItem.murmurMessage
                mapView.addAnnotation(annotation)
                
            }
        
        }
        
        drawCircleRegion()
        
    }
    
    // 讓範圍跟著用戶移動更新
    private func drawCircleRegion() {
        let circle = MKCircle(center: currentCoordinate ?? defaultCurrentCoordinate, radius: myRegionRadius)
        mapView.removeOverlays(mapView.overlays)
        mapView.addOverlay(circle)
    }
    
}

extension LocationMessageViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else {
            return
        }
     
        guard let annotationSelected = view.annotation as? InsideMessageAnnotation else {
            print("annotationSelected 轉型 OtherUsersAnnotation 失敗")
            return
        }
        
        let murmur = annotationSelected.murmurData
        
        if murmur.murmurImage == "" {
            popupView.postImageView.image = UIImage(named: "Placeholder.png")
        } else {
            popupView.postImageView.kf.setImage(with: URL(string: murmur.murmurImage))
        }
        
        popupView.postContentLabel.text = murmur.murmurMessage
        //                popupView.tagArray.removeAll()
        popupView.tagArray = murmur.selectedTags
//        popupView.currentRowOfIndexpath = rowOfIndexPath
        
        reverseGeocodeLocation(latitude: murmur.location["latitude"]!, longitude: murmur.location["longitude"]!) { address in
           
            self.popupView.postCreatedSiteLabel.text = address
            
        }
        
        // 隱藏 HomePageViewController 的選單
        self.popupClosure!(self)
        
        let timestamp: Timestamp = murmur.createTime // 從 Firestore 中取得的 Timestamp 值
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd" // 例如："yyyy-MM-dd HH:mm" -> 2023-06-10 15:30
        let date = timestamp.dateValue()
        let formattedTime = dateFormatter.string(from: date)
        popupView.postCreatedTimeLabel.text = formattedTime
        
        self.animateScaleIn(desiredView: self.blurView)
        self.animateScaleIn(desiredView: self.popupView)
        
    }
    
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
            let identifier = "\(CustomAnnotationView.self)"
            
            guard var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier, for: annotation) as? CustomAnnotationView else { return MKAnnotationView() }
            
//            if annotationView == nil {
                annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        
                // 是否要讓點擊 annotation 時顯示 title
                annotationView.canShowCallout = false
                
//            } else {
                annotationView.annotation = annotation
                annotationView.label.text = annotation.title!
                
//             }
            return annotationView
            
        } else if annotation is OutsideMessageAnnotation {
            let identifier = "\(DialogAnnotationView.self)"
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
            annotationView?.canShowCallout = true
            
            if annotationView == nil {
                annotationView = MeAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        }
        
    }

    // CLLocationManagerDelegate 方法，當位置更新時呼叫
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        updateRegionsWithLocation(locations[0])
        drawCircleRegion()
        guard let location = locations.last else { return }
        currentCoordinate = location.coordinate
    
    }
    
}

extension LocationMessageViewController {
    
    func calculateDistance(from coordinate1: CLLocationCoordinate2D, to coordinate2: CLLocationCoordinate2D) -> CLLocationDistance {
        let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
        let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)
        
        return location1.distance(from: location2)
    }

}

extension LocationMessageViewController: PostDetailsPopupViewDelegate {
    
    func showSettingMenu(view: UIView) {
        
        let alertController = UIAlertController(title: "", message: "More action", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Report", style: .default) { action in
            
            print(action)
            let reportAlertController = UIAlertController(title: "", message: "Why are you reporting this post?", preferredStyle: .actionSheet)
            let reportActions = ["I don't like it", "Violence or dangerous organizations", "Nudity or sexual activity", "Bullying or harassment"]
            for actionContent in reportActions {
                let reportAction = UIAlertAction(title: actionContent, style: .default) { _ in
                    self.showAlert(title: "Reported", message: "We have received your report message and will deal with it within 24 hrs.", viewController: self)
                }
                reportAlertController.addAction(reportAction)
            }
            let cancelReportAction = UIAlertAction(title: "Cancel", style: .cancel)
            reportAlertController.addAction(cancelReportAction)
            self.present(reportAlertController, animated: true)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        [action, cancelAction].forEach { action in
            alertController.addAction(action)
        }
        present(alertController, animated: true)
        
    }
    
}

extension UIDevice {
    static var hasDynamicIsland: Bool {
        ["iPhone 14 Pro", "iPhone 14 Pro Max"].contains(current.name)
    }
}
