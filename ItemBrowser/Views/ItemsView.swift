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

  var body: some View {
    ItemCollectionView(itemFetchRequest: viewModel.itemFetchRequest(context: context),
                       itemsDisplayMode: $viewModel.itemsDisplayMode)
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
          label: { Image(systemName: "list.bullet")}
          .popover(isPresented: $showPopover,
                   arrowEdge: .top) {
            List {
              Section {
              Button { showPopover = false } label: {
                Label("Icons", systemImage: "square.grid.2x2")
              }
              Button { showPopover = false } label: {
                Label("List", systemImage: "list.bullet")
              }
              }
              Section(header: Text("")) {
              Button { } label: {
                Label("Icons", systemImage: "square.grid.2x2")
              }
              Button { } label: {
                Label("List", systemImage: "list.bullet")
              }
              }
            }
            .frame(width: 200, height: 200)
            .padding()
          }

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
