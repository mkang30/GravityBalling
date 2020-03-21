
import Foundation
import SpriteKit
import SceneKit
enum ColliderType: Int {
    case football = 0b0001
    case target = 0b0010
    case wall = 0b0100
    case goalPost = 0b1000
}
public class GameView: SCNView {
    var text: SCNText!
    var menuHighNode: SCNNode!
    var moveTime: TimeInterval = 0
    var animeTime: TimeInterval = 0

    var gameData = Data()
    var footballNode: SCNNode?
    var targetNode: SCNNode?
    let menuSCN = SCNScene(named: "Scene.scnassets/Menu.scn")!
    let gameSCN = SCNScene(named: "Scene.scnassets/Game.scn")!
    let marsSCN = SCNScene(named: "Scene.scnassets/Mars.scn")!
    let planetSCN = SCNScene(named: "Scene.scnassets/Planets.scn")!
    let jupiterSCN = SCNScene(named: "Scene.scnassets/Jupiter.scn")!
    let instSCN = SCNScene(named: "Scene.scnassets/Instructions.scn")!
    let overlayMenu = MenuSKS(fileNamed: "SKScene/Menu.sks")!
    let overlayPlanets = PlanetSKS(fileNamed: "SKScene/PlanetsOverlay.sks")!
    let overlayHud = GameHudSKS(fileNamed: "SKScene/GameHud.sks")!
    let overlayInfo = InfoSKS(fileNamed: "SKScene/InfoOverlay.sks")!
    let infoScene = SCNScene(named: "Scene.scnassets/InfoScene.scn")!
    let overlayInst = SKScene(fileNamed: "SKScene/Instructions.sks")!
    var cameraNodePlanets: SCNNode!
    var earthNode: SCNNode!
    var jupiterNode: SCNNode!
    var marsNode:SCNNode!
    var goalPostNode: SCNNode!
    var fenceNode: SCNNode!
    var floorNode: SCNNode!
    var clickStartTime: TimeInterval!
    var clickEndTime: TimeInterval!
    let gestureRecognizer = NSGestureRecognizer()
    var throwState: Bool = false
    var lastContactNode: SCNNode!
    var planet: Int = 0

    lazy var clickCatchingPlaneNode: SCNNode = {
        let node = SCNNode(geometry: SCNPlane(width: 40, height: 40))
        node.opacity = 0.001
        node.castsShadow = false
        return node
    }()
    
    public init(){
        super.init(frame: CGRect(x:0, y:0, width: 800, height: 600), options: nil)
        cameraNodePlanets = planetSCN.rootNode.childNode(withName: "camera", recursively: true)
        planetSCN.isPaused = true
        self.overlaySKScene = overlayMenu
        displayHigh()
        self.present(menuSCN, with: SKTransition.doorsOpenVertical(withDuration: 1.0), incomingPointOfView: nil, completionHandler: nil)
    }
    public required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    public override func rightMouseDown(with event: NSEvent?) {
        guard let balle = footballNode else {return}
        for ballNode in gameData.ballNodes{
            ballNode.removeFromParentNode()
        }
        balle.position = SCNVector3(x: 0, y: 0.35, z: 8.0)
    }

    public override func mouseDown(with event: NSEvent?) {
        let point = gestureRecognizer.location(in: self)
        let hitResults = self.hitTest(point, options: [:])
        if hitResults.first?.node == footballNode {
            clickStartTime = Date().timeIntervalSince1970
            throwState = true
        } else if hitResults.first?.node.name == "play" {
            planetSCN.isPaused = false
            self.overlaySKScene = overlayPlanets
            moveAudio(scene: planetSCN)
            setPlanetsScene()
            self.present(planetSCN, with: SKTransition.fade(withDuration: 1.0), incomingPointOfView: nil, completionHandler: nil)
        } else if hitResults.first?.node.name == "menu" {
            moveAudio(scene: menuSCN)
            menuPath()
        } else if hitResults.first?.node.name == "instructions" {
            self.present(instSCN, with: SKTransition.doorsOpenVertical(withDuration: 1.0), incomingPointOfView: nil, completionHandler: nil)
            self.overlaySKScene = overlayInst
            moveAudio(scene: instSCN)
            self.overlaySKScene = overlayInst
        } else if hitResults.first?.node.name == "back" {
            overlayMenu.updateHighScore()
            self.overlaySKScene = overlayMenu
            self.present(menuSCN, with: SKTransition.doorsOpenVertical(withDuration: 1.0), incomingPointOfView: nil, completionHandler: nil)
            moveAudio(scene: menuSCN)
        } else if hitResults.first?.node.name == "mars" {
            planetSCN.isPaused = true
            gameSCN.isPaused = true
            jupiterSCN.isPaused = true
            marsSCN.isPaused = false
            planet = 3
            self.overlaySKScene = nil
            moveAudio(scene: marsSCN)
            setMars()
            self.present(marsSCN, with: SKTransition.doorsOpenVertical(withDuration: 1.0), incomingPointOfView: nil, completionHandler: {() in self.overlaysHud()})
        } else if hitResults.first?.node.name == "earth" {
            planetSCN.isPaused = true
            gameSCN.isPaused = false
            jupiterSCN.isPaused = true
            marsSCN.isPaused = true
            planet = 1
            self.overlaySKScene = nil
            moveAudio(scene: gameSCN)
            setGame()
            self.present(gameSCN, with: SKTransition.doorsOpenVertical(withDuration: 1.0), incomingPointOfView: nil, completionHandler: {() in self.overlaysHud()})
        } else if hitResults.first?.node.name == "jupiter" {
            planetSCN.isPaused = true
            gameSCN.isPaused = true
            jupiterSCN.isPaused = false
            marsSCN.isPaused = true
            planet = 2
            self.overlaySKScene = nil
            moveAudio(scene: jupiterSCN)
            setJupiter()
            self.present(jupiterSCN, with: SKTransition.doorsOpenVertical(withDuration: 1.0), incomingPointOfView: nil, completionHandler: {() in self.overlaysHud()})
        } else if hitResults.first?.node.name == "jupiterInfo"{
            planetSCN.isPaused = true
            gameSCN.isPaused = true
            jupiterSCN.isPaused = true
            marsSCN.isPaused = true
            self.present(infoScene, with: SKTransition.fade(withDuration: 1.0), incomingPointOfView: nil, completionHandler: nil)
            overlayInfo.setInfo(info: 2)
            moveAudio(scene: infoScene)
            self.overlaySKScene = overlayInfo
        }
        else if hitResults.first?.node.name == "marsInfo"{
            planetSCN.isPaused = true
            gameSCN.isPaused = true
            jupiterSCN.isPaused = true
            marsSCN.isPaused = true
            self.present(infoScene, with: SKTransition.fade(withDuration: 1.0), incomingPointOfView: nil, completionHandler: nil)
            overlayInfo.setInfo(info: 3)
            moveAudio(scene: infoScene)
            self.overlaySKScene = overlayInfo
        }
        else if hitResults.first?.node.name == "earthInfo"{
            planetSCN.isPaused = true
            gameSCN.isPaused = true
            jupiterSCN.isPaused = true
            marsSCN.isPaused = true
            self.present(infoScene, with: SKTransition.fade(withDuration: 1.0), incomingPointOfView: nil, completionHandler: nil)
            overlayInfo.setInfo(info: 1)
            moveAudio(scene: infoScene)
            self.overlaySKScene = overlayInfo
        }
        else if hitResults.first?.node.name == "back2"{
            planetSCN.isPaused = false
            gameSCN.isPaused = true
            jupiterSCN.isPaused = true
            marsSCN.isPaused = true
            self.present(planetSCN, with: SKTransition.fade(withDuration: 1.0), incomingPointOfView: nil, completionHandler: nil)
            moveAudio(scene: planetSCN)
            self.overlaySKScene = overlayPlanets
        }
    }
    
    public override func mouseUp(with event: NSEvent?) {
        if throwState == true {
            clickEndTime = Date().timeIntervalSince1970
            if planet == 2 {
                throwBall(sceneTB: jupiterSCN, xS: 1.2, yS: 3.0, zS: 15.0)
            }
            else if planet == 1 {
                throwBall(sceneTB: gameSCN, xS: 2, yS: 7, zS: 19.0)
            }
            else if planet == 3 {
                throwBall(sceneTB: marsSCN, xS: 2.2, yS: 10.0, zS: 22.0)
            }
            throwState = false
        }
    }
    
    func overlaysHud(){
        self.overlaySKScene = overlayHud
    }
    func moveAudio(scene: SCNScene){
        scene.rootNode.runAction(SCNAction.playAudio(gameData.moveToSound, waitForCompletion: true))
    }
    func targetAudio(sceneTA: SCNScene){
        sceneTA.rootNode.runAction(SCNAction.playAudio(gameData.targetHit, waitForCompletion: false))
    }
    func postAudio(scenePA: SCNScene){
        scenePA.rootNode.runAction(SCNAction.playAudio(gameData.postHit, waitForCompletion: false))
    }
    func wallAudio(){
        gameSCN.rootNode.runAction(SCNAction.playAudio(gameData.wallHit, waitForCompletion: true))
    }
    
    func displayHigh(){
        text = SCNText(string: "Highscore: \(Data.highScore)", extrusionDepth: 0.05)
        text.font = NSFont(name: "Helvetica", size: 0.3)
        
        menuHighNode = SCNNode(geometry: text)
        menuHighNode.position = SCNVector3(x: -1.0, y: 7.9, z: -4)
        menuSCN.rootNode.addChildNode(menuHighNode)
        
    }
 
    func menuPath(){
        planet = 0
        overlayMenu.updateHighScore()
        self.overlaySKScene = overlayMenu
        self.present(menuSCN, with: SKTransition.doorsOpenVertical(withDuration: 1.0), incomingPointOfView: nil, completionHandler: nil)
        resetGame()
    }
    func setPlanetsScene(){
        self.delegate = self
        earthNode = planetSCN.rootNode.childNode(withName: "earth", recursively: true)
        jupiterNode = planetSCN.rootNode.childNode(withName: "jupiter", recursively: true)
        marsNode = planetSCN.rootNode.childNode(withName: "mars", recursively: true)
    }
    func setPlanets(node: SCNNode){
        let roundAbout = SCNAction.rotate(toAxisAngle: SCNVector4(x:0, y:1, z:0, w: node.rotation.w+CGFloat(Double.pi)), duration: 4.0)
        node.runAction(roundAbout)
    }
        
    func setGame(){
        gameSCN.physicsWorld.contactDelegate = self
        self.delegate = self
        overlayHud.setTitle(state: planet)
        overlayHud.updateHud(balls: (10 - gameData.ballNodes.count))
        addTarget(sceneAT: gameSCN)
        goalPostNode = gameSCN.rootNode.childNode(withName: "goalPost", recursively: true)!
        fenceNode = gameSCN.rootNode.childNode(withName: "Fence", recursively: true)!
        floorNode = gameSCN.rootNode.childNode(withName: "floor", recursively: true)!
    gameSCN.rootNode.addChildNode(clickCatchingPlaneNode)
        clickCatchingPlaneNode.position = SCNVector3(x:0, y:0, z: goalPostNode.position.z)
        settingTheBall(scene: gameSCN)
    }
    func setJupiter(){
        jupiterSCN.physicsWorld.contactDelegate = self
        self.delegate = self
        overlayHud.setTitle(state: planet)
        overlayHud.updateHud(balls: (10 - gameData.ballNodes.count))
        addTarget(sceneAT: jupiterSCN)
        goalPostNode = jupiterSCN.rootNode.childNode(withName: "goalPost", recursively: true)!
        floorNode = jupiterSCN.rootNode.childNode(withName: "floor", recursively: true)!
        jupiterSCN.rootNode.addChildNode(clickCatchingPlaneNode)
        clickCatchingPlaneNode.position = SCNVector3(x:0, y:0, z: goalPostNode.position.z)
        settingTheBall(scene: jupiterSCN)
    }
    func setMars(){
        marsSCN.physicsWorld.contactDelegate = self
        self.delegate = self
        overlayHud.setTitle(state: planet)
        overlayHud.updateHud(balls: (10 - gameData.ballNodes.count))
        addTarget(sceneAT: marsSCN)
        goalPostNode = marsSCN.rootNode.childNode(withName: "goalPost", recursively: true)!
        floorNode = marsSCN.rootNode.childNode(withName: "floor", recursively: true)!
        marsSCN.rootNode.addChildNode(clickCatchingPlaneNode)
        clickCatchingPlaneNode.position = SCNVector3(x:0, y:0, z: goalPostNode.position.z)
        settingTheBall(scene: marsSCN)
    }
   
    func settingTheBall(scene: SCNScene){
        let footballScene = SCNScene(named: "Scene.scnassets/Football.scn")!
        let footballNodeTemp = footballScene.rootNode.childNode(withName: "sphere", recursively: true)!
        footballNodeTemp.name = "football"
        let footballPhysics = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: SCNSphere(radius: 0.35)))
        footballPhysics.mass = 3
        footballPhysics.friction = 2
        footballPhysics.categoryBitMask = 1
        footballPhysics.contactTestBitMask = ColliderType.target.rawValue | ColliderType.wall.rawValue | ColliderType.goalPost.rawValue
        footballNodeTemp.physicsBody = footballPhysics
        footballNodeTemp.position = SCNVector3(x: -3, y: 1.75, z: 8.0)
        footballNodeTemp.physicsBody?.applyForce(SCNVector3(x: 1.45, y: 0, z: 0), asImpulse: true)
        footballNode = footballNodeTemp
        scene.rootNode.addChildNode(footballNodeTemp)

    }
 
    func addTarget(sceneAT: SCNScene){
        let targetScene = SCNScene(named: "Scene.scnassets/Target.scn")!
        let targetNodeTemp = targetScene.rootNode.childNode(withName: "target", recursively: true)!
        targetNodeTemp.name = "target"
        let physics = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: SCNCylinder(radius: 0.5, height: 0.01)))
        physics.mass = 3
        physics.friction = 2
        physics.categoryBitMask = 2
        physics.isAffectedByGravity = false
        targetNodeTemp.physicsBody = physics
        if gameData.targetCount < 3 {
            targetNodeTemp.position = SCNVector3(x: CGFloat(Data.randomX()), y: CGFloat(Data.randomY()), z: -2.25)
        } else {
            targetNodeTemp.position = SCNVector3(x: CGFloat(Data.randomX2()), y: CGFloat(Data.randomY()), z: -2.25)
        }
        targetNode = targetNodeTemp
        sceneAT.rootNode.addChildNode(targetNodeTemp)
        gameData.currentTarget.append(targetNodeTemp)
        gameData.targetCount += 1
    }
    
    func throwBall(sceneTB: SCNScene, xS: CGFloat, yS: CGFloat, zS: CGFloat){
        guard let ballNode = footballNode else {return}
        let endingClick = gestureRecognizer
        
        let firstClickResult = self.hitTest(endingClick.location(in: self), options: nil).filter({$0.node == clickCatchingPlaneNode}).first
        guard let clickResult = firstClickResult else {return}
        
        let timeDifference = clickEndTime - clickStartTime
        let velocity = CGFloat(min(max(1 - timeDifference, 0.1), 1.0))
        
        let impulseVector = SCNVector3(x: clickResult.localCoordinates.x * xS, y: clickResult.localCoordinates.y * velocity * yS, z: goalPostNode.position.z * velocity * zS)
        ballNode.physicsBody?.applyForce(impulseVector, asImpulse: true)
        gameData.ballNodes.append(ballNode)
        overlayHud.updateHud(balls: (10 - gameData.ballNodes.count))

        footballNode = nil
        clickStartTime = nil
        clickEndTime = nil
        if gameData.ballNodes.count == Data.maxFootball {
            
            let wait = SCNAction.wait(duration: 1.0)
            let audio = SCNAction.playAudio(gameData.endSound, waitForCompletion: true)
            let action = SCNAction.run { _ in self.menuPath()}
            let sequenceAction = SCNAction.sequence([wait, audio, action])
            sceneTB.rootNode.runAction(sequenceAction)
        }
        else {
            let wait = SCNAction.wait(duration: 0.5)
            let block = SCNAction.run { _ in self.settingTheBall(scene: sceneTB)}
            let sequenceAction = SCNAction.sequence([wait, block])
            sceneTB.rootNode.runAction(sequenceAction)
        }
    }
    func targetXpos() -> CGFloat{
        guard let tempoTarget = targetNode else {return 0}
        let xCor = tempoTarget.position.x
        if xCor < -0.125{
            return 2.9
        }
        else {
            return -2.9
        }
    }
 
    func targetMove(timing: TimeInterval){
        guard let tempoTarget = targetNode else {return}
        let action = SCNAction.move(to: SCNVector3(x: targetXpos(), y: tempoTarget.position.y, z: tempoTarget.position.z), duration: timing)
        tempoTarget.runAction(action)
    }
    func resetGame(){
        footballNode?.removeFromParentNode()
        for ballNode in gameData.ballNodes{
            ballNode.removeFromParentNode()
        }
        targetNode?.removeFromParentNode()
        for target in gameData.currentTarget{
            target.removeFromParentNode()
        }
        gameData.ballNodes.removeAll()
        gameData.currentTarget.removeAll()
        gameData.targetCount = 0
        Data.score = 0
        overlayHud.updateHud(balls: (10 - gameData.ballNodes.count))
    }
}

extension GameView: SCNSceneRendererDelegate {
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval){
        if planetSCN.isPaused == false {
            if time > animeTime {
                setPlanets(node: jupiterNode)
                setPlanets(node: marsNode)
                setPlanets(node: earthNode)
                animeTime = time + TimeInterval(4.0)
            }
        }
        if time > moveTime{
            if gameData.targetCount > 3 && gameData.targetCount < 7{
                targetMove(timing: 1.0)
                moveTime = time + TimeInterval(1.0)
            }
            else if gameData.targetCount > 6 {
                targetMove(timing: 0.5)
                moveTime = time + TimeInterval(0.5)
            }
        }
    }
}

extension GameView: SCNPhysicsContactDelegate {
    public func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        var contactNode: SCNNode!
        if contact.nodeA.name == "football"{
            contactNode = contact.nodeB
        } else {
            contactNode = contact.nodeA
        }
        if lastContactNode != nil && lastContactNode.name == contactNode.name {
            return
        }
        if contactNode.physicsBody?.categoryBitMask == ColliderType.target.rawValue {
            contactNode.categoryBitMask = 0
            contactNode.removeFromParentNode()

            if planet == 2 {
                targetAudio(sceneTA: jupiterSCN)
            }
            else if planet == 1 {
                targetAudio(sceneTA: gameSCN)
            }
            else if planet == 3 {
                targetAudio(sceneTA: marsSCN)
            }
            Data.score += 1
        
            if Data.highScore < Data.score {
                Data.highScore = Data.score
            }
            overlayHud.updateHud(balls: (10 - gameData.ballNodes.count))
            if gameData.ballNodes.count != 10{
                let waitAction = SCNAction.wait(duration: 0.5)
                let action = SCNAction.run { _ in self.addTarget(sceneAT: self.scene!)}
                let sequence = SCNAction.sequence([waitAction, action])
                self.scene!.rootNode.runAction(sequence)
            }
            
        } else if contactNode.physicsBody?.categoryBitMask == ColliderType.goalPost.rawValue {
            if planet == 2 {
                postAudio(scenePA: jupiterSCN)
            }
            else if planet == 1 {
                postAudio(scenePA: gameSCN)
            }
            else if planet == 3 {
                postAudio(scenePA: marsSCN)
            }
        } else if contactNode.physicsBody?.categoryBitMask == ColliderType.wall.rawValue {
            wallAudio()
            
        }
        lastContactNode = contactNode
    }
}
