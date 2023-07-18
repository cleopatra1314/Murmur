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
import FirebaseCore
import FirebaseFirestore

class FootPrintViewController: UIViewController {
    
    var myMurmurData: [Murmurs]?
    
    let locationManager = CLLocationManager()
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.layer.cornerRadius = 14
        mapView.clipsToBounds = true
        return mapView
    }()
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
    private let separaterbar1: UIView = {
        let separaterbar = UIView()
        separaterbar.frame = CGRect(x: 0, y: 0, width: 48, height: 2)
        separaterbar.backgroundColor = .SecondaryDefault
        return separaterbar
    }()
    private lazy var backToMyLocationButton: UIButton = {
        let backToMyLocationButton = UIButton()
        backToMyLocationButton.backgroundColor = .PrimaryDefault
        backToMyLocationButton.tintColor = .systemRed
        backToMyLocationButton.setImage(UIImage(named: "Icons_Locate"), for: .normal)
        backToMyLocationButton.addTarget(self, action: #selector(backToMyLocationButtonTouchUpInside), for: .touchUpInside)
        return backToMyLocationButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLocation()
        layoutView()
        fetchMyMurmur()
        print("****** FootPrintVC \(self) viewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        fetchMyMurmur()
        backToMyLocationButtonTouchUpInside()
    }
    
    private func setLocation() {
        
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: "\(CustomAnnotationView.self)")
        mapView.register(MeAnnotationView.self, forAnnotationViewWithReuseIdentifier: "\(MeAnnotationView.self)")
        
        // 2. 配置 locationManager
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyBestForNavigation
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // 3. 配置 mapView
        mapView.delegate = self
        mapView.mapType = .mutedStandard
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow

    }
    
    // fetch 自己留過的所有塗鴉
    func fetchMyMurmur() {
        
        database.collection("userTest").document(currentUserUID).collection("postedMurmurs").getDocuments { snapshot, error in
            
            guard let snapshot else {
                print(error)
                return
            }

            let murmurs = snapshot.documents.compactMap { snapshot in
                do {
                    return try snapshot.data(as: Murmurs.self)
                } catch {
                    print("fetchMurmur", error)
                    return nil
                }
            }
            
            self.myMurmurData = murmurs
            print(self.myMurmurData!)
            
            DispatchQueue.main.async {
                self.setAnnotaion()
                
            }
            
        }
        
    }
    
    private func setAnnotaion() {
        
        guard let myMurmurData else { return }
        
        // TODO: 先把之前的 annotation 全部清除
        mapView.removeAnnotations(mapView.annotations)
        
        for murmur in myMurmurData {
            
            let coordinateOfMessage = CLLocationCoordinate2D(latitude: murmur.location["latitude"]!, longitude: murmur.location["longitude"]!)
            
            let annotation = InsideMessageAnnotation(murmurData: murmur, coordinate: coordinateOfMessage)
            annotation.title = murmur.murmurMessage
            mapView.addAnnotation(annotation)
            
        }
        
        // 讓範圍跟著用戶移動更新
//        let circle = MKCircle(center: currentCoordinate ?? defaultCurrentCoordinate, radius: 200)
//        mapView.removeOverlays(mapView.overlays)
//        mapView.addOverlay(circle)
        
    }
    
    @objc func backToMyLocationButtonTouchUpInside() {
        
        // 設定初始地圖區域為使用者當前位置
        let region = MKCoordinateRegion(center: currentCoordinate ?? defaultCurrentCoordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(region, animated: false)
        
    }
    
    func layoutView() {
        
        self.view.backgroundColor = .PrimaryDefault
        
        self.view.addSubview(mapView)
//        mapView.frame = self.view.bounds
        self.mapView.addSubview(btnStack)
        self.btnStack.addArrangedSubview(filterButton)
        self.btnStack.addArrangedSubview(separaterbar1)
        self.btnStack.addArrangedSubview(backToMyLocationButton)
        
        mapView.snp.makeConstraints { make in
            make.top.leading.equalTo(self.view).offset(16)
            make.bottom.trailing.equalTo(self.view).offset(-16)
        }
        btnStack.snp.makeConstraints { make in
            make.top.equalTo(self.mapView).offset(24)
            make.trailing.equalTo(self.mapView).offset(-24)
        }
        filterButton.snp.makeConstraints { make in
            make.width.height.equalTo(48)
//            make.height.equalTo(filterButton.snp.width)
        }
        separaterbar1.snp.makeConstraints { make in
            make.width.equalTo(filterButton.snp.width)
            make.height.equalTo(1)
        }
        backToMyLocationButton.snp.makeConstraints { make in
            make.width.height.equalTo(48)
//            make.height.equalTo(switchModeButton.snp.width)
        }
        
    }
    
}

extension FootPrintViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier1 = "\(MeAnnotationView.self)"
        let identifier2 = "\(CustomAnnotationView.self)"
        
        if annotation.title == "My Location" {
            guard var meAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier1, for: annotation) as? MeAnnotationView else { return MKAnnotationView() }
            
            meAnnotationView = MeAnnotationView(annotation: annotation, reuseIdentifier: identifier1)
            
            return meAnnotationView
            //        }else if annotationView == nil {
        } else {
            guard var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier2, for: annotation) as? CustomAnnotationView else { return MKAnnotationView() }
            
            annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: identifier2)
    
            // 是否要讓點擊 annotation 時顯示 title
//            annotationView.canShowCallout = true
            print("地標", annotation, "地標標題", annotation.title)
            annotationView.annotation = annotation
            annotationView.label.text = annotation.title!
            
            return annotationView
         }
        
        
    }
}

extension FootPrintViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        currentCoordinate = location.coordinate
        
    }
}
