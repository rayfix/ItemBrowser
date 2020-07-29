//
//  ItemCollectionView.swift
//  ItemBrowser
//
//  Created by Ray Fix on 7/25/20.
//

import SwiftUI
import CoreData

struct ItemsView: View {
  @ObservedObject var viewModel: ItemsViewModel
  @Environment(\.managedObjectContext) var context
  @EnvironmentObject var itemsDisplayMode: ItemsDisplayMode
  
  @State var showPopover = false

  var titleName: String {
    guard let current = viewModel.current else {
      return "Items"
    }
    switch current.kind {
    case .root:
      return "Items"
    case .trash:
      return "Recently Deleted"
    case .folder, .bundle, .regular:
      return current.name
    }
  }

  var displayModeStyleIconName: String {
    switch itemsDisplayMode.style {
    case .icons:
      return "square.grid.2x2"
    case .list:
      return "list.bullet"
    }
  }

  var body: some View {
    ItemCollectionView(itemFetchRequest:
                        viewModel.itemFetchRequest(context: context,
                            sortDescriptors: itemsDisplayMode.sortDescriptors))
      .animation(.default)
      .navigationBarTitle(titleName , displayMode: .inline)
      .navigationBarItems(trailing: HStack(spacing: 40) {
        if viewModel.current != nil {
          Button { viewModel.newDocument(context: context) }
            label: { Image(systemName: "doc.text") }
          Button { viewModel.newFolder(context: context) }
            label: { Image(systemName: "folder.badge.plus") }
        }
        Button { self.showPopover = true }
          label: { Image(systemName: displayModeStyleIconName)}
          .popover(isPresented: $showPopover,
                   arrowEdge: .top) {
            ItemsDisplayModeSelectorView {
              showPopover = false
            }
            .environmentObject(itemsDisplayMode)
            .frame(width: 200, height: 240).padding()
          }

          .padding()        
        Button { print("select") }
          label: { Text("Select")}
      }.font(.title3))
      .sheet(isPresented: $viewModel.isPresentingError) {
        Text(viewModel.errorMessage)
      }
  }
}

struct ItemCollectionView_Previews: PreviewProvider {
  static var previews: some View {
    ItemsView(viewModel: ItemsViewModel())
  }
}
