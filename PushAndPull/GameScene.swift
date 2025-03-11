//
//  GameScene.swift
//  Push&Pull
//
//  Created by 結城 竜矢 on 2017/06/26.
//  Copyright © 2017年 結城 竜矢. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, CharacterDelegate {

    var com = Common()
    var player: Player?
    var myWindow: UIWindow = UIWindow()
    
    var scoreLabel: SKLabelNode?
    var stage = 1;
    
    var tx: Int = 0;
    var ty: Int = 0;

    var button0 = UIButton.init(type: UIButtonType.custom);
    var button1 = UIButton.init(type: UIButtonType.custom);
    var button2 = UIButton.init(type: UIButtonType.custom);
    var button3 = UIButton.init(type: UIButtonType.custom);
    var button4 = UIButton.init(type: UIButtonType.custom);

    var actionF: SKAction = SKAction.init();
    var actionB: SKAction = SKAction.init();
    var actionR: SKAction = SKAction.init();
    var actionL: SKAction = SKAction.init();
    var actionFP: SKAction = SKAction.init();
    var actionBP: SKAction = SKAction.init();
    var actionRP: SKAction = SKAction.init();
    var actionLP: SKAction = SKAction.init();
    
    func setStage(stage: Int) {
        self.stage = stage;
    }
    
    func tileByPosition(_ position: TilePosition) -> Tile? {
        return com.tileByPosition(position)
    }
    
    func drawMap() {
        print("stage=\(stage)")
        if let fileName = Bundle.main.path(forResource: "map" + String(stage), ofType: "csv") {
            com.loadMapData(fileName)
        }
        
        
        for tile in com.tileMap {
            self.addChild(tile)
        }
    }
    
    func setup() {
        self.backgroundColor = UIColor.darkGray
        
        button0.frame = CGRect(x:0, y:0, width:25, height:25);
        button0.setTitleColor(UIColor.black, for: UIControlState.normal);
        button0.setTitle("Menu", for: UIControlState.normal);
        button0.setTitleColor(UIColor.white, for: UIControlState.highlighted);
        button0.setTitle("Menu", for: UIControlState.highlighted);
        button0.titleLabel?.font = UIFont.systemFont(ofSize: 8)
        button0.backgroundColor = UIColor.green;
        button0.layer.cornerRadius = 10.0;
        button0.addTarget(self, action: #selector(gameMenu), for: UIControlEvents.touchUpInside);
        self.view?.addSubview(button0);
        self.drawMap()
        self.createPlayer(com.startPos)
    }
    
    @objc func gameMenu() {
        // 背景を白に設定する.
        myWindow.backgroundColor = UIColor.cyan;
        myWindow.frame = CGRect(x:0, y:0, width:200, height:250);
        myWindow.layer.position = CGPoint(x: 100, y: 125);
        myWindow.alpha = 1.0;
        myWindow.layer.cornerRadius = 20;
        
        // myWindowをkeyWindowにする.
        myWindow.makeKey()
        
        // windowを表示する.
        self.myWindow.makeKeyAndVisible()
        
        // ボタンを作成する.
        button1.frame = CGRect(x:0, y:0, width:100, height:40);
        button1.backgroundColor = UIColor.orange;
        button1.setTitle("Give Up", for: UIControlState.normal);
        button1.setTitleColor(UIColor.white, for: UIControlState.normal);
        button1.layer.masksToBounds = true;
        button1.layer.cornerRadius = 20.0;
        button1.layer.position = CGPoint(x: 100, y: 50)
        button1.addTarget(self, action: #selector(onClickGiveUp), for: .touchUpInside);
        self.myWindow.addSubview(button1);
        
        button2.frame = CGRect(x:0, y:0, width:100, height:40);
        button2.backgroundColor = UIColor.orange;
        button2.setTitle("Go to Title", for: UIControlState.normal);
        button2.setTitleColor(UIColor.white, for: UIControlState.normal);
        button2.layer.masksToBounds = true;
        button2.layer.cornerRadius = 20.0;
        button2.layer.position = CGPoint(x: 100, y: 100)
        button2.addTarget(self, action: #selector(onClickGoTitle), for: .touchUpInside);
        self.myWindow.addSubview(button2);
        
        button4.frame = CGRect(x:0, y:0, width:100, height:40);
        button4.backgroundColor = UIColor.orange;
        button4.setTitle("Cancel", for: UIControlState.normal);
        button4.setTitleColor(UIColor.white, for: UIControlState.normal);
        button4.layer.masksToBounds = true;
        button4.layer.cornerRadius = 20.0;
        button4.layer.position = CGPoint(x: 100, y: 200)
        button4.addTarget(self, action: #selector(onClickCancel), for: .touchUpInside);
        self.myWindow.addSubview(button4);
        
    }
    
    @objc func onClickGiveUp() {
        self.myWindow.isHidden = true;
        let scene = self.createImageScene("Miss");
        scene.stage = self.stage;
        com.playSound(filename: "se_miss");
        let transition = SKTransition.doorsOpenHorizontal(withDuration: 1.0);
        if let skView = self.view {
            button0.removeFromSuperview();
            scene.scaleMode = SKSceneScaleMode.aspectFit
            skView.presentScene(scene, transition: transition);
        }
        self.player?.stopMoving()
    }

    @objc func onClickCancel() {
        self.myWindow.isHidden = true;
    }
    
    @objc func onClickGoTitle() {
        button0.removeFromSuperview();
        self.myWindow.isHidden = true;
        let scene = TitleScene()
        scene.size = self.frame.size
        scene.scaleMode = SKSceneScaleMode.aspectFill
        self.view?.presentScene(scene, transition: SKTransition.doorsCloseVertical(withDuration: 1.0))
    }
    
    func clearScreen() {
        button0.removeFromSuperview();
        com.clearTileMap();
        player?.sprite?.removeFromParent();
    }
    
    func createPlayer(_ firstPosition: TilePosition) {
        var player1 = SKTexture(imageNamed: "front1")
        var player2 = SKTexture(imageNamed: "front2")
        let sprite = SKSpriteNode(texture: player1)
        sprite.size = CGSize(width: com.tileSize.width, height: com.tileSize.height)
        sprite.position = com.getPointByTilePosition(firstPosition)
        sprite.zPosition = 100
        self.addChild(sprite)
        
        var animation = SKAction.animate(with: [player1, player2], timePerFrame: 0.5)
        actionF = SKAction.repeatForever(animation)
        sprite.run(actionF, withKey:"Action");
        
        player1 = SKTexture(imageNamed: "back1")
        player2 = SKTexture(imageNamed: "back2")
        animation = SKAction.animate(with: [player1, player2], timePerFrame: 0.5)
        actionB = SKAction.repeatForever(animation);
        
        player1 = SKTexture(imageNamed: "right1")
        player2 = SKTexture(imageNamed: "right2")
        animation = SKAction.animate(with: [player1, player2], timePerFrame: 0.5)
        actionR = SKAction.repeatForever(animation);
        
        player1 = SKTexture(imageNamed: "left1")
        player2 = SKTexture(imageNamed: "left2")
        animation = SKAction.animate(with: [player1, player2], timePerFrame: 0.5)
        actionL = SKAction.repeatForever(animation);
        
        player1 = SKTexture(imageNamed: "front_push1")
        player2 = SKTexture(imageNamed: "front_push2")
        animation = SKAction.animate(with: [player1, player2], timePerFrame: 0.5)
        actionFP = SKAction.repeatForever(animation)
        sprite.run(actionF, withKey:"Action");

        player1 = SKTexture(imageNamed: "back_push1")
        player2 = SKTexture(imageNamed: "back_push2")
        animation = SKAction.animate(with: [player1, player2], timePerFrame: 0.5)
        actionBP = SKAction.repeatForever(animation);
        
        player1 = SKTexture(imageNamed: "right_push1")
        player2 = SKTexture(imageNamed: "right_push2")
        animation = SKAction.animate(with: [player1, player2], timePerFrame: 0.5)
        actionRP = SKAction.repeatForever(animation);
        
        player1 = SKTexture(imageNamed: "left_push1")
        player2 = SKTexture(imageNamed: "left_push2")
        animation = SKAction.animate(with: [player1, player2], timePerFrame: 0.5)
        actionLP = SKAction.repeatForever(animation);
        
        let player = Player()
        player.delegate = self
        player.position = firstPosition
        player.sprite = sprite;
        player.startMoving(toX: firstPosition.x, toY: firstPosition.y)
        
        self.player = player
    }
    
    func moveCharacter(_ character: Character) {
        var action: SKAction = SKAction.init();
        
        if (player?.state == State.none) {
            if (player?.nextDirection == .up) {
                action = actionB;
            } else if (player?.nextDirection == .down) {
                action = actionF;
            } else if (player?.nextDirection == .right) {
                action = actionR;
            } else if (player?.nextDirection == .left) {
                action = actionL;
            }
        } else if (player?.state == State.push) {
            if (player?.nextDirection == .up) {
                action = actionBP;
            } else if (player?.nextDirection == .down) {
                action = actionFP;
            } else if (player?.nextDirection == .right) {
                action = actionRP;
            } else if (player?.nextDirection == .left) {
                action = actionLP;
            }
        } else if (player?.state == State.pull) {
            if (player?.nextDirection == .up) {
                action = actionFP;
            } else if (player?.nextDirection == .down) {
                action = actionBP;
            } else if (player?.nextDirection == .right) {
                action = actionLP;
            } else if (player?.nextDirection == .left) {
                action = actionRP;
            }
        }

        if let sprite = character.sprite {
            if (character.action != action) {
                sprite.removeAction(forKey: "Action");
                sprite.run(action, withKey: "Action");
                character.action = action;
            }
            let moveAction = SKAction.move(to: com.getPointByTilePosition(character.position), duration: 0.0)
            sprite.run(moveAction)
        }
    }

    func moveto(_ character: Character) {
        var action: SKAction = SKAction.init();
        
        if (player?.state == State.none) {
            if (player?.nextDirection == .up) {
                action = actionB;
            } else if (player?.nextDirection == .down) {
                action = actionF;
            } else if (player?.nextDirection == .right) {
                action = actionR;
            } else if (player?.nextDirection == .left) {
                action = actionL;
            }
        } else if (player?.state == State.push) {
            if (player?.nextDirection == .up) {
                action = actionBP;
            } else if (player?.nextDirection == .down) {
                action = actionFP;
            } else if (player?.nextDirection == .right) {
                action = actionRP;
            } else if (player?.nextDirection == .left) {
                action = actionLP;
            }
        } else if (player?.state == State.pull) {
            if (player?.nextDirection == .up) {
                action = actionFP;
            } else if (player?.nextDirection == .down) {
                action = actionBP;
            } else if (player?.nextDirection == .right) {
                action = actionLP;
            } else if (player?.nextDirection == .left) {
                action = actionRP;
            }
        }
        
        if let sprite = character.sprite {
            if (character.action != action) {
                sprite.removeAction(forKey: "Action");
                sprite.run(action, withKey: "Action");
                character.action = action;
            }
            let pos = com.getPointByTilePosition(character.position);
            sprite.position = pos;
        }
    }

    func clear() {
        var scene = self.createImageScene("clear")
        if (self.stage == 16) {
            scene = self.createImageScene("AllClear")
            scene.stage = 1;
            com.playSound(filename: "se_allclear");
        } else {
            scene.stage = self.stage + 1
            com.setMaxStage(stage: scene.stage);
            com.playSound(filename: "se_clear")
        }
        let transition = SKTransition.doorsOpenHorizontal(withDuration: 1.0);
        if let skView = self.view {
            button0.removeFromSuperview();
            scene.scaleMode = SKSceneScaleMode.aspectFit;
            skView.presentScene(scene, transition: transition);
        }
        self.player?.stopMoving()
    }
    
    func createImageScene(_ imageName: String) -> TouchScene {
        let scene = TouchScene(size: self.size)
        let sprite = SKSpriteNode(imageNamed: imageName)
        sprite.size = (scene.size)
        print("scene.size=\(scene.size.width), \(scene.size.height)")
        sprite.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        sprite.zPosition = 200
        scene.scaleMode = .aspectFit;
        scene.addChild(sprite)
        
        return scene
    }
    
    override func didMove(to view: SKView) {
        com.setScene(scene: self)
        self.setup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("began");
        let touch = touches.first as UITouch?
        let touchLocation = touch!.location(in: self)
        
        print("touch:\(touchLocation.x),\(touchLocation.y)")
        
        tx = com.getTilePositionByPointX(touchLocation.x);
        ty = com.getTilePositionByPointY(touchLocation.y);
        print("tx=\(tx), ty=\(ty)");
        
        if let playerLocation = self.player?.sprite?.position {
            let x = touchLocation.x - playerLocation.x
            let y = touchLocation.y - playerLocation.y
            
            var nextDirection: Direction
            var toX: Int = 0;
            var toY: Int = 0;
            if abs(x) > abs(y) {
                nextDirection = x > 0 ? .right : .left
                toX = com.getTilePositionByPointX(touchLocation.x);
                toY = com.getTilePositionByPointY(playerLocation.y);
            } else {
                nextDirection = y > 0 ? .up : .down
                toX = com.getTilePositionByPointX(playerLocation.x);
                toY = com.getTilePositionByPointY(touchLocation.y);
            }
            
            if let player = self.player {
                if player.canRotate(nextDirection) {
                    player.state = .none;
                    player.nextDirection = nextDirection
                    print("(\(toX),\(toY))");
                    player.startMoving(toX:toX, toY:toY)
                }
            }
        }
        
    }
  
    //　ドラッグ時に呼ばれる
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // タッチイベントを取得
        let touchEvent = touches.first!
        
        // ドラッグ前の座標, Swift 1.2 から
        let preDx = touchEvent.previousLocation(in: self.view).x
        let preDy = touchEvent.previousLocation(in: self.view).y
        
        print("tx=\(tx), ty=\(ty), px=\(String(describing: player?.position.x)), py=\(String(describing: player?.position.y))")

        var bx: Int = 0;
        var by: Int = 0;
        var gx: Int = 0;
        var gy: Int = 0;
        
        if (player?.position.x == tx) && ((player?.position.y)! + 1 == ty) {
            // front
            gx = 0;
            gy = 1;
            bx = 0;
            by = -1;
        } else if (player?.position.x == tx) && ((player?.position.y)! - 1 == ty) {
            // back
            gx = 0;
            gy = -1;
            bx = 0;
            by = 1;
        } else if ((player?.position.x)! + 1 == tx) && ((player?.position.y)! == ty) {
            // right
            gx = 1;
            gy = 0;
            bx = -1;
            by = 0;
        } else if ((player?.position.x)! - 1 == tx) && ((player?.position.y)! == ty) {
            // left
            gx = -1;
            gy = 0;
            bx = 1;
            by = 0;
        } else {
            print("out of target")
            return;
        }
        
        let tile = com.tileByPosition(TilePosition(x: tx, y: ty))
        if ((tile?.type != .blue) && (tile?.type != .green) && (tile?.type != .yellow)) {
            print("block unexpected")
            return;
        }
        
        // ドラッグ後の座標
        let newDx = touchEvent.location(in: self.view).x
        let newDy = touchEvent.location(in: self.view).y
        
        // ドラッグしたx座標の移動距離
        let diffx = newDx - preDx
        print("x:\(diffx)")
        
        // ドラッグしたy座標の移動距離
        let diffy = newDy - preDy
        print("y:\(diffy)")
        
        var dx: Int = 0;
        var dy: Int = 0;
        var nextDirection: Direction = .none;
        if (abs(diffx) > abs(diffy)) {
            dy = 0
            if (diffx > 0) {
                dx = 1;
                nextDirection = .right;
            } else {
                dx = -1;
                nextDirection = .left
            }
        } else {
            dx = 0;
            if (diffy > 0) {
                dy = 1;
                nextDirection = .down;
            } else {
                dy = -1;
                nextDirection = .up;
            }
        }
        print("dx=\(dx), dy=\(dy), bx=\(bx), by=\(by), gx=\(gx), gy=\(gy)")

        if ((tile?.type == .green) || (tile?.type == .yellow)) && (gx == dx) && (gy == dy) {
            // push
            let tile2 = com.tileByPosition(TilePosition(x: tx + gx, y: ty + gy));
            if (tile2?.type == .floor) {
//                self.player?.state = .push;
//                self.player?.nextDirection = nextDirection;
//                self.player?.moveto(toX: tx, toY: ty);
                
                print("player->(\(tx), \(ty))")
                com.setTileByPosition(TilePosition(x: tx, y: ty), str: "0", type: .floor);
                print("(\(tx),\(ty))->floor")
                com.setTileByPosition(TilePosition(x: tx + gx, y: ty + gy), str: "2", type: .gray);
                print("(\(tx+gx),\(ty+gy))->gray")
            } else if (tile2?.type == .hole) {
//                self.player?.state = .push;
//                self.player?.nextDirection = nextDirection;
//                self.player?.moveto(toX: tx, toY: ty);
                
                print("player->(\(tx), \(ty))")
                com.setTileByPosition(TilePosition(x: tx, y: ty), str: "0", type: .floor);
                print("(\(tx),\(ty))->floor")
                com.setTileByPosition(TilePosition(x: tx + gx, y: ty + gy), str: "0", type: .floor);
                print("(\(tx+gx),\(ty+gy))->floor")
            } else {
                print("no push");
                return;
            }
            
            self.player?.state = .push;
            self.player?.nextDirection = nextDirection;
            self.player?.moveto(toX: tx, toY: ty);
            com.playSound(filename: "se_move");
            
        } else if ((tile?.type == .blue) || (tile?.type == .yellow)) && (bx == dx) && (by == dy) {
            // pull
            let tile2 = com.tileByPosition(TilePosition(x: tx + bx*2, y: ty + by*2));
            if (tile2?.type == .floor) {
//                self.player?.state = .pull;
//                self.player?.nextDirection = nextDirection;
//                self.player?.moveto(toX: tx+bx*2, toY: ty+by*2);
                print("player->(\(tx+bx*2), \(ty+by*2))")

                com.setTileByPosition(TilePosition(x: tx, y: ty), str: "0", type: .floor);
                print("(\(tx),\(ty))->floor")
                com.setTileByPosition(TilePosition(x: tx + bx, y: ty + by), str: "2", type: .gray);
                print("(\(tx+bx),\(ty+by))->gray")
            } else {
                print("no pull");
                return;
            }

            self.player?.state = .pull;
            self.player?.nextDirection = nextDirection;
            self.player?.moveto(toX: tx+bx*2, toY: ty+by*2);
            com.playSound(filename: "se_move");

        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("End")
    }

    override func update(_ currentTime: TimeInterval) {
    }
    
    func stopped() {
        
    }
}

class TouchScene: SKScene {
    var stage = 0;
    
    override func didMove(to view: SKView) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let transition = SKTransition.doorsCloseHorizontal(withDuration: 1.0)
        
        let scene = GameScene()
        scene.scaleMode = .aspectFill
        scene.size = self.size
        scene.stage = self.stage;
        self.view?.presentScene(scene, transition: transition)
    }

    override func update(_ currentTime: TimeInterval) {
//        print("TouchScene.update()")
    }

}
