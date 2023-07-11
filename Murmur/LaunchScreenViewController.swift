//
//  LaunchScreenViewController.swift
//  Murmur
//
//  Created by cleopatra on 2023/7/11.
//

import Foundation
import UIKit
import Lottie
import SnapKit

class LaunchScreenViewController: UIViewController {
    
    // MARK: Lottie
    let logoNameFlashAnimationView = LottieAnimationView(name: "LogoNameFlash")
    let logoMessageBornAnimationView = LottieAnimationView(name: "LogoMessageBorn")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .PrimaryLighter
        
        layoutView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        lottieLogoNameFlash()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                self.lottieLogoMessageBorn()
            }

    }
    
    func lottieLogoNameFlash() {
        logoNameFlashAnimationView.play()
        logoNameFlashAnimationView.loopMode = .playOnce
    }
    
    func lottieLogoMessageBorn() {
        logoMessageBornAnimationView.play()
        logoMessageBornAnimationView.loopMode = .playOnce
    }
    
    func layoutView() {
        
        self.view.addSubview(logoNameFlashAnimationView)
        self.view.addSubview(logoMessageBornAnimationView)
        
        logoNameFlashAnimationView.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-10)
        }
        logoMessageBornAnimationView.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.center)
            make.centerY.equalTo(self.view).offset(-100)
        }
        
    }
    
}
