//
//  ItemsDisplayModeSelectorView.swift
//  ItemBrowser
//
//  Created by Ray Fix on 7/29/20.
//

import SwiftUI

struct ItemsDisplayModeSelectorView: View {
  
  @Binding var itemsDisplayMode: ItemsDisplayMode
  let completion: () -> ()
  
  var body: some View {
    ZStack {
      
      VStack(alignment: .leading) {
        Button {
          itemsDisplayMode.style = .icons
          completion()
        } label: {
            HStack {
              if itemsDisplayMode.style == .icons {
                Image(systemName: "checkmark").frame(width: 30, height: 30)
              } else {
                Color.clear.frame(width: 30, height: 30)
              }
              Text("Icons").foregroundColor(.black)
              Spacer()
              Image(systemName: "square.grid.2x2")
            }
          }.foregroundColor(.black)
        Color.gray.frame(height: 1)
        Button {
          itemsDisplayMode.style = .list
          completion()
        } label: {
            HStack {
              if itemsDisplayMode.style == .list {
                Image(systemName: "checkmark").frame(width: 30, height: 30)
              } else {
                Color.clear.frame(width: 30, height: 30)
              }
              Text("List").foregroundColor(.black)
              Spacer()
              Image(systemName: "list.bullet")
            }
          }.foregroundColor(.black)
        Color.gray.frame(height: 5)
        ForEach(Item.Sorting.allCases, id: \.self) { sorting in
          Button {
            if itemsDisplayMode.sorting == sorting {
              itemsDisplayMode.ascending.toggle()
            }
            else {
              itemsDisplayMode.sorting = sorting
              itemsDisplayMode.ascending = true
            }
            completion()
          }
          label: {
            HStack {
              if itemsDisplayMode.sorting == sorting {
                Image(systemName: "checkmark").frame(width: 30, height: 30)
                Text(sorting.rawValue.localizedCapitalized).foregroundColor(.black)
                Spacer()
                Image(systemName: itemsDisplayMode.ascending ?
                        "chevron.down":"chevron.up")
                  .frame(width: 30, height: 30)
                
              } else {
                Color.clear.frame(width: 30, height: 30)
                Text(sorting.rawValue.localizedCapitalized).foregroundColor(.black)
                Spacer()
                Color.clear.frame(width: 30, height: 30)
              }
            }
          }.foregroundColor(.black)
          if sorting != .modified {
            Color.gray.frame(height: 1)
          }
        }
      }
    }
  }
}

struct ItemsDisplayModeSelectorView_Previews: PreviewProvider {
  static var previews: some View {
    ItemsDisplayModeSelectorView(itemsDisplayMode: .constant(
                                  ItemsDisplayMode(style: .list,                                                                              sorting: .name, ascending: true)), completion: {})
  }
}
