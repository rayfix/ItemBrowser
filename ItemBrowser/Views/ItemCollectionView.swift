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
  @Binding var itemsDisplayMode: ItemsDisplayMode

  init(itemFetchRequest: NSFetchRequest<Item>,
       itemsDisplayMode: Binding<ItemsDisplayMode>) {
    _items = FetchRequest(fetchRequest: itemFetchRequest)
    _itemsDisplayMode = itemsDisplayMode
  }

  func folderDestination(item: Item) -> some View {
    ItemsView(viewModel: ItemsViewModel(item))
  }

  var body: some View {
    if itemsDisplayMode.style == .list {
      List {
        ForEach(items) { item in
          if item.kind == .folder {
            NavigationLink(destination: folderDestination(item: item)) {
              ItemListEntry(item: item)
                .contextMenu {
                  Button { } label: { Text("Hello") }
                }
            }
          } else {
            ZStack { // Supress >
              ItemListEntry(item: item)
            }
          }
        }
      }
      Text("\(items.count) items").bold()
    }
    else {
      ScrollView {
        LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 180, maximum: 180))]) {
          ForEach(items) { item in
            if item.kind == .folder {
              NavigationLink(
                destination: folderDestination(item: item)) {
                ItemGridEntry(item: item)
              }
            }
            else {
              ItemGridEntry(item: item)
            }
          }
        }
      }
    }
  }
}


