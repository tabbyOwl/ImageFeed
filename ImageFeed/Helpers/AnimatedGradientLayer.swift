//
//  AnimatedGradientLayer.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/17.
//

import UIKit

final class AnimatedGradientLayer: CAGradientLayer {
    
    init(colors: [UIColor],
         startPoint: CGPoint = CGPoint(x: 0, y: 0.5),
         endPoint: CGPoint = CGPoint(x: 1, y: 0.5)
    ) {
        super.init()
        self.colors = colors.map { $0.cgColor }
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func startAnimating(duration: CFTimeInterval = 1.0) {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0, 0.1, 0.3]
        animation.toValue = [0, 0.8, 1]
        animation.duration = duration
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        
        locations = [0, 0.8, 1]
        add(animation, forKey: "locationsChange")
    }
    
    func stopAnimating() {
        removeAnimation(forKey: "locationsChange")
    }
}
