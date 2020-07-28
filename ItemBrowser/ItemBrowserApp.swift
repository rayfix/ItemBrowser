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

  var body: some Scene {
    WindowGroup {
      NavigationView {
        BrowserSidebar().navigationTitle("Items")
        ItemCollectionView().toolbar {
          Text("Hello")
        }
      }.environment(\.managedObjectContext, itemStore.persistentContainer.viewContext)
    }
  }
}
