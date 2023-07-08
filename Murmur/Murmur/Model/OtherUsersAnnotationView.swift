//
//  OtherUserAnnotationView.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/20.
//

import Foundation
import CoreLocation
import MapKit

class OtherUsersAnnotationView: MKAnnotationView {
    
    var imageName = "Pacman_blue.png"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        // 设置自定义图片
        let image = UIImage(named: self.imageName)
        self.contentMode = .scaleAspectFill
        self.image = image
    }
}
