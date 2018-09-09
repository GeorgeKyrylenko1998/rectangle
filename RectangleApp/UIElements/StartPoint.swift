//
//  StartPoint.swift
//  RectangleApp
//
//  Created by George Kyrylenko on 9/7/18.
//  Copyright © 2018 George Kyrylenko. All rights reserved.
//

import Foundation
import UIKit

class StartPoint: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        createPoint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createPoint()
    }
    
    func createPoint(){
        self.frame.size = CGSize(width: 10, height: 10)
        self.layer.cornerRadius = 5
        self.backgroundColor = .blue
    }
}
