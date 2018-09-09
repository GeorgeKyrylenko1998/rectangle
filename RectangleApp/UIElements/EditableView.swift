//
//  EditableView.swift
//  RectangleApp
//
//  Created by George Kyrylenko on 9/8/18.
//  Copyright © 2018 George Kyrylenko. All rights reserved.
//

import Foundation
import UIKit

class EditableView: UIView{
    
    var isResize = false
    
    var delegate: EditableViewDelegate?
    
    var startPoin: CGPoint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        startPoin = frame.origin
        createView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createView()
    }
    
    func createView(){
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        self.addGestureRecognizer(longTap)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapped(sender:)))
        self.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
        
        let tripleTap = UITapGestureRecognizer(target: self, action: #selector(tripleTapped))
        tripleTap.numberOfTouchesRequired = 2
        self.addGestureRecognizer(tripleTap)
        
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotateEvent(sender: )))
        rotateGesture.delegate = self
        self.addGestureRecognizer(rotateGesture)
        
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(dragEvent(sender: )))
        dragGesture.delegate = self
        self.addGestureRecognizer(dragGesture)
        
        let sizeGesture = UIPinchGestureRecognizer(target: self, action: #selector(sizeEvent(sender: )))
        
        self.addGestureRecognizer(sizeGesture)
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer)
    {
        if sender.state == .began{
            self.backgroundColor = UIColor(red: CGFloat.random(in: 0...1.0), green: CGFloat.random(in: 0...1.0), blue: CGFloat.random(in: 0...1.0), alpha: 1)
        }
    }
    
    @objc func doubleTapped() {
        self.removeFromSuperview()
        delegate?.removeView(view: self)
    }
    
    @objc func tripleTapped() {
        isResize = !isResize
    }
    
    @objc func singleTapped(sender: UITapGestureRecognizer) {
        self.superview?.bringSubviewToFront(self)
    }
    
    @objc func rotateEvent(sender: UIRotationGestureRecognizer)
    {
        if let view = sender.view {
            view.transform = view.transform.rotated(by: sender.rotation)
            sender.rotation = 0
        }
    }
    
    @objc func dragEvent(sender: UIPanGestureRecognizer)
    {
        if !isResize{
            self.center.x = self.center.x + sender.translation(in: self.superview).x
            self.center.y = self.center.y + sender.translation(in: self.superview).y
            
        } else {
            self.bounds.size.height += sender.translation(in: self.superview).y
            self.bounds.size.width += sender.translation(in: self.superview).x
        }
        sender.setTranslation(CGPoint.zero, in: self.superview)
    }
    
    @objc func sizeEvent(sender: UIPinchGestureRecognizer)
    {
        print(sender.velocity)
        if let view = sender.view {
            view.transform = view.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1
        }
    }
    
    func setSize(size: CGSize){
        
        let wZ = size.width / abs(size.width)
        let hZ = size.height / abs(size.height)
        
        if wZ < 0{
            self.frame.origin.x = startPoin!.x + size.width
        }
        
        if hZ < 0{
            self.frame.origin.y = startPoin!.y + size.height
        }
        
        self.frame.size = CGSize(width: abs(size.width) , height: abs(size.height) )
    }
    
    override func sizeToFit() {
        if abs(self.frame.size.height) < 100{
            let z = abs(self.frame.size.height)/self.frame.size.height
            self.frame.size.height = 100 * z
        }
        
        if abs(self.frame.size.width) < 100{
            let z = abs(self.frame.size.width)/self.frame.size.width
            self.frame.size.width = 100 * z
        }
    }
}

extension EditableView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


protocol EditableViewDelegate{
    func removeView(view: EditableView)
}
