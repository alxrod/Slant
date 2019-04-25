 //
//  Coin.swift
//  Slant
//
//  Created by Alex Rodriguez on 7/11/17.
//  Copyright © 2017 Alex Rodriguez. All rights reserved.
//

import Foundation
import SpriteKit

class Coin: SKNode {
    var visBody: SKNode
    var phyBody: SKPhysicsBody
    
    init(phyCat: UInt32, plyerCat: UInt32) {
        
        let coinSize = CGFloat(10)
        
        self.visBody = SKNode()
        self.phyBody = SKPhysicsBody(circleOfRadius: coinSize)
        
        super.init()
        
        let main = SKShapeNode(circleOfRadius: coinSize)
        main.fillColor = UIColor(hex: 0xFBDB03)
        main.strokeColor = UIColor(hex: 0xFFBC24)
        main.lineWidth = 3
        
        self.visBody.addChild(main);
        
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
    
    func randomLocAssign(xMin: CGFloat, xMax: CGFloat, yMin: CGFloat, yMax: CGFloat, otherCoins: [Coin]) {
        
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
        
        for coin in otherCoins {
            if coin != self {
                if coin.position.x > self.position.x - (unitSize) && coin.position.x < self.position.x + (unitSize) {
                    if coin.position.y > self.position.y - (unitSize) && coin.position.y < self.position.y + (unitSize) {
                        randomLocAssign(xMin: xMin, xMax: xMax, yMin: yMin, yMax: yMax, otherCoins: otherCoins)
                    }
                }
            }
        }
    }
    
}
