//
//  ProgressCircleView.swift
//  Murmur
//
//  Created by cleopatra on 2023/7/8.
//

import Foundation
import UIKit

class ProgressCircleView: UIView {
    
    var passedTimeHr: Int = 12
    
    let aDegree = Double.pi / 180
    let lineWidth: Double = 4
    var radius = Double()
    let endDegree: Double = 270
    var circlePath = UIBezierPath()
    let circleLayer = CAShapeLayer()
    
    let totalTime: Int = 48
    
    var startDegree = Double()
    var percentagePath = UIBezierPath()
    let percentageLayer = CAShapeLayer()
    
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        setProgress(frame: frame)
        
        
    }
    
    func setProgress(frameWidth: Double) {
        
//        let aDegree = Double.pi / 180
//        let lineWidth: Double = 4
//        let radius: Double = frameWidth / 2 - lineWidth
//        let endDegree: Double = 270
//        let circlePath = UIBezierPath(ovalIn: CGRect(x: lineWidth, y: lineWidth, width: radius*2, height: radius*2))
//        let circleLayer = CAShapeLayer()
        radius = frameWidth / 2 - lineWidth
        circlePath = UIBezierPath(ovalIn: CGRect(x: lineWidth, y: lineWidth, width: radius*2, height: radius*2))

        circleLayer.path = circlePath.cgPath
        circleLayer.strokeColor = UIColor.PrimaryLight?.cgColor
        circleLayer.lineWidth = lineWidth
        circleLayer.fillColor = UIColor.clear.cgColor

//        let totalTime: CGFloat = 48
//
//        let startDegree = 360 * passedTimeHr / 48 - 90
//        let percentagePath = UIBezierPath(arcCenter: CGPoint(x: lineWidth + radius, y: lineWidth + radius), radius: radius, startAngle: aDegree * startDegree, endAngle: aDegree * endDegree, clockwise: true)
//        let percentageLayer = CAShapeLayer()
        startDegree = 360 * Double(passedTimeHr) / 48 - 90
        percentagePath = UIBezierPath(arcCenter: CGPoint(x: lineWidth + radius, y: lineWidth + radius), radius: radius, startAngle: aDegree * startDegree, endAngle: aDegree * endDegree, clockwise: true)

        percentageLayer.lineCap = .round
        percentageLayer.path = percentagePath.cgPath
        percentageLayer.strokeColor  = UIColor.SecondarySaturate?.cgColor
        percentageLayer.lineWidth = lineWidth
        percentageLayer.fillColor = UIColor.clear.cgColor

//        let viewWidth = 2*(radius+lineWidth)
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewWidth))
        self.layer.addSublayer(circleLayer)
        self.layer.addSublayer(percentageLayer)
//        let label = UILabel(frame: self.bounds)
        label.frame = self.bounds
        label.textAlignment = .center
        label.text = "\(totalTime - passedTimeHr)hr"
        label.font = UIFont(name: "PingFangTC-Regular", size: 8)
        self.addSubview(label)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
