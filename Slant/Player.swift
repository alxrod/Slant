//
//  Player.swift
//  Slant
//
//  Created by Alex Rodriguez on 7/10/17.
//  Copyright © 2017 Alex Rodriguez. All rights reserved.
//

import Foundation
import SpriteKit

class Player: SKNode {
    var visBody: SKNode
    var phyBody: SKPhysicsBody
    
    init(phyCat: UInt32) {
        
        let playerSize = CGFloat(20)

        self.visBody = SKNode()
        self.phyBody = SKPhysicsBody(circleOfRadius: playerSize)
        
        super.init()
        
        let main = SKShapeNode(circleOfRadius: playerSize)
        main.fillColor = SKColor(red: 9, green: 11, blue: 218, alpha: 1)
        main.strokeColor = SKColor(red: 29, green: 31, blue: 238, alpha: 1)
        main.lineWidth = 3
        
        self.visBody.addChild(main);
        
        self.addChild(self.visBody)
        
        self.phyBody.mass = 10
        self.phyBody.categoryBitMask = phyCat
        self.phyBody.collisionBitMask = 5 | 6
        self.physicsBody = self.phyBody
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
