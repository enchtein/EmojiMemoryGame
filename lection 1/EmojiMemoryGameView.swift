//
//  EmojiMemoryGameView.swift
//  lection 1
//
//  Created by Track Ensure on 2021-07-22.
//

import SwiftUI

struct EmojiMemoryGameView: View {
  @ObservedObject var viewModel: EmojiMemoryGame
  @Namespace private var dealingNamespace
  
  var body: some View {
//    Text(viewModel.cardTheme.rawValue)
    NavigationView {
      ZStack(alignment: .bottom) {
        VStack {
          gameBody
          
          HStack {
            restart
            Spacer()
            shuffle
          }
          .padding(.horizontal)
          
        }
        deckBody
      }
    }
    
//    .navigationTitle("\(viewModel.cardTheme.rawValue)")
    .navigationBarTitle(Text(viewModel.cardTheme.rawValue), displayMode: .inline)
    
    .padding()
    
  }
  
  @State private var dealt = Set<Int>()
  private func deal(_ card: EmojiMemoryGame.Card) {
    dealt.insert(card.id)
  }
  private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
    return !dealt.contains(card.id)
  }
  private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
    var delay = 0.0
    if let index = viewModel.cards.firstIndex(where: {$0.id == card.id}) {
      delay = Double(index) * (CardConstants.totalDealDuration / Double(viewModel.cards.count))
    }
    
    return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
  }
  private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
    return -Double(viewModel.cards.firstIndex(where: {$0.id == card.id}) ?? 0)
  }
  
  var gameBody: some View {
    let themeColor = viewModel.cardTheme.cardsBackoground
    return AspectVGrid(items: viewModel.cards, aspectRatio: 2/3, content: { card in
      if isUndealt(card) || card.isMatched && !card.isFaceUp {
        //        Rectangle().opacity(0)
        Color.clear
      } else {
        CardView(card: card)
          .matchedGeometryEffect(id: card.id, in: dealingNamespace)
          .padding(4)
          .transition(.asymmetric(insertion: .identity, removal: .scale))
          .zIndex(zIndex(of: card))
          .onTapGesture(perform: {
            withAnimation {
              viewModel.choose(card: card)
            }
            
          })
      }
    })
    .foregroundColor(themeColor)
  }
  
  var deckBody: some View {
    ZStack {
      ForEach(viewModel.cards.filter(isUndealt)) { card in
        CardView(card: card)
          .matchedGeometryEffect(id: card.id, in: dealingNamespace)
          .transition(.asymmetric(insertion: .scale, removal: .identity))
          .zIndex(zIndex(of: card))
      }
    }
    .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
    .foregroundColor(CardConstants.color)
    .onTapGesture {
      // "deal" cards
      for card in viewModel.cards {
        withAnimation(dealAnimation(for: card)) {
          deal(card)
        }
      }
    }
  }
  
  var shuffle: some View {
    Button("Shuffle") {
      withAnimation {
        viewModel.shuffle()
      }
    }
  }
  var restart: some View {
    Button("Restart") {
      withAnimation {
        dealt = []
        viewModel.restart()
      }
    }
  }
  
  private struct CardConstants {
    static let color = Color.red
    static let aspectRation: CGFloat = 2/3
    static let dealDuration: Double = 0.5
    static let totalDealDuration: Double = 2
    static let undealtHeight: CGFloat = 90
    static let undealtWidth = undealtHeight * aspectRation
  }
}

struct CardView: View {
  let card: EmojiMemoryGame.Card
  
  @State private var animatedBonusRemaning: Double = 0
  
  var body: some View {
    GeometryReader(content: { geometry in
      ZStack {
        Group {
          if card.isConsumingBonusTime {
            Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedBonusRemaning)*360-90))
              .onAppear {
                animatedBonusRemaning = card.bonusRemaining
                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                  animatedBonusRemaning = 0
                }
              }
          } else {
            Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-card.bonusRemaining)*360-90))
          }
        }
        .padding(5)
        .opacity(0.5)
        Text(card.content)
          .rotationEffect(.degrees(card.isMatched ? 360 : 0))
          .animation(.linear(duration: 1).repeatForever(autoreverses: false))
          .font(Font.system(size: DrawingConstants.fontSize))
          .scaleEffect(scale(thatFits: geometry.size))
      }
      .cardify(isFaceUp: card.isFaceUp)
    })
  }
  
  private func scale(thatFits size: CGSize) -> CGFloat {
    min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
  }
  
  private struct DrawingConstants {
    static let fontScale: CGFloat = 0.7
    static let fontSize: CGFloat = 32
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    let game = EmojiMemoryGame(theme: .helloween)
    game.choose(card: game.cards.first!)
    return EmojiMemoryGameView(viewModel: game)
  }
}
