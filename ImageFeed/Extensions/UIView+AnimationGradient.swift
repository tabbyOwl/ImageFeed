//
//  UIView+AnimationGradient.swift
//  ImageFeed
//
//  Created by Svetlana on 2025/12/17.
//

import UIKit
import CoreData

extension UIView {
    
    private static let gradientLayerName = "AnimatedGradientLayer"
    
    private static let defaultColors: [UIColor] = [
        UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1),
        UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1),
        UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1)
    ]
    
    func addAnimatedGradient(colors: [UIColor] = UIView.defaultColors, duration: CFTimeInterval = 1.0) {
        removeAnimatedGradient()
        
        let gradient = AnimatedGradientLayer(colors: colors)
        gradient.frame = bounds
        gradient.cornerRadius = self.layer.cornerRadius
        gradient.masksToBounds = true
        gradient.name = Self.gradientLayerName
        
        
        layer.insertSublayer(gradient, at: 0)
        gradient.startAnimating(duration: duration)
    }
    
    func removeAnimatedGradient() {
        layer.sublayers?
            .filter { $0.name == Self.gradientLayerName }
            .forEach { $0.removeFromSuperlayer() }
    }
    
    func updateAnimatedGradientFrame() {
        layer.sublayers?
            .first { $0.name == Self.gradientLayerName }?
            .frame = bounds
    }
}
