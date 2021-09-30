//
//  Cardify.swift
//  lection 1
//
//  Created by Track Ensure on 2021-07-30.
//

import SwiftUI

struct Cardify: AnimatableModifier {
//  var isFaceUp: Bool
  init(isFaceUp: Bool) {
    rotation = isFaceUp ? 0 : 180
  }
  
  var animatableData: Double {
    get { rotation }
    set { rotation = newValue }
  }
  
  var rotation: Double // in degrees
  
  func body(content: Content) -> some View {
    ZStack {
      let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
      if rotation < 90 {
        shape.fill(Color.white)
        shape.stroke(lineWidth: DrawingConstants.linewWidth)
        
        
      } else {
        shape.fill()
      }
      content
        .opacity(rotation < 90 ? 1 : 0)
    }
    .rotation3DEffect(
      .degrees(rotation),
      axis: (x: 0.0, y: 1.0, z: 0.0)
    )
  }
  private struct DrawingConstants {
    static let cornerRadius: CGFloat = 10
    static let linewWidth: CGFloat = 3
  }
}

extension View {
  func cardify(isFaceUp: Bool) -> some View {
    return self.modifier(Cardify(isFaceUp: isFaceUp))
  }
}
