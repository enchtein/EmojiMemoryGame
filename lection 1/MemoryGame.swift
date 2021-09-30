//
//  MemoryGame.swift
//  lection 1
//
//  Created by Track Ensure on 2021-07-23.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
  private (set) var cards: Array<Card>
  private var firstFaceUpCardIndex: Int? {
    get { cards.indices.filter({ self.cards[$0].isFaceUp }).oneAndOnly }
    set { cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) } }
  }
  
  
  var cardTheme: Theme
  var score: Int = 0
  
  mutating func choose(card: Card) {
    if let choosenIndex = self.cards.firstIndex(where: { $0.id == card.id }),
       !cards[choosenIndex].isFaceUp,
       !cards[choosenIndex].isMatched
    {
      if let potentionalMatchingIndex = self.firstFaceUpCardIndex {
        if cards[choosenIndex].content == cards[potentionalMatchingIndex].content {
          cards[choosenIndex].isMatched = true
          cards[potentionalMatchingIndex].isMatched = true
          
          self.score += 2
        } else {
          self.score -= 1
        }
        cards[choosenIndex].isFaceUp = true
      } else {
        firstFaceUpCardIndex = choosenIndex
      }
      print("card choosen: \(card)")
      
    }
    self.cards.removeAll(where: {$0.isMatched})
  }
  
  mutating func shuffle() {
    self.cards.shuffle()
  }
  
  init(numberOfPairsOfCards: Int, theme: Theme, cardContentFactory: (Int) -> CardContent) {
    cardTheme = theme
    self.cards = Array<Card>()
    
    for pairIndex in 0..<numberOfPairsOfCards {
      let content = cardContentFactory(pairIndex)
      cards.append(Card(content: content, id: pairIndex * 2))
      cards.append(Card(content: content, id: pairIndex * 2 + 1))
    }
    
    self.cards.shuffle()
  }
  
  struct Card: Identifiable {
      var isFaceUp = false {
          didSet {
              if isFaceUp {
                  startUsingBonusTime()
              } else {
                  stopUsingBonusTime()
              }
          }
      }
      var isMatched = false {
          didSet {
              stopUsingBonusTime()
          }
      }
      let content: CardContent
      let id: Int
      
      // MARK: - Bonus Time
      
      // this could give matching bonus points
      // if the user matches the card
      // before a certain amount of time passes during which the card is face up
      
      // can be zero which means "no bonus available" for this card
      var bonusTimeLimit: TimeInterval = 6
      
      // how long this card has ever been face up
      private var faceUpTime: TimeInterval {
          if let lastFaceUpDate = self.lastFaceUpDate {
              return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
          } else {
              return pastFaceUpTime
          }
      }
      // the last time this card was turned face up (and is still face up)
      var lastFaceUpDate: Date?
      // the accumulated time this card has been face up in the past
      // (i.e. not including the current time it's been face up if it is currently so)
      var pastFaceUpTime: TimeInterval = 0
      
      // how much time left before the bonus opportunity runs out
      var bonusTimeRemaining: TimeInterval {
          max(0, bonusTimeLimit - faceUpTime)
      }
      // percentage of the bonus time remaining
      var bonusRemaining: Double {
          (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
      }
      // whether the card was matched during the bonus time period
      var hasEarnedBonus: Bool {
          isMatched && bonusTimeRemaining > 0
      }
      // whether we are currently face up, unmatched and have not yet used up the bonus window
      var isConsumingBonusTime: Bool {
          isFaceUp && !isMatched && bonusTimeRemaining > 0
      }
      
      // called when the card transitions to face up state
      private mutating func startUsingBonusTime() {
          if isConsumingBonusTime, lastFaceUpDate == nil {
              lastFaceUpDate = Date()
          }
      }
      // called when the card goes back face down (or gets matched)
      private mutating func stopUsingBonusTime() {
          pastFaceUpTime = faceUpTime
          self.lastFaceUpDate = nil
      }
  }
}


extension Array {
  var oneAndOnly: Element? {
    if count == 1 {
      return first
    } else {
      return nil
    }
  }
}
