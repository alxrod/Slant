//
//  PlatformIndicator.swift
//  Slant
//
//  Created by Alex Rodriguez on 7/11/17.
//  Copyright © 2017 Alex Rodriguez. All rights reserved.
//

import Foundation
import SpriteKit

class PlatformIndicator: SKNode {
    var visBody: SKNode
    var completePlatformMade = false
    var storedP1 = CGPoint(x: 0, y: 0)
    var storedP2 = CGPoint(x: 0, y: 0)
    
    init(point1: CGPoint, point2: CGPoint) {
        
        storedP1 = point1
        storedP2 = point2
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: point1.x, y: point1.y))
        path.addLine(to: CGPoint(x: point2.x, y: point2.y))

        let pattern : [CGFloat] = [10.0, 10.0]
        let dashed = path.copy(dashingWithPhase: CGFloat(5), lengths: pattern)
        
        let line = SKShapeNode(path: dashed)
        line.strokeColor = SKColor(red: 64, green: 8, blue: 50, alpha: 1)
        line.lineWidth = 3
        
        self.visBody = SKNode()
        self.visBody.addChild(line);
        
        super.init()
        
        
        self.addChild(self.visBody)
        
    }

    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(point1: CGPoint, point2: CGPoint) {
        
        let path = CGMutablePath()
        
        let distance = ( pow( point2.x-point1.x, 2 ) + pow( point2.y-point1.y, 2) ).squareRoot()
       
        if distance < 120 {
            
            self.removeAllChildren()
            storedP1 = point1
            storedP2 = point2
            
            path.move(to: CGPoint(x: point1.x, y: point1.y))
            path.addLine(to: CGPoint(x: point2.x, y: point2.y))
            
            let pattern : [CGFloat] = [10.0, 10.0]
            let dashed = path.copy(dashingWithPhase: CGFloat(10), lengths: pattern)
            
            let line = SKShapeNode(path: dashed)
            line.strokeColor = SKColor(red: 64, green: 8, blue: 50, alpha: 1)
            line.lineWidth = 3
            
            self.visBody = SKNode()
            self.visBody.addChild(line);
            
            self.addChild(self.visBody)
        } else {
            let yChange = point2.y-point1.y
            let xChange = point2.x-point1.x
            let hypotenuse = ( pow(yChange, 2) + pow(xChange, 2) ).squareRoot()
            let ratio = 120/hypotenuse
            let yAdjustment = ratio * yChange
            let xAdjustment = ratio * xChange
            let point2Adj = CGPoint(x: point1.x + xAdjustment, y: point1.y + yAdjustment)
            storedP1 = point1
            storedP2 = point2Adj
            
            self.removeAllChildren()
            
            path.move(to: CGPoint(x: point1.x, y: point1.y))
            path.addLine(to: CGPoint(x: point2Adj.x, y: point2Adj.y))
            
            let pattern : [CGFloat] = [10.0, 10.0]
            let dashed = path.copy(dashingWithPhase: CGFloat(10), lengths: pattern)
            
            let line = SKShapeNode(path: dashed)
            line.strokeColor = SKColor(red: 64, green: 8, blue: 50, alpha: 1)
            line.lineWidth = 3
            
            self.visBody = SKNode()
            self.visBody.addChild(line);
            
            self.addChild(self.visBody)
            
            
        }
        
        
        
        if distance > 110 {
            completePlatformMade = true
        } else {
            completePlatformMade = false
        }
    }
    
    
}
