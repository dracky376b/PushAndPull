//
//  EditScene.swift
//  Push&Pull
//
//  Created by 結城 竜矢 on 2017/07/05.
//  Copyright © 2017年 結城 竜矢. All rights reserved.
//

import Foundation
import SpriteKit

class EditScene: SKScene, CharacterDelegate {
    var com = Common();
    var cursol: Cursol?
    var player: SKSpriteNode?
    var myWindow: UIWindow = UIWindow()
    
    var scoreLabel: SKLabelNode?
    var stage = 1
    
    var tx: Int = 0;
    var ty: Int = 0;

    var button0 = UIButton.init(type: UIButtonType.custom);
    var button1 = UIButton.init(type: UIButtonType.custom);
    var button2 = UIButton.init(type: UIButtonType.custom);
    var button3 = UIButton.init(type: UIButtonType.custom);
    var button4 = UIButton.init(type: UIButtonType.custom);
    var button5 = UIButton.init(type: UIButtonType.custom);

    func tileByPosition(_ position: TilePosition) -> Tile? {
        return com.tileByPosition(position)
    }
    
    func drawMap() {
        if let fileName = Bundle.main.path(forResource: "map_edit", ofType: "csv") {
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
        myWindow.frame = CGRect(x:0, y:0, width:200, height:300);
        myWindow.layer.position = CGPoint(x: 100, y: 150);
        myWindow.alpha = 1.0;
        myWindow.layer.cornerRadius = 20;
        
        // myWindowをkeyWindowにする.
        myWindow.makeKey()
        
        // windowを表示する.
        self.myWindow.makeKeyAndVisible()
        
        // ボタンを作成する.
        button1.frame = CGRect(x:0, y:0, width:100, height:40);
        button1.backgroundColor = UIColor.orange;
        button1.setTitle("Play", for: UIControlState.normal);
        button1.setTitleColor(UIColor.white, for: UIControlState.normal);
        button1.layer.masksToBounds = true;
        button1.layer.cornerRadius = 20.0;
        button1.layer.position = CGPoint(x: 100, y: 50)
        button1.addTarget(self, action: #selector(onClickPlay), for: .touchUpInside);
        self.myWindow.addSubview(button1);
        
        button2.frame = CGRect(x:0, y:0, width:100, height:40);
        button2.backgroundColor = UIColor.orange;
        button2.setTitle("Save", for: UIControlState.normal);
        button2.setTitleColor(UIColor.white, for: UIControlState.normal);
        button2.layer.masksToBounds = true;
        button2.layer.cornerRadius = 20.0;
        button2.layer.position = CGPoint(x: 100, y: 100)
        button2.addTarget(self, action: #selector(onClickSave), for: .touchUpInside);
        self.myWindow.addSubview(button2);
        
        button3.frame = CGRect(x:0, y:0, width:100, height:40);
        button3.backgroundColor = UIColor.orange;
        button3.setTitle("Start Pos", for: UIControlState.normal);
        button3.setTitleColor(UIColor.white, for: UIControlState.normal);
        button3.layer.masksToBounds = true;
        button3.layer.cornerRadius = 20.0;
        button3.layer.position = CGPoint(x: 100, y: 150)
        button3.addTarget(self, action: #selector(onClickStartPosition), for: .touchUpInside);
        self.myWindow.addSubview(button3);

        button4.frame = CGRect(x:0, y:0, width:100, height:40);
        button4.backgroundColor = UIColor.orange;
        button4.setTitle("Go to Title", for: UIControlState.normal);
        button4.setTitleColor(UIColor.white, for: UIControlState.normal);
        button4.layer.masksToBounds = true;
        button4.layer.cornerRadius = 20.0;
        button4.layer.position = CGPoint(x: 100, y: 200)
        button4.addTarget(self, action: #selector(onClickTitle), for: .touchUpInside);
        self.myWindow.addSubview(button4);

        button5.frame = CGRect(x:0, y:0, width:100, height:40);
        button5.backgroundColor = UIColor.orange;
        button5.setTitle("Cancel", for: UIControlState.normal);
        button5.setTitleColor(UIColor.white, for: UIControlState.normal);
        button5.layer.masksToBounds = true;
        button5.layer.cornerRadius = 20.0;
        button5.layer.position = CGPoint(x: 100, y: 250)
        button5.addTarget(self, action: #selector(onClickCancel), for: .touchUpInside);
        self.myWindow.addSubview(button5);
    }
    
    @objc func onClickCancel() {
        self.myWindow.isHidden = true;
    }
    
    @objc func onClickTitle() {
        self.myWindow.isHidden = true;
        let scene = TitleScene()
        scene.size = self.frame.size
        scene.scaleMode = SKSceneScaleMode.aspectFill
        self.view?.presentScene(scene, transition: SKTransition.doorsCloseVertical(withDuration: 1.0))
 
    }
    
    func createPlayer(_ firstPosition: TilePosition) {
        let player1 = SKTexture(imageNamed: "front1")
        player = SKSpriteNode(texture: player1)
        player?.size = CGSize(width: com.tileSize.width, height: com.tileSize.height)
        player?.position = com.getPointByTilePosition(com.startPos)
        player?.zPosition = 100
        self.addChild(player!)

        let cursol1 = SKTexture(imageNamed: "cursol")
        let sprite = SKSpriteNode(texture: cursol1)
        sprite.size = CGSize(width: com.tileSize.width, height: com.tileSize.height)
        sprite.position = com.getPointByTilePosition(firstPosition)
        sprite.zPosition = 100
        self.addChild(sprite)
        
        let cursol = Cursol()
        cursol.delegate = self
        cursol.position = firstPosition
        cursol.sprite = sprite;
        cursol.startMoving(toX: firstPosition.x, toY: firstPosition.y)
        
        self.cursol = cursol
    }
    
    func moveCharacter(_ character: Character) {
        if let sprite = character.sprite {
            let moveAction = SKAction.move(to: com.getPointByTilePosition(character.position), duration: 0.0)
            sprite.run(moveAction)
        }
    }
    
    func moveto(_ character: Character) {
        if let sprite = character.sprite {
            let pos = com.getPointByTilePosition(character.position);
            sprite.position = pos;
        }
    }
    
    func updateTileByPosition(_ position: TilePosition) {
        let index = position.y * com.mapWidth + position.x
        if position.x < 1 || position.y < 1 || position.x >= (com.mapWidth-1) || position.y >= (com.mapHeight-1) {
            return
        }
        
        let temp = com.tileMap[index]
        let type = temp.type.inc();
        let tile = Tile(imageNamed: type.str());
        tile.position = temp.position;
        tile.size = com.tileSize
        tile.zPosition = 50
        tile.type = type
        com.tileMap[index] = tile;
        self.addChild(tile)
        temp.removeFromParent()
    }

    func removeFlower(_ position: TilePosition) {
    }
    
    func clear() {
        let scene = self.createImageScene("clear")
        scene.stage = self.stage + 1;
        let transition = SKTransition.doorsOpenHorizontal(withDuration: 1.0);
        self.view?.presentScene(scene, transition: transition);
        self.cursol?.stopMoving()
    }
    
    func createImageScene(_ imageName: String) -> TouchScene {
        let scene = TouchScene(size: self.size)
        let sprite = SKSpriteNode(imageNamed: imageName)
        sprite.size = scene.size
        sprite.position = CGPoint(x: scene.size.width * 0.5, y: scene.size.height * 0.5)
        sprite.zPosition = 100
        scene.addChild(sprite)
        
        return scene
    }
    
    override func didMove(to view: SKView) {
        com.setScene(scene: self)
        let rect = com.getPointByTilePosition(TilePosition(x: 0,y: 0))
        print("rect x=\(rect.x), y=\(rect.y)")
        self.setup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("began");
        let touch = touches.first as UITouch?
        let touchLocation = touch!.location(in: self)
        
        tx = com.getTilePositionByPointX(touchLocation.x);
        ty = com.getTilePositionByPointY(touchLocation.y);
        print("tx=\(tx), ty=\(ty)");
        
        if let playerLocation = self.cursol?.sprite?.position {
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
            
            if (cursol?.position.x == toX && cursol?.position.y == toY) {
                updateTileByPosition((cursol?.position)!)
            } else if let cursol = self.cursol {
                    cursol.state = .none;
                    cursol.nextDirection = nextDirection
                    print("(toX,toY)=(\(toX),\(toY))");
                    cursol.startMoving(toX:toX, toY:toY)
            }
        }
        
    }
    
    //　ドラッグ時に呼ばれる
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("End")
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
    
    @objc func onClickPlay() {
        self.myWindow.isHidden = true;
    }
    
    @objc func onClickSave() {
        // ドキュメントパス
//        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        // 保存するもの
        var fileObject = ""
        for var y in 0..<com.mapHeight {
            for var x in 0..<com.mapWidth {
                let index = x + y * com.mapWidth;
                fileObject.append(com.tileMap[index].type.str());
                if (x != com.mapWidth - 1) {
                    fileObject.append(",");
                }
            }
            if (y != com.mapHeight-1) {
                fileObject.append("\n");
            }
        }
        // ファイル名
        let fileName = "/map.csv"
        // 保存する場所
//        let filePath = documentsPath + fileName
        let filePath = "/Users/tatsuya/map" + fileName
        
        // 保存処理
        do {
            try fileObject.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            // Failed to write file
        }

        self.myWindow.isHidden = true;
    }
    
    @objc func onClickStartPosition() {
        com.setTileByPosition(com.startPos, str: "0", type: .floor);
        com.startPos = (self.cursol?.position)!;
        com.setTileByPosition(com.startPos, str: "0", type: .start);
        player?.position = com.getPointByTilePosition(com.startPos);

        self.myWindow.isHidden = true;
    }
    
    func stopped() {
        
    }
}
