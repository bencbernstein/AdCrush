///
/// Animation.swift
///

import Foundation
import SpriteKit

enum Animation {
  case crush
  
  var action: SKAction {
    switch self {
    case .crush:
      return crush
    }
  }
}

private typealias CrushAction = Animation
extension CrushAction {
  
  func shrink(value: Float) -> Float {
    return value * 0.9
  }
  
  func wiggle(value: Float, dampen: Bool = false) -> Float {
    return value + randomBetween(-0.02, and: 0.02) * (dampen ? value : 1)
  }
  
  func shrinkAndWiggle(value: Float, dampen: Bool = false) -> Float {
    return wiggle(value: shrink(value: value), dampen: dampen)
  }
  
  var crush: SKAction {
    
    let length: Float = 0.5
    let iterations: Float = 30
    let times: [NSNumber] = (0..<Int(iterations)).map({ Float($0) * (length / iterations) }).map { NSNumber(value: $0) }
    
    var source = [
      float2(0, 0), float2(0.25, 0), float2(0.5, 0), float2(0.75, 0), float2(1, 0),
      float2(0, 0.25), float2(0.25, 0.25), float2(0.5, 0.25), float2(0.75, 0.25), float2(1, 0.25),
      float2(0, 0.5), float2(0.25, 0.5), float2(0.5, 0.5), float2(0.75, 0.5), float2(1, 0.5),
      float2(0, 0.75), float2(0.25, 0.75), float2(0.5, 0.75), float2(0.75, 0.75), float2(1, 0.75),
      float2(0, 1), float2(0.25, 1), float2(0.5, 1), float2(0.75, 1), float2(1, 1)
    ]
    
    func shiftVector(_ vector: float2) -> float2 {
      return float2(wiggle(value: vector.x), shrinkAndWiggle(value: vector.y, dampen: true))
    }
    
    let warpgrids: [SKWarpGeometry] = times.reduce([]) { (geometries, _) in
      let destination = source.map(shiftVector)
      let geometry = SKWarpGeometryGrid(columns: 4, rows: 4, sourcePositions: source, destinationPositions: destination)
      source = destination
      return geometries + [geometry]
    }

    return SKAction.animate(withWarps: warpgrids, times: times)!
  }
}