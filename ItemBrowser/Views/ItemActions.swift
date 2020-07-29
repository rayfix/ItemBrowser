//
//  ItemActions.swift
//  ItemBrowser
//
//  Created by Ray Fix on 7/29/20.
//

import SwiftUI
import CoreData

extension View {
  func actions(for item: Item) -> some View {
    contextMenu {
      if item.isInTrash() {
        Button { item.deletePermanently() } label: {
          HStack {
            Text("Delete Permanently")
            Image(systemName: "trash")
          }
        }
        Button { item.restore() } label: {
          HStack {
            Text("Restore")
            Image(systemName: "trash.slash")
          }
        }
      }
      else {
        Button { item.moveToTrash() } label: {
          HStack {
            Text("Delete")
            Image(systemName: "trash")
          }
        }
      }
    }
  }
}
