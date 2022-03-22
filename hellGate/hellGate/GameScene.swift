//
//  GameScene.swift
//  hellsgatetest
//
//  Created by Daniel Kim on 24/11/2021.
//

import SpriteKit
import CoreLocation
import GameplayKit



struct physicsCategories{
    static let none: UInt32 = 0
    static let player: UInt32 = 0b1
    static let fire: UInt32 = 0b10
    static let rock: UInt32 = 0b101
    static let sticky: UInt32 = 0b100
    static let boundary: UInt32 = 0b1000
}


var check = 2

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var finalPlayer = SKSpriteNode()
    var nodePosition = CGPoint()
    var startTouch = CGPoint()
    var skinChecker = "skinOne"
    
    let heavenBackground = SKSpriteNode()
    let screen = SKShapeNode(rectOf: CGSize(width: 800, height: 14800))
    
    var initialPosition = CGPoint()
    var endingPosition = CGPoint()
    var stickyChecker = false
    
    let loseScreen = SKSpriteNode()
        
    let cameraNode = SKCameraNode()
    let fire = SKNode()
    let rock = SKNode()
    let sticky = SKNode()
    let titleScreen = SKSpriteNode()
    let background1 = SKSpriteNode()
    let background2 = SKSpriteNode()
    let background3 = SKSpriteNode()
    var vector = CGVector()
    
    //buttons
    var section = true
    let titleLabel = SKLabelNode()
    let titleButton = SKSpriteNode()
    let mode1 = SKSpriteNode()
    let mode2 = SKSpriteNode()
    let mode3 = SKSpriteNode()
    let modeButtons = SKNode()
    let restartButton = SKSpriteNode()
                    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        createTitleScreen()
        addBackground()
        
        self.addChild(restartButton)
        self.addChild(restartLabel)
//        self.addChild(titleButton)
//        self.addChild(titleLabel)
        
        //adding stuff
        addPlayer()
        addBorder()
        
        let xArray = [-350, -300, -250, -200, -150, -100, -50, 0, 50, 100, 150, 200, 250, 300, 350]
        let yArray = [350, 380, 400, 450, 500, 550, 600, 650, 700]

        var rockY = -450
        self.addChild(rock)
        for _ in 1 ... 28{
            let randomPos = Int.random(in: 0..<15)
            let yAdd = Int.random(in: 0..<9)
            rockY += yArray[yAdd]
            createRock(position: CGPoint(x: xArray[randomPos], y: rockY), size: 20)
        }
        rockY = -300
        for _ in 1 ... 14{
            let randomPos = Int.random(in: 0..<15)
            let yAdd = Int.random(in: 0..<9)
            rockY += yArray[yAdd]*2
            createRock(position: CGPoint(x: xArray[randomPos], y: rockY), size: 20)
        }

        var fireY = -300
        self.addChild(fire)
        for _ in 1 ... 23{
            let randomPos = Int.random(in: 0..<15)
            let yAdd = Int.random(in: 0..<9)
            fireY += yArray[yAdd]
            createFire(position: CGPoint(x: xArray[randomPos], y: fireY), size: 20)
        }

        var stickY = -400
        self.addChild(sticky)
        for _ in 1 ... 13{
            let randomPos = Int.random(in: 0..<15)
            let yAdd = Int.random(in: 0..<9)
            stickY += yArray[yAdd]*2
            createSticky(position: CGPoint(x: xArray[randomPos], y: stickY), size: 20)
        }
        stickY = -450
        for _ in 1 ... 26{
            let randomPos = Int.random(in: 0..<15)
            let yAdd = Int.random(in: 0..<9)
            stickY += yArray[yAdd]
            createSticky(position: CGPoint(x: xArray[randomPos], y: stickY), size: 20)
        }
    
        loseScreen.size = self.size
        loseScreen.texture = SKTexture(imageNamed: "hell")
        loseScreen.isHidden = true
        loseScreen.zPosition = 100
        self.addChild(loseScreen)
        
        //camera
        self.addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = finalPlayer.position
        
        physicsWorld.gravity.dy = -22
    }
    
    
    func addBackground(){
        background1.size = CGSize(width: 750, height: 2704*10)
        background1.position = CGPoint(x: 0, y: 2660)
        background1.texture = SKTexture(imageNamed: "background1")
        
        background2.position = CGPoint(x: 0, y: 2660+2704*3)
        background2.size = CGSize(width: 750, height: 2671*4)
        background2.texture = SKTexture(imageNamed: "background2")
        
        background3.position = CGPoint(x: 0, y: 2660+2704*3+900)
        background3.size = CGSize(width: 750, height: 1536*4)
        background3.texture = SKTexture(imageNamed: "background3")
        
        heavenBackground.zPosition = -1
        heavenBackground.size = self.size
        heavenBackground.texture = SKTexture(imageNamed: "heaven")
        
        self.addChild(background1)
        self.addChild(background2)
        self.addChild(background3)
        self.addChild(heavenBackground)
    }
    
                
        func createTitleScreen(){
            titleScreen.zPosition = 100
            titleScreen.size.width = self.size.width
            titleScreen.size.height = self.size.height
            titleScreen.position.y = CGPoint.zero.y - 50
            titleScreen.texture = SKTexture(imageNamed: "title")
            self.addChild(titleScreen)
            self.view?.isPaused = true

            mode1.size = CGSize(width: 220, height: 150)
            mode2.size = CGSize(width: 220, height: 150)
            mode3.size = CGSize(width: 220, height: 150)
            
            mode1.color = .blue
            mode2.color = .blue
            mode3.color = .blue
            
            mode1.zPosition = 101
            mode2.zPosition = 101
            mode3.zPosition = 101
            
            mode1.name = "mode1"
            mode2.name = "mode2"
            mode3.name = "mode3"
            
            mode1.texture = SKTexture(imageNamed: "mode1")
            mode2.texture = SKTexture(imageNamed: "mode2")
            mode3.texture = SKTexture(imageNamed: "mode3")

            mode1.position = CGPoint(x: -250, y: -500)
            mode2.position = CGPoint(x: 0, y: -500)
            mode3.position = CGPoint(x: 250, y: -500)
            
            modeButtons.addChild(mode1)
            modeButtons.addChild(mode2)
            modeButtons.addChild(mode3)
            self.addChild(modeButtons)
        }
    
    
    
    let rightwall = SKNode()
    let leftwall = SKNode()
    
    func addBorder(){
        
        let ground = SKNode()
        ground.position = CGPoint(x: 0, y: -565)
        let groundBody = SKPhysicsBody(rectangleOf: CGSize(width: 750, height: 10))
        groundBody.isDynamic = false
        groundBody.categoryBitMask = physicsCategories.boundary
        ground.physicsBody = groundBody
        self.addChild(ground)
        
        leftwall.position = CGPoint(x: -375, y: 0)
        let leftwallBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 1300))
        leftwallBody.isDynamic = false
        leftwallBody.categoryBitMask = physicsCategories.boundary
        leftwall.physicsBody = leftwallBody
        self.addChild(leftwall)
        
        rightwall.position = CGPoint(x: 375, y: 0)
        let rightwallBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 1300))
        rightwallBody.isDynamic = false
        rightwallBody.categoryBitMask = physicsCategories.boundary
        rightwall.physicsBody = rightwallBody
        self.addChild(rightwall)
        
    }
        
        
        
        func createRock(position: CGPoint, size: Int){
            let path = UIBezierPath()
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 5))
            path.addLine(to: CGPoint(x: 4, y: 5))
            path.addLine(to: CGPoint(x: 6, y: 4))
            path.addLine(to: CGPoint(x: 7, y: 3))
            path.addLine(to: CGPoint(x: 6, y: -1))
            path.addLine(to: CGPoint(x: 3, y: -3))
            path.addLine(to: CGPoint(x: 2, y: -3))
            path.addLine(to: CGPoint(x: -2, y: -4))
            path.addLine(to: CGPoint(x: -3, y: -1))
            path.addLine(to: CGPoint(x: -4, y: 1))
            path.addLine(to: CGPoint(x: -3, y: 3))
            path.addLine(to: CGPoint(x: 0, y: 5))
                                    
            path.apply(CGAffineTransform(scaleX: CGFloat(size), y: CGFloat(size)))
            
            let rockPath = SKShapeNode(path: path.cgPath)
            rockPath.fillColor = .gray
            rockPath.strokeColor = .clear
//            rockPath.setScale(CGFloat(size))
            rockPath.position = position
            
                let sectionBody = SKPhysicsBody(polygonFrom: path.cgPath)
            sectionBody.categoryBitMask = physicsCategories.rock
            
            //sectionBody.contactTestBitMask = physicsCategories.player
            sectionBody.affectedByGravity = false
            sectionBody.isDynamic = false
            rockPath.physicsBody = sectionBody
            rock.zPosition = 5
            
            rock.addChild(rockPath)
            
        }
    
    let restartLabel = SKLabelNode()
    
    func createRestartButton(){
        restartLabel.text = "restart"
        restartLabel.fontColor = .red
        restartLabel.fontName = "c"
        restartLabel.fontSize = 80
        restartLabel.zPosition = 104
        
        restartButton.name = "restartButton"
        restartButton.color = .white
        restartButton.zPosition = 103
        restartButton.texture = SKTexture(imageNamed: "button")
        restartButton.size = CGSize(width: 300, height: 105)
        
    }
    
//    func createTitleButton(){
//        titleLabel.text = "title"
//        titleLabel.fontColor = .red
//        titleLabel.fontName = "c"
//        titleLabel.fontSize = 80
//        titleLabel.zPosition = 104
//
//        titleButton.name = "title"
//        titleButton.color = .white
//        titleButton.zPosition = 103
//        titleButton.texture = SKTexture(imageNamed: "button")
//        titleButton.size = CGSize(width: 300, height: 105)
//
//    }
    
    func restartScene(){
        self.removeAllActions()
        self.removeAllChildren()
        self.scene?.removeFromParent()
        self.isPaused = true
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
        
    func createSticky(position: CGPoint, size: Int){
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 2, y: 5))
        path.addLine(to: CGPoint(x: 6, y: 5))
        path.addLine(to: CGPoint(x: 9, y: 4))
        path.addLine(to: CGPoint(x: 8, y: -1))
        path.addLine(to: CGPoint(x: 5, y: -3))
        path.addLine(to: CGPoint(x: -3, y: -3))
        path.addLine(to: CGPoint(x: -4, y: -2))
        path.addLine(to: CGPoint(x: -4, y: 0))
        path.addLine(to: CGPoint(x: -5, y: 2))
        path.addLine(to: CGPoint(x: 2, y: 5))
                                
        path.apply(CGAffineTransform(scaleX: CGFloat(size), y: CGFloat(size)))
        
        let stickyPath = SKShapeNode(path: path.cgPath)
        stickyPath.fillColor = .green
        stickyPath.strokeColor = .clear
        stickyPath.position = position
        
            let sectionBody = SKPhysicsBody(polygonFrom: path.cgPath)
        sectionBody.categoryBitMask = physicsCategories.sticky
        sectionBody.contactTestBitMask = physicsCategories.player // can only have one contacttestbitmask per node
        sectionBody.usesPreciseCollisionDetection = true
        sectionBody.affectedByGravity = false
        sectionBody.isDynamic = false
        stickyPath.physicsBody = sectionBody
        
        sticky.name = "Sticky"
        sticky.zPosition = 5
        
        sticky.addChild(stickyPath)
        
    }
        
    func createFire(position: CGPoint, size: Int){
            
            let path = UIBezierPath()
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: -1, y: 4))
            path.addLine(to: CGPoint(x: 4, y: 4))
            path.addLine(to: CGPoint(x: 5, y: 2))
            path.addLine(to: CGPoint(x: 5, y: 1))
            path.addLine(to: CGPoint(x: 6, y: -1))
            path.addLine(to: CGPoint(x: 5, y: -4))
            path.addLine(to: CGPoint(x: -1, y: -3))
            path.addLine(to: CGPoint(x: -2, y: -3))
            path.addLine(to: CGPoint(x: -5, y: -2))
            path.addLine(to: CGPoint(x: -4, y: 0))
            path.addLine(to: CGPoint(x: -3, y: 1))
            path.addLine(to: CGPoint(x: -2, y: 3))
            path.addLine(to: CGPoint(x: -1, y: 4))
                                
            path.apply(CGAffineTransform(scaleX: CGFloat(size), y: CGFloat(size)))
            
            let firePath = SKShapeNode(path: path.cgPath)
            
            firePath.fillColor = .red
            firePath.strokeColor = .clear
            firePath.position = position
            
            let sectionBody = SKPhysicsBody(polygonFrom: path.cgPath)
            sectionBody.categoryBitMask = physicsCategories.fire
            sectionBody.contactTestBitMask = physicsCategories.player

            sectionBody.usesPreciseCollisionDetection = true
            sectionBody.isDynamic = false
//            sectionBody.collisionBitMask = 1
            sectionBody.affectedByGravity = false
//          sectionBody.isDynamic = false
            firePath.physicsBody = sectionBody
            fire.zPosition = 5
            fire.name = "Fire"
            fire.addChild(firePath)
            
        }
        
        
        
        func addPlayer() {
            
            let size = CGSize(width: 50, height: 50)
            let crossTexture = SKTexture(imageNamed: "cross")
            
            finalPlayer.texture = crossTexture
            finalPlayer.size = size
            finalPlayer.speed = 0.01
            finalPlayer.position = CGPoint(x: 0, y: -50)
            finalPlayer.zPosition = 9
            
            //setup physics body
            let sectionBody = SKPhysicsBody(texture: crossTexture, size: size)
//            let sectionBody = SKPhysicsBody(rectangleOf: finalPlayer.size)
            sectionBody.categoryBitMask = physicsCategories.player
            
            sectionBody.usesPreciseCollisionDetection = true
//            sectionBody.collisionBitMask = 0b1000
//            sectionBody.affectedByGravity = true
//          sectionBody.isDynamic = false
            finalPlayer.physicsBody = sectionBody
            finalPlayer.name = "Player"
            self.addChild(finalPlayer)
        }
    
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                if check == 1{
                    
                if stickyChecker == true {
                        stickyChecker = false
                        self.view?.isPaused = false
                }
                    
                let location = touch.location(in: self)
                let initialLoc = initialPosition
                var dx = initialLoc.x - location.x
                var dy = initialLoc.y - location.y

                var magnitude = sqrt(dx*dx+dy*dy)
                magnitude /= 8
                dx /= magnitude
                dy /= magnitude

                vector = CGVector(dx: dx, dy: dy)

                finalPlayer.physicsBody?.applyImpulse(vector)
            }
            }
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
                let location = touch.location(in: self)
                initialPosition = location
                let touchedNode: SKNode = self.atPoint(location)
                if let name = touchedNode.name {
                if name == "mode1"{
                    titleScreen.removeFromParent()
                    self.view?.isPaused = false
                    check = 1 // easy
                    modeButtons.removeFromParent()
                }
                if name == "mode2"{
                    titleScreen.removeFromParent()
                    self.view?.isPaused = false
                    check = 2
                    modeButtons.removeFromParent()
                }
                if name == "mode3"{
                    titleScreen.removeFromParent()
                    self.view?.isPaused = false
                    check = 3
                    modeButtons.removeFromParent()
                }
//                    if name == "title"{
//                        restartScene()
//                        createTitleScreen()
//                    }
                if name == "restartButton"{
                        restartScene()
                    modeButtons.removeFromParent()
                    }
//                if name == "play"{
//                    restartButton.zPosition = 102
//
//                    screen.fillColor = .yellow
//                    screen.alpha = 0.85
//                    screen.zPosition = 101
//
//                    self.isPaused = true
//                }
//                if name == "pause"{
//                    screen.alpha = 0
//                    self.isPaused = false
//                }
            }
            }
    }
    
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                if check == 2{
                if stickyChecker == true {
                        stickyChecker = false
                        self.view?.isPaused = false
                }
                let location =  touch.location(in: self)
                var dx = initialPosition.x - location.x
                var dy = initialPosition.y - location.y
                
                var magnitude = sqrt(dx*dx+dy*dy)
                magnitude /= 2
                dx /= magnitude
                dy /= magnitude
                
                vector = CGVector(dx: 30*dx, dy: 75*dy)
            
                finalPlayer.physicsBody?.applyImpulse(vector)
                }
                
                if check == 3 {
                if stickyChecker == true {
                        stickyChecker = false
                        self.view?.isPaused = false
                }
                let location = touch.location(in: self)
                var dx = (finalPlayer.position.x - location.x)
                var dy = (finalPlayer.position.y - location.y)/4


                // Normalize the components
                var magnitude = sqrt(dx*dx+dy*dy)
                magnitude /= 2
                dx /= magnitude
                dy /= magnitude

//                 Create a vector in the direction of the bird
                let vector = CGVector(dx:25*dx, dy: 150*dy)
                
//                 Apply impulse
                finalPlayer.physicsBody?.applyImpulse(vector)
                }
            }
        }

    
    func didBegin(_ contact: SKPhysicsContact){
        let other = contact.bodyA.categoryBitMask == physicsCategories.player ? contact.bodyB : contact.bodyA
        
//        if contact.bodyA.node!.name == "sticky"{
//
//        }
//
//        if contact.bodyB.node!.name == "sticky"{
//        }
        
        if other.categoryBitMask == physicsCategories.fire {
            self.view?.isPaused = true
            loseScreen.isHidden = false
            createRestartButton()
//            createTitleButton()
        }
        
        if other.categoryBitMask == physicsCategories.sticky {
            
            stickyChecker = true
            self.view?.isPaused = true

        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if section == true{
        let playerPositionInCamera = cameraNode.convert(finalPlayer.position, to: self)
        if playerPositionInCamera.y > 0 && !cameraNode.hasActions() {
            cameraNode.position.y = finalPlayer.position.y
        }
        }
        leftwall.position.y = finalPlayer.position.y
        loseScreen.position.y = finalPlayer.position.y
        rightwall.position.y = finalPlayer.position.y
        if finalPlayer.position.y > 500 {
            restartButton.position.y = finalPlayer.position.y-350
            restartLabel.position.y = finalPlayer.position.y-370
        }
        
        
        if finalPlayer.position.y > 2660+2704*3+1536*2{
            finalPlayer.position = CGPoint.zero
            let winScreen = SKSpriteNode()
            winScreen.zPosition = 100
            winScreen.size = self.size
            winScreen.texture = SKTexture(imageNamed: "welcome")
            self.addChild(winScreen)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                winScreen.removeFromParent()
                self.background1.removeFromParent()
                self.background2.removeFromParent()
                self.background3.removeFromParent()
                self.sticky.removeFromParent()
                self.fire.removeFromParent()
                self.rock.removeFromParent()
                self.physicsWorld.speed = 0.5
                let top = SKNode()
                top.position = CGPoint(x: 0, y: 565)
                let topBody = SKPhysicsBody(rectangleOf: CGSize(width: 750, height: 10))
                topBody.isDynamic = false
                topBody.categoryBitMask = physicsCategories.boundary
                top.physicsBody = topBody
                self.addChild(top)
                self.createRestartButton()
//                self.createTitleButton()
                self.section = false
            }
        }
}
}
