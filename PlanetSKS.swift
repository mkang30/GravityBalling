import Foundation
import SpriteKit
import SceneKit
public class PlanetSKS: SKScene {
    override public func sceneDidLoad(){
        super.sceneDidLoad()
        if let infoEarth: SKSpriteNode = childNode(withName: "earthInfo") as! SKSpriteNode? {
            infoEarth.texture = SKTexture(imageNamed: "Images/info2.png")
            if let infoMars: SKSpriteNode = childNode(withName: "marsInfo") as! SKSpriteNode? {
                infoMars.texture = SKTexture(imageNamed: "Images/info2.png")
                if let infoJupiter: SKSpriteNode = childNode(withName: "jupiterInfo") as! SKSpriteNode?{
                    infoJupiter.texture = SKTexture(imageNamed: "Images/info2.png")
                }
            }
        }
    }
}

