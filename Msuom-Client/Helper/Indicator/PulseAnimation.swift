//
//  PulseAnimation.swift
//  Msuom
//
//  Created by MGAbouarab on 03/11/2022.
//

import UIKit

class PulseAnimation: CALayer {

    var animationGroup = CAAnimationGroup()
    var animationDuration: TimeInterval = 1.5
    var radius: CGFloat = 200
    var numberOfPulse: Float = Float.infinity
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(numberOfPulse: Float = Float.infinity, radius: CGFloat, position: CGPoint){
        super.init()
        self.backgroundColor = UIColor.black.cgColor
        self.contentsScale = UIScreen.main.scale
        self.opacity = 0
        self.radius = radius
        self.numberOfPulse = numberOfPulse
        self.position = position
        
        self.bounds = CGRect(x: 0, y: 0, width: radius*2, height: radius*2)
        self.cornerRadius = radius
        
        DispatchQueue.global(qos: .default).async {
            self.setupAnimationGroup()
            DispatchQueue.main.async {
                self.add(self.animationGroup, forKey: "pulse")
           }
        }
    }
    
    func scaleAnimation() -> CABasicAnimation {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = NSNumber(value: 0)
        scaleAnimation.toValue = NSNumber(value: 1)
        scaleAnimation.duration = animationDuration
        return scaleAnimation
    }
    
    func createOpacityAnimation() -> CAKeyframeAnimation {
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = animationDuration
        opacityAnimation.values = [0.4,0.8,0]
        opacityAnimation.keyTimes = [0,0.3,1]
        return opacityAnimation
    }
    
    func setupAnimationGroup() {
        self.animationGroup.duration = animationDuration
        self.animationGroup.repeatCount = numberOfPulse
        let defaultCurve = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        self.animationGroup.timingFunction = defaultCurve
        self.animationGroup.animations = [scaleAnimation(),createOpacityAnimation()]
    }
    
    
}
