//
//  ItemBrowserApp.swift
//  ItemBrowser
//
//  Created by Ray Fix on 7/25/20.
//

import SwiftUI
import CoreData

@main
struct ItemBrowserApp: App {
  @StateObject var itemStore = ItemStore()
  @StateObject var itemsViewModel = ItemsViewModel()
  @StateObject var itemsDisplayMode = ItemsDisplayMode()

  var body: some Scene {
    WindowGroup {
      NavigationView {
        BrowserSidebar().navigationTitle("Items")
        ItemsView(viewModel: itemsViewModel)
      }
      .environment(\.managedObjectContext, itemStore.viewContext)
      .environmentObject(itemsDisplayMode)
    }
  }
}
