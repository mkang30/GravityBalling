import Foundation
import SpriteKit
import SceneKit
public class MenuSKS: SKScene {
    var highscoreLabel: SKLabelNode!
    override public func sceneDidLoad(){
        super.sceneDidLoad()
        if let highscore: SKLabelNode = childNode(withName: "highscore") as! SKLabelNode? {
            highscoreLabel = highscore
        }
    }
    public func updateHighScore() {
        highscoreLabel.text = "Highscore: \(Data.highScore)"
    }
}


