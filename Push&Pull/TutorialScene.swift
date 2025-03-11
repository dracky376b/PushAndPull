//
//  TutorialScene.swift
//  Push&Pull
//
//  Created by 結城 竜矢 on 2017/07/07.
//  Copyright © 2017年 結城 竜矢. All rights reserved.
//

import SpriteKit

struct Ope {
    var x, y: Int
    var b: Bool
}

class TutorialScene: SKScene, CharacterDelegate {
    
    var com: Common = Common();
    
    var myWindow: UIWindow!;
    var myImageView: UIImageView!;
    var myWindowButtonNext: UIButton!;
    var myTextTitle: UITextView!;
    var myTextView: UITextView!;
    
    var myLabel: UILabel = UILabel(frame: CGRect(x:0, y:0, width:200, height:25))
    var player: Player?
    
    var scoreLabel: SKLabelNode?
    var stage = 1
    
    var tx: Int = 0;
    var ty: Int = 0;
    
    var actionF: SKAction = SKAction.init();
    var actionB: SKAction = SKAction.init();
    var actionR: SKAction = SKAction.init();
    var actionL: SKAction = SKAction.init();
    var actionFP: SKAction = SKAction.init();
    var actionBP: SKAction = SKAction.init();
    var actionRP: SKAction = SKAction.init();
    var actionLP: SKAction = SKAction.init();
    
    var touchOpe: [Ope] =
        [Ope(x: 5, y: 2, b: false),     // floor
         Ope(x: 6, y: 2, b: true),      // green block
         Ope(x: 7, y: 2, b: false),
         Ope(x: 6, y: 2, b: false),     // move
         Ope(x: 6, y: 3, b: true),      // blue block
         Ope(x: 6, y: 2, b: false),
         Ope(x: 8, y: 1, b: false),     // move
         Ope(x: 9, y: 1, b: true),      // yellow block
         Ope(x:10, y: 1, b: false),
         Ope(x: 9, y: 1, b: false),     // move
         Ope(x: 9, y: 2, b: true),      // hole
         Ope(x: 9, y: 3, b: false),
         Ope(x:11, y: 2, b: false)      // door
         ]
    var images: [String] = ["0", "3", "", "3", "4", "", "4", "5", "", "5", "6", "", "1", "1"]
    var titles: [String] = ["Floor", "Green Block", "", "Green Block", "Blue Block", "", "Blue Block", "Yellow Block", "", "Yellow Block", "Hole", "", "Door", "Door"]
    
    var touchIndex: Int = 0
    var touchCursol: SKSpriteNode!

    func tileByPosition(_ position: TilePosition) -> Tile? {
        return com.tileByPosition(position)
    }
    
    func drawMap() {
        if let fileName = Bundle.main.path(forResource: "map_tutorial", ofType: "csv") {
            com.loadMapData(fileName)
        }
        
        
        for tile in com.tileMap {
            self.addChild(tile)
        }
    }
    
    func setup() {
        self.scene?.backgroundColor = UIColor.gray
        
        myWindow = UIWindow()
        myWindowButtonNext = UIButton(type: UIButtonType.custom)
        
        // 背景を白に設定する.
        myWindow.backgroundColor = UIColor.white
        myWindow.frame = CGRect(x: 0, y: 0, width: (self.view?.frame.width)! - 40, height: (self.view?.frame.height)!/2)
        myWindow.layer.position = CGPoint(x: (self.view?.frame.width)!/2, y: (self.view?.frame.height)!*3/4)
        myWindow.alpha = 1.0
        myWindow.layer.cornerRadius = 20
        
        // myWindowをkeyWindowにする.
        myWindow.makeKey()
        
        // windowを表示する.
        self.myWindow.makeKeyAndVisible()
        
        // ボタンを作成する.
        myWindowButtonNext.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
        myWindowButtonNext.backgroundColor = UIColor.orange
        myWindowButtonNext.setTitle("Next", for: .normal)
        myWindowButtonNext.setTitleColor(UIColor.white, for: .normal)
        myWindowButtonNext.layer.masksToBounds = true
        myWindowButtonNext.layer.cornerRadius = 20.0
        myWindowButtonNext.layer.position = CGPoint(x: self.myWindow.frame.width - 50, y: self.myWindow.frame.height - 20)
        myWindowButtonNext.addTarget(self, action: #selector(TutorialScene.onClickButtonNext), for: .touchUpInside)
        self.myWindow.addSubview(myWindowButtonNext)
        
        myImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 32, height: 32));
        myImageView.image = UIImage(named: "0");
        self.myWindow.addSubview(myImageView)

        // TextViewを作成する.
        myTextTitle = UITextView(frame: CGRect(x: 50, y: 10, width: self.myWindow.frame.width - 250, height: 40))
        myTextTitle.backgroundColor = UIColor.lightGray
        myTextTitle.text = "Floor"
        myTextTitle.font = UIFont.systemFont(ofSize: CGFloat(15))
        myTextTitle.textColor = UIColor.black
        myTextTitle.textAlignment = NSTextAlignment.left
        myTextTitle.isEditable = false
        self.myWindow.addSubview(myTextTitle)
        
        myTextView = UITextView(frame: CGRect(x: 10, y: 60, width: self.myWindow.frame.width - 100, height: 90))
        myTextView.backgroundColor = UIColor.clear
        myTextView.text = NSLocalizedString("msg0", comment: "")
        myTextView.font = UIFont.systemFont(ofSize: CGFloat(15))
        myTextView.textColor = UIColor.black
        myTextView.textAlignment = NSTextAlignment.left
        myTextView.isEditable = false
        
        self.myWindow.addSubview(myTextView)

        self.drawMap()
        self.createPlayer(com.startPos)
    }
    
    func createPlayer(_ firstPosition: TilePosition) {
        let cursol1 = SKTexture(imageNamed: "Yubi")
        touchCursol = SKSpriteNode(texture: cursol1)
        touchCursol.size = CGSize(width: com.tileSize.width, height: com.tileSize.height)
        let pos = com.getPointByTilePosition(firstPosition)
        touchCursol.position = CGPoint(x: pos.x, y: pos.y - com.tileSize.height / 2)
        touchCursol.zPosition = 200
        self.addChild(touchCursol)

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
        self.player?.stopMoving()
    }
    
    func createImageScene(_ imageName: String) -> TouchScene {
        let scene = TouchScene(fileNamed: "TouchScene")
        let sprite = SKSpriteNode(imageNamed: imageName)
        sprite.size = (scene?.size)!
        print("scene.size=\(scene?.size.width), \(scene?.size.height)")
        sprite.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        sprite.zPosition = 200
        scene?.scaleMode = .aspectFill;
        scene?.addChild(sprite)
        
        return scene!
    }
    
    override func didMove(to view: SKView) {
        com.setScene(scene: self)
        self.setup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("began");
    }
    
    @objc func onClickButtonNext() {
        if (touchIndex > 12) {
            myWindow.isHidden = true;
            
            let scene = TitleScene()
            scene.size = self.frame.size
            scene.scaleMode = SKSceneScaleMode.aspectFill
            self.view?.presentScene(scene, transition: SKTransition.doorsCloseVertical(withDuration: 1.0))
            return;
        }
        
        let point: Ope = touchOpe[touchIndex]
        touchIndex += 1
        if point.b {
            tx = point.x;
            ty = point.y;
            let point2 = touchOpe[touchIndex]
            touchIndex += 1
            moveBlock(px: point2.x, py: point2.y)
        } else {
            touchPoint(toX: point.x, toY: point.y);
        }
        
        myImageView.image = UIImage(named: images[touchIndex])
        myTextTitle.text = titles[touchIndex]
        myTextView.text = NSLocalizedString("msg" + String(touchIndex), comment: "")

    }
    
    func touchPoint(toX: Int, toY:Int) {
        tx = toX;
        ty = toY;
        
        let pos = com.getPointByTilePosition(TilePosition(x: tx, y: ty))
        touchCursol.position = CGPoint(x: pos.x, y: pos.y - com.tileSize.height / 2)

        if let playerLocation = player?.position {
            let x = toX - playerLocation.x
            let y = toY - playerLocation.y
            
            if (x == 0 && y == 0) {
                return
            }
            
            var nextDirection: Direction
            if abs(x) > abs(y) {
                nextDirection = x > 0 ? .right : .left
            } else {
                nextDirection = y > 0 ? .up : .down
            }
            
            print("(\(toX),\(toY), \(nextDirection))");
            if let player = self.player {
                if player.canRotate(nextDirection) {
                    player.state = .none;
                    player.nextDirection = nextDirection
//                    myWindowButtonNext.isEnabled = false;
                    player.startMoving(toX:toX, toY:toY)
                }
            }
        }
        
    }
    
    //　ドラッグ時に呼ばれる
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // タッチイベントを取得
    }
    
    func moveBlock(px: Int, py:Int) {
        // ドラッグ前の座標, Swift 1.2 から
        let pos = com.getPointByTilePosition(TilePosition(x: tx, y: ty))
        touchCursol.position = CGPoint(x: pos.x, y: pos.y - com.tileSize.height / 2)
//        Thread.sleep(forTimeInterval: 1.0);
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            self.moveBlock2(px: px, py: py)
        }
    }
    
    func moveBlock2(px: Int, py: Int) {
        let pos = com.getPointByTilePosition(TilePosition(x: px, y: py))
        touchCursol.position = CGPoint(x: pos.x, y: pos.y - com.tileSize.height / 2)
        
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
        
        let tile = tileByPosition(TilePosition(x: tx, y: ty))
        if ((tile?.type != .blue) && (tile?.type != .green) && (tile?.type != .yellow)) {
            print("block unexpected")
            return;
        }
        
        // ドラッグしたx座標の移動距離
        let diffx = px - tx
        print("x:\(diffx)")
        
        // ドラッグしたy座標の移動距離
        let diffy = py - ty
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
            let tile2 = tileByPosition(TilePosition(x: tx + gx, y: ty + gy));
            if (tile2?.type == .floor) {
                print("player->(\(tx), \(ty))")
                com.setTileByPosition(TilePosition(x: tx, y: ty), str: "0", type: .floor);
                print("(\(tx),\(ty))->floor")
                com.setTileByPosition(TilePosition(x: tx + gx, y: ty + gy), str: "2", type: .gray);
                print("(\(tx+gx),\(ty+gy))->gray")
            } else if (tile2?.type == .hole) {
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
//            myWindowButtonNext.isEnabled = false;
            self.player?.moveto(toX: tx, toY: ty);
            
        } else if ((tile?.type == .blue) || (tile?.type == .yellow)) && (bx == dx) && (by == dy) {
            // pull
            let tile2 = tileByPosition(TilePosition(x: tx + bx*2, y: ty + by*2));
            if (tile2?.type == .floor) {
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
//            myWindowButtonNext.isEnabled = false;
            self.player?.moveto(toX: tx+bx*2, toY: ty+by*2);
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("End")
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
    
    func stopped() {
//        myWindowButtonNext.isEnabled = true;
    }
}
