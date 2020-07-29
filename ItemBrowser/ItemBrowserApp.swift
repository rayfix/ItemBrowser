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

  var body: some Scene {
    WindowGroup {
      NavigationView {
        BrowserSidebar().navigationTitle(itemsViewModel.name ?? "Items")
        ItemsView(viewModel: itemsViewModel).toolbar { }
      }.environment(\.managedObjectContext, itemStore.viewContext)
    }
  }
}
