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

  var body: some View {
    List {
      NavigationLink(destination: EmptyView()) {
        Label("Recents", systemImage: "clock")
      }
      Text("Locations").font(.title3).bold()
      NavigationLink(destination: EmptyView()) {
        Label("This iPad", systemImage: "ipad.landscape")
      }
      NavigationLink(destination: EmptyView()) {
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
