//
//  Cursol.swift
//  Push&Pull
//
//  Created by 結城 竜矢 on 2017/07/05.
//  Copyright © 2017年 結城 竜矢. All rights reserved.
//

import Foundation

class Cursol: Character {
    override func move() {
        if (self.position.x == toX && self.position.y == toY) {
            self.stopMoving();
            return;
        }
        
        let position = self.position.movedPosition(self.nextDirection)
        
        if (position.x < 1 || position.y < 1 || position.x >= 15 || position.y >= 9){
            self.stopMoving()
        } else {
            self.direction = self.nextDirection
            self.position = position
            delegate?.moveCharacter(self)
        }
    }
}
