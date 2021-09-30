//
//  EmojiMemoryGame.swift
//  lection 1
//
//  Created by Track Ensure on 2021-07-23.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
  typealias Card = MemoryGame<String>.Card
  @Published private var model: MemoryGame<String>
  init(theme: Theme) {
    
    model = EmojiMemoryGame.createMemoryGame(theme: theme)
//    self.cardTheme = theme
  }
  
  private static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
//    let theme = Theme.allCases.randomElement() ?? .helloween
    
    let emojis = self.getRandomEmojisArray(with: theme)
    
    let randomCount = 6
//    let randomCount = Int.random(in: 2...emojis.count)
    var randomArray = [String]()
    for int in 0..<randomCount {
      randomArray.append(emojis[int])
    }
    
    return MemoryGame<String>(numberOfPairsOfCards: randomArray.count, theme: theme) {pairIndex in randomArray[pairIndex]}
  }
  
  private static func getRandomEmojisArray(with theme: Theme) -> [String] {
//    let emojis = theme.themeSetOfEmojis
//    let emojis = ["👻", "🎃", "🕷", "👽", "🕸", "⚽️", "🏀", "⚾️", "🥎", "🎾", "🏐", "🏉"]
    let emojis = theme.themeSetOfEmojis
    
    var result = [String]()
    var counter = 0
    
    repeat {
      if let ss = emojis.randomElement(), !result.contains(ss) {
        result.append(ss)
        counter += 1
      }
    } while counter < theme.themeNumberOfPairs
//  } while counter < 5
    
    return result
  }
  
  // MARK: - Access to Model
  var cards: Array<Card> {
    model.cards
  }
  var cardTheme: Theme {
    get {
      model.cardTheme
//      return self
    }
    set {
      if newValue != cardTheme {
//        self.cardTheme = newValue
      model.cardTheme = newValue
        self.restart()
      }
    }
    
  }
  var getScore: Int {
    model.score
  }
  
  // MARK:- Intent(s)
  func choose (card: Card) {
    model.choose(card: card)
  }
  
  func shuffle() {
    model.shuffle()
  }
  
  func restart() {
    model = EmojiMemoryGame.createMemoryGame(theme: self.cardTheme)
  }
}


enum Theme: String, CaseIterable {
  case helloween = "Helloween"
  case newYear = "New Year"
  case summer = "Summer"
  
  var themeNumberOfPairs: Int {
    switch self {
    case .helloween:
//      return 3
    return 8
    case .newYear:
//      return 4
      return 8
    case .summer:
//      return 5
      return 8
    }
  }
  
  var themeSetOfEmojis: [String] {
    switch self {
    case .helloween:
      return ["😈", "👿", "👹", "👺", "👾", "⚰️", "💀", "☠️"]
    case .newYear:
      return ["🎉", "🥳", "🎊", "🤩", "🤪", "😝", "😋", "😛"]
    case .summer:
      return ["⚽️", "🏀", "⚾️", "🥎", "🎾", "🏐", "🏉", "🎱"]
    }
  }
  
  var cardsBackoground: Color {
    switch self {
    
    case .helloween:
      return .gray
    case .newYear:
      return .blue
    case .summer:
      return .yellow
    }
  }
  
  var cases: [Theme] {
    get {
      Theme.allCases
    }
    set {
      
    }
  }
}
