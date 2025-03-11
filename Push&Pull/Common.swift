//
//  Common.swift
//  Push&Pull
//
//  Created by 結城 竜矢 on 2017/07/17.
//  Copyright © 2017年 結城 竜矢. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class Common {
    var scene: SKScene?;
    var mapWidth = 0
    var mapHeight = 14
    var tileMap = [Tile]()
    var tileSize = CGSize(width: 64.0, height: 64.0)
    var startPos: TilePosition = TilePosition(x:0, y:0)

    var audioPlayer: AVAudioPlayer!

    func playSound(filename: String) {
        // サウンドデータの読み込み。ファイル名は"kane01"。拡張子は"mp3"
        let audioPath = NSURL(fileURLWithPath: Bundle.main.path(forResource: filename, ofType: "mp3")!)
        
        // swift2系からtryでエラー処理するようなので、do〜try〜catchで対応
        do {
            // AVAudioPlayerを作成。もし何かの事情で作成できなかったらエラーがthrowされる
            audioPlayer = try AVAudioPlayer(contentsOf: audioPath as URL)
            
            // イベントを通知したいUIViewControllerをdelegateに登録
            // delegateの登録するならAVAudioPlayerDelegateプロトコルの継承が必要
         //   audioPlayer.delegate = self
            
            // これで再生
            audioPlayer.play()
        }
            // playerを作成した時にエラーがthrowされたらこっち来る
        catch {
            print("AVAudioPlayer error")
        }
    }
    
    func getMaxStage() -> Int {
        if UserDefaults.standard.object(forKey: "Stage") != nil {
            return UserDefaults.standard.integer(forKey: "Stage");
        }
        
        return 1;
    }
    
    func setMaxStage(stage: Int) {
        let maxStage = getMaxStage();
        if (maxStage < stage) {
            UserDefaults.standard.set(stage, forKey: "Stage");
        }
    }
    
    func setScene(scene: SKScene) {
        self.scene = scene;
    }
    
    func getTilePositionByIndex(_ index: Int) -> TilePosition {
        return TilePosition(x: index % self.mapWidth, y: index / self.mapWidth)
    }
    
    func getTilePositionByPointY(_ y: CGFloat) -> Int {
        return (Int((self.scene!.frame.size.height*3/4 - y - self.tileSize.height/2) / self.tileSize.height) + 1);
    }
    
    func getTilePositionByPointX(_ x: CGFloat) -> Int {
        return (Int((x - 0.03) / self.tileSize.width + 0.5));
    }
    
    func getPointByTilePosition(_ position: TilePosition) -> CGPoint {
        let x = CGFloat(position.x) * self.tileSize.width + 0.03
        let y = (self.scene?.frame.height)!*3/4 - CGFloat(position.y) * self.tileSize.height
        print("org=(\(position.x), \(position.y)), new=(\(x), \(y))")
        return CGPoint(x: x, y: y);
    }
    
    func tileByPosition(_ position: TilePosition) -> Tile? {
        let index = position.y * self.mapWidth + position.x
        if position.x < 0 || position.y < 0 || position.x >= self.mapWidth || position.y >= self.mapHeight {
            return nil
        }
        
        return self.tileMap[index]
    }
    
    func setTileByPosition(_ position: TilePosition, str: String, type:TileType) {
        let index = position.y * self.mapWidth + position.x
        if position.x < 0 || position.y < 0 || position.x >= self.mapWidth || position.y >= self.mapHeight {
            return
        }
        
        let temp = self.tileMap[index]
        let tile = Tile(imageNamed: String(describing: str))
        tile.position = temp.position;
        tile.size = self.tileSize
        tile.zPosition = 50
        tile.type = type
        self.tileMap[index] = tile;
        self.scene?.addChild(tile)
        temp.removeFromParent()
    }
    
    func clearTileMap() {
        for var i in 0..<144 {
            self.tileMap[i].removeFromParent();
        }
   
        self.tileMap.removeAll();
    }
    
    func loadMapData(_ fileName: String) {
        //       var error = NSErrorPointer()
        
        let fileString = try? String.init(contentsOfFile: fileName, encoding: String.Encoding.utf8)
        
        let lineList = fileString!.components(separatedBy: "\n")
        self.mapHeight = 9
        
        var index = 0
        
        for line in lineList {
            let tileStringList = line.components(separatedBy: ",")
            
            if self.mapWidth == 0 {
                self.mapWidth = tileStringList.count
                let tileWidth = Double((self.scene?.frame.width)!) / Double(self.mapWidth)
                let tileHeight = Double((self.scene?.frame.height)!) / Double(self.mapHeight)
                self.tileSize = CGSize(width: tileWidth, height: tileWidth)
                print("mapW=\(self.mapWidth), tileW=\(tileWidth), tileH=\(tileHeight)")
            }
            
            for var tileString in tileStringList {
                let value = Int(tileString)
                if var type = TileType(rawValue: value!) {
                    let position = getTilePositionByIndex(index)
                    if (type == .start) {
                        type = .floor;
                        tileString = "0";
                        startPos = position;
                    }
                    let tile = Tile(imageNamed: tileString)
                    tile.position = self.getPointByTilePosition(position)
                    tile.size = self.tileSize
                    tile.zPosition = 50
                    tile.type = type
                    
                    self.tileMap.append(tile)
                    
                }
                
                index += 1
            }
            if (index >= 144) {
                break;
            }
        }
    }
}
