import Foundation
import SpriteKit
import SceneKit
/**
* This class models the Menu scene. All the methods and
* variable are aimed to add graphical components.
*/
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


