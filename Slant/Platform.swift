//
//  Platform.swift
//  Slant
//
//  Created by Alex Rodriguez on 7/10/17.
//  Copyright © 2017 Alex Rodriguez. All rights reserved.
//

import Foundation
import SpriteKit

class Platform: SKNode {
    var visBody: SKNode
    var phyBody: SKPhysicsBody
    var calculatedYPos: CGFloat
    
    init(phyCat: UInt32, plyerCat: UInt32, point1: CGPoint, point2: CGPoint) {
        
        calculatedYPos = (point1.y + point2.y)/2
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: point1.x, y: point1.y))
        path.addLine(to: CGPoint(x: point2.x, y: point2.y))
        let line = SKShapeNode(path: path)
        
        line.strokeColor = SKColor(red: 130, green: 7, blue: 134, alpha: 1)
        line.lineWidth = 5

        self.visBody = SKNode()
        self.visBody.addChild(line);
        
        self.phyBody = SKPhysicsBody(edgeFrom: point1, to: point2)
        
        super.init()
        
        
        self.addChild(self.visBody)
        
        
        
        self.phyBody.affectedByGravity = false
        self.phyBody.categoryBitMask = phyCat
        self.phyBody.collisionBitMask = 1
        self.phyBody.contactTestBitMask = plyerCat
        
        self.physicsBody = self.phyBody
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
