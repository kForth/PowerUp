import SpriteKit

class MenuScene: SKScene {
    
    var start_button: SKLabelNode?
    var bot_next_button: SKSpriteNode?
    var bot_prev_button: SKSpriteNode?
    var robot_select_sprite: SKSpriteNode?
    var robot_name_label: SKLabelNode?
    
    override func didMove(to view: SKView) {
        start_button = self.childNode(withName: "//start_button") as? SKLabelNode
        bot_next_button = self.childNode(withName: "//bot_next_button") as? SKSpriteNode
        bot_prev_button = self.childNode(withName: "//bot_prev_button") as? SKSpriteNode
        robot_select_sprite = self.childNode(withName: "//robot_select_sprite") as? SKSpriteNode
        robot_name_label = self.childNode(withName: "//robot_name_label") as? SKLabelNode
    }
    
    let robot_types: [String] = ["148", "5406", "254"]
    var selected_bot: String = "148"
    
    func setSelectedBot(bot: String) {
        if robot_types.index(of: bot)! > -1 {
            selected_bot = bot
            robot_select_sprite?.texture = SKTexture(imageNamed: "\(bot)_Oblique")
            robot_name_label?.text = bot
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if (start_button?.contains(touch.location(in: self)))! {
                let scene = SKScene(fileNamed: "GameScene")
                scene?.scaleMode = .aspectFill
                view?.presentScene(scene!, transition: SKTransition.fade(withDuration: 1))
                (scene as! GameScene).addPlayer(robot_type: selected_bot)
            }
            else if (bot_next_button?.contains(touch.location(in: self)))!{
                var index = robot_types.index(of: selected_bot)! + 1
                if index >= robot_types.count {
                    index = 0
                }
                setSelectedBot(bot: robot_types[index])
            }
            else if (bot_prev_button?.contains(touch.location(in: self)))!{
                var index = robot_types.index(of: selected_bot)! - 1
                if index <= -1 {
                    index = robot_types.count - 1
                }
                setSelectedBot(bot: robot_types[index])
            }
        }
    }
}
