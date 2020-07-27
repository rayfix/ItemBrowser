//
//  ItemBrowserApp.swift
//  ItemBrowser
//
//  Created by Ray Fix on 7/25/20.
//

import SwiftUI

@main
struct ItemBrowserApp: App {
  @StateObject var itemStore = ItemStore()

  var body: some Scene {
    WindowGroup {
      ItemCollectionView()
    }
  }
}
