//
//  GameScene.swift
//  Slant
//
//  Created by Alex Rodriguez on 7/10/17.
//  Copyright © 2017 Alex Rodriguez. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    struct PhysicsCategory {
        static let BlackHole: UInt32 = 1
        static let Coin: UInt32 = 0
        static let Player : UInt32 = 2
        static let Platform: UInt32 = 5
        static let Edge: UInt32 = 6
        
    }
    
    let player = Player(phyCat: PhysicsCategory.Player)
    let platformIndicator = PlatformIndicator(point1: CGPoint(x: 0, y: 0), point2: CGPoint(x: 0, y: 0))
    let cameraNode = SKCameraNode()
    let leftWall = SKNode()
    let rightWall = SKNode()
    let coinCountLabel = SKLabelNode()
    var coinCount = 10
    
    
    
    var platforms = [Platform]()
    var coins = [Coin]()
    var blackholes = [BlackHole]()
    
    var touchBegin = CGPoint()
    var touchPlatEnd = CGPoint()
    
//  Debugging tool:
//    let coordTester = SKShapeNode(circleOfRadius: 10)
//  End of Debug Tool
    
    override func didMove(to view: SKView) {
        
//      Debugging tool:
//        coordTester.position = CGPoint(x: 0, y: size.height)
//        coordTester.fillColor = .red
//        addChild(coordTester)
//      End of Debug tool

        
        self.backgroundColor = .white
        
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: size.width/2, y: size.height/2)
        
        player.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(player)
        
        addChild(platformIndicator)
        
//        Implement walls
        leftWall.position = CGPoint(x: 0, y: player.position.y);
        let leftWallBody = SKPhysicsBody(rectangleOf: CGSize(width:1, height: 40
        ))
        leftWallBody.isDynamic = false
        leftWallBody.categoryBitMask = PhysicsCategory.Edge
        leftWall.physicsBody = leftWallBody
        addChild(leftWall)
        
        
        rightWall.position = CGPoint(x: size.width, y: player.position.y);
        let rightWallBody = SKPhysicsBody(rectangleOf: CGSize(width:1, height: 40
        ))
        rightWallBody.isDynamic = false
        rightWallBody.categoryBitMask = PhysicsCategory.Edge
        rightWall.physicsBody = rightWallBody
        addChild(rightWall)
        
        coinCountLabel.position = CGPoint(x: -size.width/2+35, y: size.height/2-40)
        coinCountLabel.fontColor = UIColor(hex: 0xFBDB03)
        coinCountLabel.fontSize = 32
        coinCountLabel.text = String(coinCount)
        cameraNode.addChild(coinCountLabel)
        
        generateCoins()
        generateBlackholes()
        
        
        physicsWorld.gravity.dy = -3
        physicsWorld.contactDelegate = self
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        touchBegin = location
        platformIndicator.update(point1: location, point2: location)
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        platformIndicator.update(point1: touchBegin, point2: location)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (platformIndicator.completePlatformMade == true && coinCount > 0) {
            let newPlat = Platform(phyCat: PhysicsCategory.Platform, plyerCat: PhysicsCategory.Player, point1: CGPoint(x: platformIndicator.storedP1.x, y: platformIndicator.storedP1.y), point2: CGPoint(x: platformIndicator.storedP2.x, y: platformIndicator.storedP2.y))
            addChild(newPlat)
            platforms.append(newPlat)
            
            coinCount -= 1
            coinCountLabel.text = String(coinCount)
            
            touchPlatEnd = CGPoint(x: 0, y: 0)
        }
        
        platformIndicator.update(point1: CGPoint(x: 0, y: 0), point2: CGPoint(x: 0, y: 0))
    }
    
    override func update(_ currentTime: TimeInterval) {
        let ceiling = cameraNode.convert(CGPoint(x: 0, y: size.height/2), to: self)
        
        if player.physicsBody!.velocity.dy < CGFloat(-500) {
            player.phyBody.velocity.dy = -500
        }
        
        var velAdjustment = CGPoint(x: 0, y: 0)
        for blackhole in blackholes {
            
            //This line sets the blackhole magnitude to be equal to 7.69% of the player's downward velocity.
            blackhole.magnitude = abs( player.phyBody.velocity.dy / 13)
            let exAdjustment = blackhole.pullInPlayer(playerPos: player.position)
            velAdjustment.x += exAdjustment.x
            velAdjustment.y += exAdjustment.y
            
            if blackhole.position.y > ceiling.y {
                refreshBlackHole(blackhole: blackhole)
            }
        }
        
        player.physicsBody!.velocity.dx += velAdjustment.x
        player.physicsBody!.velocity.dy += velAdjustment.y
        
        
        cameraNode.position.y = player.position.y - size.height/4
        
        leftWall.position.y = player.position.y
        rightWall.position.y = player.position.y
    
        
//      Dealing wiht removing any platforms that are now off the screen to decrease lag:
        for platform in platforms {
            if platform.calculatedYPos > ceiling.y {
                platform.removeFromParent()
                platforms.remove(at: platforms.index(of: platform)!)
           }
        }
        
//      Dealing with removing any coins that are now off the screen to decrease lag and make new ones:
        for coin in coins {
            if coin.position.y > ceiling.y {
                refreshCoin(coin: coin)
            }
        }

    }
    
    func generateCoins() {
        for _ in stride(from: 0, to: 3, by: +1) {
           generateCoin()
        }
    }
    
    func generateCoin() {
        let newCoin = Coin(phyCat: PhysicsCategory.Coin, plyerCat: PhysicsCategory.Player)
        coins.append(newCoin)
        addChild(newCoin)
        newCoin.randomLocAssign(xMin: 20, xMax: size.width, yMin: player.position.y - size.height*3/4-20, yMax: player.position.y - size.height*7/4-20, otherCoins: coins)
    }
    
    func generateBlackholes() {
        for _ in stride(from: 0, to: 2, by: +1) {
            generateBlackhole()
        }
    }
    
    func generateBlackhole() {
        let newHole = BlackHole(phyCat: PhysicsCategory.Coin, plyerCat: PhysicsCategory.Player)
        blackholes.append(newHole)
        addChild(newHole)
        newHole.randomLocAssign(xMin: 20, xMax: size.width, yMin: player.position.y - size.height*3/4-20, yMax: player.position.y - size.height*7/4-20, otherBlackHoles: blackholes)
    }
    
    func refreshBlackHole(blackhole: BlackHole) {
        blackhole.removeFromParent()
        blackholes.remove(at: blackholes.index(of: blackhole)!)
        generateBlackhole()
    }
    
    func refreshCoin(coin: Coin) {
        coin.removeFromParent()
        coins.remove(at: coins.index(of: coin)!)
        generateCoin()
    }
    
    func dieAndRestart() {
        die()
        restart()
    }
    
    func die() {
        player.physicsBody?.velocity.dy = 0
        player.physicsBody?.velocity.dx = 0
        coinCount = Int(10)
        coinCountLabel.text = String(coinCount)
        player.removeFromParent()
        
        for blackHole in blackholes {
            blackHole.removeFromParent()
        }
        blackholes.removeAll()
        
        for coin in coins {
            coin.removeFromParent()
        }
        coins.removeAll()
        
        for platform in platforms {
            platform.removeFromParent()
        }
        platforms.removeAll()
    }
    
    func restart() {
        cameraNode.position = CGPoint(x: size.width/2, y: size.height/2)
        
        player.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(player)
        generateCoins()
        generateBlackholes()
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if let _ = contact.bodyA.node as? Player, let nodeB = contact.bodyB.node as? Coin {
            print("Hit coin")
            coinCount += 1
            coinCountLabel.text = String(coinCount)
            refreshCoin(coin: nodeB)

        }
        
        if let _ = contact.bodyA.node as? Player, let _ = contact.bodyB.node as? BlackHole {
            print("Hit hole")
           dieAndRestart()
        }
        

    }
}
