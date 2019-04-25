//
//  BlackHole.swift
//  Slant
//
//  Created by Alex Rodriguez on 7/12/17.
//  Copyright © 2017 Alex Rodriguez. All rights reserved.
//

import Foundation
import SpriteKit

class BlackHole: SKNode {
    var visBody: SKNode
    var phyBody: SKPhysicsBody
    var magnitude = CGFloat(15)
    
    init(phyCat: UInt32, plyerCat: UInt32) {
        
        
        
        let holeSize = CGFloat(15)
        
        self.visBody = SKNode()
        self.phyBody = SKPhysicsBody(circleOfRadius: holeSize)
        
        super.init()
        
        let main = SKShapeNode(circleOfRadius: holeSize)
        main.fillColor = UIColor(hex: 0x0096EC)
        main.strokeColor = UIColor(hex: 0x07639C)
        main.lineWidth = 3
        self.visBody.addChild(main);
        
        let secondary = SKShapeNode(circleOfRadius: holeSize-6)
        secondary.fillColor = UIColor(hex: 0x0FC5EA)
        secondary.strokeColor = secondary.fillColor

        
        
        let actionUpSize = SKAction.scale(to: 1.2, duration: TimeInterval(0.4))
        let actionDownSize = SKAction.scale(to: 0.9, duration: TimeInterval(0.4))
        let animationSequence = SKAction.sequence([actionUpSize, actionDownSize])
        secondary.run(SKAction.repeatForever(animationSequence))
        
        visBody.addChild(secondary);
        
        let center = SKShapeNode(circleOfRadius: holeSize-10)
        center.fillColor = UIColor(hex: 0x1878C3)
        center.strokeColor = center.fillColor
        self.visBody.addChild(center);
        center.run(SKAction.repeatForever(animationSequence))
        
        self.addChild(self.visBody)
        
        
        self.phyBody.categoryBitMask = phyCat
        self.phyBody.collisionBitMask = 0
        self.phyBody.contactTestBitMask = plyerCat
        self.phyBody.affectedByGravity = false
        self.physicsBody = self.phyBody
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func pullInPlayer(playerPos: CGPoint)  -> CGPoint{
        let distance = ( pow( playerPos.x-self.position.x, 2 ) + pow( playerPos.y-self.position.y, 2) ).squareRoot()
        
        
        if (distance < 150 && playerPos.y > self.position.y) {
            let xChange = self.position.x-playerPos.x
            let yChange = self.position.y-playerPos.y
            let m = yChange/xChange
            
            var xVel = self.magnitude
            if playerPos.x > self.position.x {
                xVel = xVel * -1
            }
            let yVel = xVel*m
 
            //      Remember its not actually a point, its a convenient way of returnign the velocity adjustments.
            return CGPoint(x: xVel, y: yVel)
        }
        else {
            return CGPoint(x: 0, y: 0)
        }
       
        
    }
    
    func randomLocAssign(xMin: CGFloat, xMax: CGFloat, yMin: CGFloat, yMax: CGFloat, otherBlackHoles: [BlackHole]) {
        
        let unitSize = CGFloat(40)
        var randGrid = [[CGPoint]]()
        let colNum = abs(((xMax-xMin) / unitSize).rounded())
        let rowNum = abs(((yMax-yMin) / unitSize).rounded())
        
        for i in stride(from: 0, to: colNum, by: +1) {
            var column = [CGPoint]()
            for e in stride(from: 0, to: rowNum, by: +1) {
                let point = CGPoint(x: xMin + i*unitSize, y: yMin - e*unitSize)
                column.append(point)
            }
            randGrid.append(column)
        }
        
        let xIndex = Int(arc4random_uniform(UInt32(colNum)))
        let yIndex = Int(arc4random_uniform(UInt32(rowNum)))
        self.position = randGrid[xIndex][yIndex]
        
        for blackHole in otherBlackHoles {
            if blackHole != self {
                if blackHole.position.x > self.position.x - (unitSize*2) && blackHole.position.x < self.position.x + (unitSize*2) {
                    if blackHole.position.y > self.position.y - (unitSize*2) && blackHole.position.y < self.position.y + (unitSize*2) {
                        randomLocAssign(xMin: xMin, xMax: xMax, yMin: yMin, yMax: yMax, otherBlackHoles: otherBlackHoles)
                    }
                }
            }
        }
    }
    
    
    
    
}
