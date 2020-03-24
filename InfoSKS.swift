import Foundation
import SpriteKit
import SceneKit
/**
* This class models the Info scene. All the methods and
* variable are aimed to add graphical components.
*/
public class InfoSKS: SKScene {
    var diameter: SKLabelNode!
    var density: SKLabelNode!
    var mass: SKLabelNode!
    var gravity: SKLabelNode!
    var picture: SKSpriteNode!
    var title: SKLabelNode!
    override public func sceneDidLoad(){
        super.sceneDidLoad()
        if let diameterL: SKLabelNode = childNode(withName: "diameter") as! SKLabelNode? {
            diameter = diameterL
            if let densityL: SKLabelNode = childNode(withName: "density") as! SKLabelNode? {
                density = densityL
                if let gravityL: SKLabelNode = childNode(withName: "gravity") as! SKLabelNode? {
                    gravity = gravityL
                    if let massL: SKLabelNode = childNode(withName: "mass") as! SKLabelNode? {
                        mass = massL
                        if let pictureL: SKSpriteNode = childNode(withName: "planet") as! SKSpriteNode? {
                            picture = pictureL
                            if let titleL: SKLabelNode = childNode(withName: "title") as! SKLabelNode? {
                                title = titleL
                            }
                        }
                    }
                }
            }
        }
        
    }
   
    public func setInfo(info: Int){
        if info == 1 {
            title.text = "Earth"
            diameter.text = "Diameter: 12742km"
            density.text = "Density: 5.52g/cmˆ3"
            mass.text = "Mass: 1.00Me"
            gravity.text = "Gravity: 9.8m/sˆ2"
            picture.texture = SKTexture(imageNamed: "Images/earth2.png")            
        }
        else if info == 2{
            title.text = "Jupiter"
            diameter.text = "Diameter: 13982km"
            density.text = "Density: 1.33g/cmˆ3"
            mass.text = "Mass: 317.83Me"
            gravity.text = "Gravity: 24.9m/sˆ2"
            picture.texture = SKTexture(imageNamed: "Images/jupiter3.png")

        }
        else if info == 3{
            title.text = "Mars"
            diameter.text = "Diameter: 6779km"
            density.text = "Density: 3.93g/cmˆ3"
            mass.text = "Mass: 0.11Me"
            gravity.text = "Gravity: 3.7m/sˆ2"
            picture.texture = SKTexture(imageNamed: "Images/mars3.png")
        }
    }
}


