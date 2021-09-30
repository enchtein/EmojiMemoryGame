//
//  ChoseTheme.swift
//  lection 1
//
//  Created by Track Ensure on 2021-08-11.
//

import SwiftUI

struct ChoseTheme: View {
  @State private var editMode: EditMode = .inactive
  @State private var allThemes = Theme.allCases
  
    var body: some View {
      NavigationView {
        VStack {
          Text("Please choose theme for start")
          themeList
        }
        .navigationBarTitle("Welcome", displayMode: .inline)
        .navigationBarItems(trailing: controlButton)
      }
    }
  
  var themeList: some View {
    List {
      ForEach(allThemes, id: \.self) { theme in
        NavigationLink(
          destination: EmojiMemoryGameView(viewModel: EmojiMemoryGame(theme: theme))) {
          RowForList(theme: theme)
        }
      }
      .onDelete { indexSet in
//        store.palettes.remove(atOffsets: indexSet)
        allThemes.remove(atOffsets: indexSet)
      }
      .onMove(perform: { indices, newOffset in
//        store.palettes.move(fromOffsets: indices, toOffset: newOffset)
        allThemes.move(fromOffsets: indices, toOffset: newOffset)
      })
    }
  }

  var controlButton: some View {
    EditButton()
      .contextMenu { contextMenu }
      .environment(\.editMode, $editMode)
    
    
//    Button {
//      print("show menu")
//    } label: {
//      Image(systemName: "pencil")
//    }
//    .contextMenu { contextMenu }
  }
  
  
  @ViewBuilder
  var contextMenu: some View {
    Button {
      print("edit mode")
    } label:  {
      Text("Edit")
    }
  }
}

struct RowForList: View {
  var theme: Theme
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(theme.rawValue)
        .foregroundColor(theme.cardsBackoground)
      Text("Cards count: \(theme.themeNumberOfPairs), \(theme.themeSetOfEmojis.description)")
    }
  }
}






struct ChoseTheme_Previews: PreviewProvider {
    static var previews: some View {
      ChoseTheme()
    }
}
