//
//  TinkoffLogosService.swift
//  FintechChat
//
//  Created by Ирина Улитина on 20/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

protocol ITinkoffLogosService {
    func setup(view: UIView, time: TimeInterval)
    
    func dispose()
}

class TinkoffLogosService: NSObject, ITinkoffLogosService, UIGestureRecognizerDelegate {
    
    private var timer: Timer?
    
    private var view: UIView!
    
    private var minimumLogoSize: CGFloat = 20
    
    private var logoSizeDispersion: CGFloat = 20
    
    private var minimumPathHeight: CGFloat = 20
    
    private var pathHeightDisperstion: CGFloat = 200
    
    private var defaultMovement: CGFloat = -150
    
    private var movementDispersion: CGFloat = 300
    
    private var scale: CGFloat = 1.15
    
    private var defaultDuration: CGFloat = 2
    
    private var durationDispersion: CGFloat = 1
    
    private var forbiddenView: UIView?
    
    init(forbiddenView: UIView) {
        self.forbiddenView = forbiddenView
        super.init()
    }
    
    override init() {
        super.init()
    }
    
    private var longPressGestureRecognizer: UILongPressGestureRecognizer!
    
    func setup(view: UIView, time: TimeInterval) {
        self.view = view
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: nil)
        self.longPressGestureRecognizer = gestureRecognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(gesture:)))
        gestureRecognizer.minimumPressDuration = 0.2
        gestureRecognizer.cancelsTouchesInView = true
        gestureRecognizer.delegate = self
        tapGesture.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
        view.addGestureRecognizer(tapGesture)
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { (_) in
            //print(gestureRecognizer.state.debug())
            
            if gestureRecognizer.state != .ended && gestureRecognizer.state != .possible {
                self.showTinkoffLogos(gesture: gestureRecognizer)
            }
        })
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer is UILongPressGestureRecognizer {
            return true
        } else {
        //self.showTinkoffLogos(gesture: gestureRecognizer)
            
            guard let forbiddenView = self.forbiddenView else { return true }
            let res = !((touch.view?.isDescendant(of: forbiddenView) ?? false) || touch.view is UIButton)
            if !res {
               self.showTinkoffLogos(gesture: gestureRecognizer, touchLocation: touch.location(in: self.view))
            }
            return res
        }
    }
    
    private func generate(baseValue: CGFloat, dispersion: CGFloat) -> CGFloat {
        return (CGFloat(Int(arc4random()) - Int(UINT32_MAX / 2)) / CGFloat(UINT32_MAX)) * dispersion + baseValue
    }
    
    @objc private func onTap(gesture: UIGestureRecognizer) {
        self.showTinkoffLogos(gesture: gesture)
    }
    
    func showTinkoffLogos(gesture: UIGestureRecognizer, touchLocation: CGPoint? = nil) {
        //print("LOGOGO \(self.counter)")
        let location = touchLocation ?? gesture.location(in: self.view)
        let imageView = UIImageView(image: #imageLiteral(resourceName: "tinkoffGerb"))
        
        let size: CGFloat = self.generate(baseValue: self.minimumLogoSize, dispersion: self.logoSizeDispersion)
        
        let height: CGFloat = self.generate(baseValue: self.minimumPathHeight, dispersion: self.pathHeightDisperstion)
        
        imageView.frame = CGRect(origin: location, size: CGSize(width: size, height: size))
        let finalPoint = CGPoint(x: location.x, y: location.y - height)
        
        let move: CGFloat = self.generate(baseValue: self.defaultMovement, dispersion: self.movementDispersion)
        
        let controlPoint1 = CGPoint(x: location.x - move, y: (location.y + finalPoint.y) / 2)
        let controlPoint2 = CGPoint(x: location.x + move, y: controlPoint1.y)
        self.view.addSubview(imageView)
        let path = UIBezierPath()
        path.move(to: location)
        path.addCurve(to: finalPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        
        let duration: CGFloat = 2
        
        CATransaction.begin()
        
        CATransaction.setCompletionBlock {
            UIView.transition(with: imageView, duration: 0.1, options: .transitionCrossDissolve, animations: {
                imageView.transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
            }, completion: { (_) in
                imageView.removeFromSuperview()
            })
        }
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.duration = CFTimeInterval(duration)
        animation.path = path.cgPath
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        imageView.layer.add(animation, forKey: "movingAnimation")
        
        CATransaction.commit()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func dispose() {
        self.timer?.invalidate()
    }
    
    
}
