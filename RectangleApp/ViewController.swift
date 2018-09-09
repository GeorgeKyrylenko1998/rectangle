//
//  ViewController.swift
//  RectangleApp
//
//  Created by George Kyrylenko on 9/7/18.
//  Copyright © 2018 George Kyrylenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var startPoint = StartPoint()
    var views = [EditableView]()
    var isRect = true
    var makeRect = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        tapForView(point: sender.location(in: self.view))
    }
    
    func createView(point: CGPoint){
        let viewColor = views.last!
        let width =  point.x - startPoint.center.x != 0 ? point.x - startPoint.center.x : 1
        let height = point.y - startPoint.center.y != 0 ? point.y - startPoint.center.y : 1
        
        viewColor.setSize(size: CGSize(width: width, height: height))
        
        viewColor.isHidden = false
        startPoint.removeFromSuperview()
    }
    
    func addStartPoint(point: CGPoint){
        startPoint.center = point
        self.view.addSubview(startPoint)
        let view = EditableView(frame: CGRect(origin: startPoint.center, size: CGSize(width: 100 , height: 100)))
        view.backgroundColor = UIColor(red: CGFloat.random(in: 0...1.0), green: CGFloat.random(in: 0...1.0), blue: CGFloat.random(in: 0...1.0), alpha: 1)
        views.append(view)
        view.isHidden = true
        view.delegate = self
        self.view.addSubview(view)
    }
    
    func tapForView(point: CGPoint){
        isRect = !isRect
        if isRect{
            createView(point: point)
            views.last!.sizeToFit()
        } else {
            addStartPoint(point: point)
        }
    }
    
    @IBAction func createViewDrag(_ sender: UIPanGestureRecognizer) {
        
        
      
        if sender.state == .began{
            for item in views{
                let loc = sender.location(in: item)
                if loc.x > 0 && loc.x < item.frame.width && loc.y > 0 && loc.y < item.frame.height{
                    makeRect = false
                    return
                }
            }
            addStartPoint(point: sender.location(in: view))
        } else if sender.state == .changed {
            if makeRect{
            createView(point: sender.location(in: view))
            }
        } else if sender.state == .ended{
            makeRect = true
            isRect = true
            views.last!.sizeToFit()
        }
    }
}

extension ViewController: EditableViewDelegate{
    func removeView(view: EditableView) {
        self.views.remove(at: views.firstIndex(of: view)!)
    }
}
