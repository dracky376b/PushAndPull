//
//  Character.swift
//  AkazukinDotEat
//
//  Created by 結城 竜矢 on 2015/09/29.
//  Copyright © 2015年 Tatsuya.Yuuki. All rights reserved.
//

import Foundation
import SpriteKit

protocol CharacterDelegate {
    func moveCharacter(_ character: Character)
    func moveto(_ character: Character)
    func clear()
    func tileByPosition(_ position: TilePosition) -> Tile?
    func stopped()
}

enum State {
    case none, push, pull
}

class Character: NSObject {
    var sprite: SKSpriteNode?
    var action: SKAction = SKAction.init();
    
    var direction = Direction.none
    var nextDirection = Direction.none
    var position = TilePosition(x: 0, y: 0)
    
    var timer: Timer?
    let timerInterval = 0.6
    
    var toX = 0;
    var toY = 0;
    
    var state: State = .none;
    
    var delegate: CharacterDelegate?

    func canMove(_ position: TilePosition) -> Bool {
        if let tile = self.delegate?.tileByPosition(position) {
            return tile.type.canMove()
        }
        
        return false
    }
    
    func isGoal(_ position: TilePosition) -> Bool {
        if let tile = self.delegate?.tileByPosition(position) {
            return tile.type.isGoal();
        }
        
        return false;
    }
    
    func canRotate(_ direction: Direction) -> Bool {
        let position = self.position.movedPosition(direction)
        if let tile = self.delegate?.tileByPosition(position) {
            return tile.type.canMove()
        }
        
        return false
    }
    
    func startMoving(toX: Int, toY: Int) {
        self.toX = toX;
        self.toY = toY;
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(Character.timerTick), userInfo: nil, repeats: true)
        }
    }
    
    func stopMoving() {
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
            delegate?.stopped();
        }
    }
    
    @objc func timerTick() {
        self.move()
    }

    func moveto(toX: Int, toY: Int) {
        self.position.x = toX;
        self.position.y = toY;
        
        delegate?.moveto(self);
    }
    
    func move() {
        if self.isGoal(self.position) {
            self.stopMoving();
            delegate?.clear();
            return;
        }

        if (self.position.x == toX && self.position.y == toY) {
            self.stopMoving();
            return;
        }

        let position = self.position.movedPosition(self.nextDirection)
        
        if self.canMove(position) {
            self.direction = self.nextDirection
            self.position = position
            delegate?.moveCharacter(self)
        } else {
            self.stopMoving()
        }
    }
}
