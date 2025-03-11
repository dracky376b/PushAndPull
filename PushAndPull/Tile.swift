//
//  Tile.swift
//  Push&Pull
//
//  Created by 結城 竜矢 on 2017/06/26.
//  Copyright © 2017年 結城 竜矢. All rights reserved.
//

import Foundation
import SpriteKit

enum TileType: Int {
    case floor, door
    case gray, green, blue, yellow, hole, start
    func canMove() -> Bool {
        return (self == .floor || self == .door)
    }
    func isGoal() -> Bool {
        return (self == .door);
    }
    func inc() -> TileType {
        switch self {
        case .floor:    return .door;
        case .door:     return .gray;
        case .gray:     return .green;
        case .green:    return .blue;
        case .blue:     return .yellow;
        case .yellow:   return .hole;
        case .hole:     return .floor;
        case .start:    return .start;
        }
    }
    func str() -> String {
        switch self {
        case .floor:    return "0";
        case .door:     return "1";
        case .gray:     return "2";
        case .green:    return "3";
        case .blue:     return "4";
        case .yellow:   return "5";
        case .hole:     return "6";
        case .start:    return "7";
        }
    }
}

class Tile : SKSpriteNode {
    var type = TileType.floor
}

enum Direction {
    case none, up, down, left, right
    
    func reverseDirection() -> Direction {
        switch self {
        case .none:     return .none
        case .up:       return .down
        case .down:     return .up
        case .left:     return .right
        case .right:    return .left
        }
    }
}

struct TilePosition {
    var x, y: Int
    
    func movedPosition(_ direction:Direction) -> TilePosition {
        switch direction {
        case .up:       return TilePosition(x: x, y: y-1)
        case .down:     return TilePosition(x: x, y: y+1)
        case .left:     return TilePosition(x: x-1, y: y)
        case .right:    return TilePosition(x: x+1, y: y)
        case .none:     return TilePosition(x: x, y: y)
        }
    }
    
    func isEqual(_ other: TilePosition) -> Bool {
        return self.x == other.x && self.y == other.y
    }
}
