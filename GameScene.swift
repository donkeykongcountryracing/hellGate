//
//  GameScene.swift
//  hellGate
//
//  Created by Ethan Jin on 18/11/2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let cameraNode = SKCameraNode()
    let player = SKNode()
    
    func addPlayer() {
        let circle = SKShapeNode(circleOfRadius: 80)
        let path = UIBezierPath(roundedRect: CGRect(x: -200, y: -200, width: 400, height: 60), cornerRadius: 20)
        
        for i in 0...1{
            let cross = SKShapeNode(path: path.cgPath)
            cross.fillColor = UIColor.brown
            cross.strokeColor = UIColor.brown
            cross.zRotation = CGFloat(Double.pi/2) * CGFloat(i);
            cross.position = CGPoint(x: -170*i, y: -170*i)
            player.addChild(cross)
        }
        
        player.position = CGPoint(x: 0,y: 0)
        circle.fillColor = .white
        circle.strokeColor = .clear
        circle.position = CGPoint(x: 0, y: -170)
        player.addChild(circle)
        player.setScale(CGFloat(0.6))
        self.addChild(player)
    }
    
    override func didMove(to view: SKView) {
        addPlayer()
        
        self.addChild(cameraNode)
        camera/* node that determines which part of the scene's coordinate spaces are availibe to the view*/ = cameraNode
        cameraNode.position = player.position
    }
    
    override func update(_ currentTime: TimeInterval) {
        let playerPositionInCamera = cameraNode.convert/*converts a point in this node coordinate system to the coordinate system of another node in the node tree*/(player.position, to: self)
        if playerPositionInCamera.y > -600 && !cameraNode/* you need the exclamation mark or it won't run the code, search up what the exclamation mark does and why I have to have it right now to have the code check whether it is true for the if statement*/.hasActions() {
            cameraNode.position.y = player.position.y
        }
    }
}
