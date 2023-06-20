//
//  MeAnnotationView.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/20.
//

import Foundation
import CoreLocation
import MapKit

class MeAnnotationView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        // 设置自定义图片
        let image = UIImage(named: "Pacman_red.png")
        self.image = image
    }
}
