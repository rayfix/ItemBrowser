//
//  BrowserSidebar.swift
//  ItemBrowser
//
//  Created by Ray Fix on 7/27/20.
//

import SwiftUI
import CoreData

struct BrowserSidebar: View {

  @FetchRequest(entity: Tag.entity(),
                sortDescriptors:
                  [NSSortDescriptor(key: "name_", ascending: true)])
  var tags: FetchedResults<Tag>
  @Environment(\.managedObjectContext) var context


  var recents: some View {
    let model = ItemsViewModel(nil)
    model.searchScope = .global
    return ItemsView(viewModel: model)
  }

  var thisDevice: some View {
    ItemsView(viewModel: ItemsViewModel(Item.root(context: context)))
  }

  var recentlyDeleted: some View {
    ItemsView(viewModel: ItemsViewModel(Item.trash(context: context)))
  }


  var body: some View {
    List {
      NavigationLink(destination: recents) {
        Label("Recents", systemImage: "clock")
      }
      Text("Locations").font(.title3).bold()
      NavigationLink(destination: thisDevice
                      ) {
        Label("This iPad", systemImage: "ipad.landscape")
      }
      NavigationLink(destination: recentlyDeleted) {
        Label("Recently Deleted", systemImage: "trash")
      }
      Text("Favorites").font(.title3).bold()
      NavigationLink(destination: EmptyView()) {
        Label("Imported", systemImage: "arrow.down.circle")
      }
      Text("Tags").font(.title3).bold()

      ForEach(tags) { tag in
        NavigationLink(destination: EmptyView()) {
          Label(tag.name_!, systemImage: "circle.fill").accentColor(tag.color)
        }
      }
    }.listStyle(SidebarListStyle())
  }
}
