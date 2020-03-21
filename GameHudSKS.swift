import Foundation
import SpriteKit
import SceneKit
public class GameHudSKS: SKScene {
    var scoreHud: SKLabelNode!
    var title: SKLabelNode!
    override public func sceneDidLoad(){
        super.sceneDidLoad()
        if let highscore: SKLabelNode = childNode(withName: "hud") as! SKLabelNode? {
            scoreHud = highscore
            if let planeTitle: SKLabelNode = childNode(withName: "title") as! SKLabelNode? {
                title = planeTitle
            }
        }
        
    }
    public func updateHud(balls: Int) {
        scoreHud.text = "Highscore: \(Data.highScore) Score: \(Data.score) ⚽️: \(balls)"
    }
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

