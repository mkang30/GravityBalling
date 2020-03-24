import Foundation
import SpriteKit
import SceneKit
/**
* This class models HUDs used in the game
* extends from SKScene as HUDs are 2D
* components.
*/
public class GameHudSKS: SKScene {
    var scoreHud: SKLabelNode!
    var title: SKLabelNode!
    /*
    * Uploading the display to the main view
    */
    override public func sceneDidLoad(){
        super.sceneDidLoad()
        if let highscore: SKLabelNode = childNode(withName: "hud") as! SKLabelNode? {
            scoreHud = highscore
            if let planeTitle: SKLabelNode = childNode(withName: "title") as! SKLabelNode? {
                title = planeTitle
            }
        }
        
    }
    /*
    * Updates the hud (called when the score or highscore change)
    */
    public func updateHud(balls: Int) {
        scoreHud.text = "Highscore: \(Data.highScore) Score: \(Data.score) ⚽️: \(balls)"
    }
    /*
    * Self-explanatory
    */
    public func setTitle(state: Int){
        if state == 1 {
            title.text = "Earth"
        }
        else if state == 2{
            title.text = "Jupiter"
        }
        else if state == 3{
            title.text = "Mars"
        }
    }
}

