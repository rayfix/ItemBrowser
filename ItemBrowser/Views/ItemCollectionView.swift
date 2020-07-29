//
//  ItemCollectionView.swift
//  ItemBrowser
//
//  Created by Ray Fix on 7/29/20.
//

import SwiftUI
import CoreData

struct ItemCollectionView: View {
  @FetchRequest var items: FetchedResults<Item>
  @EnvironmentObject var itemsDisplayMode: ItemsDisplayMode

  init(itemFetchRequest: NSFetchRequest<Item>) {
    _items = FetchRequest(fetchRequest: itemFetchRequest)
  }

  func folderDestination(item: Item) -> some View {
    ItemsView(viewModel: ItemsViewModel(item))
  }

  var body: some View {
    if itemsDisplayMode.style == .list {
      List {
        ForEach(items) { item in
          Group {
            if item.kind == .folder {
              NavigationLink(destination: folderDestination(item: item)) {
                ItemListEntry(item: item)
              }
            } else {
              ZStack { // Supress >
                ItemListEntry(item: item)
              }
            }
          }.actions(for: item)
        }
      }
      Text("\(items.count) items").bold()
    }
    else {
      ScrollView {
        LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 180, maximum: 180))]) {
          ForEach(items) { item in
            Group {
              if item.kind == .folder {
                NavigationLink(
                  destination: folderDestination(item: item)) {
                  ItemGridEntry(item: item)
                }
              }
              else {
                ItemGridEntry(item: item)
              }
            }.actions(for: item)
          }
        }
      }
    }
  }
}


