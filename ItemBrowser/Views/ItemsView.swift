//
//  ItemCollectionView.swift
//  ItemBrowser
//
//  Created by Ray Fix on 7/25/20.
//

import SwiftUI
import CoreData

enum ItemsDisplayMode {
  case icons, list
}

enum ItemsSeachScope {
  case global, local
}

final class ItemsViewModel: ObservableObject {

  @Published var searchScope = ItemsSeachScope.local
  @Published var current: Item?
  @Published var name: String?
  @Published var tag: Tag?
  @Published var sorting: Item.Sorting = .modified
  @Published var ascending: Bool = true
  @Published var itemsDisplayMode: ItemsDisplayMode = .list
  @Published var isPresentingError: Bool = false
  @Published var errorMessage: String = ""

  init(_ item: Item? = nil) {
    current = item
  }

  func newFolder(context: NSManagedObjectContext) {
    do {
      let _ = Item(folderName: "Untitled Folder", in: current!, context: context)
      try context.save()
    } catch {
      isPresentingError = true
      print(error)
      errorMessage = error.localizedDescription
      context.reset()
    }
  }

  func newDocument(context: NSManagedObjectContext) {
    do {
      let _ = Item(filename: "Document", in: current!, creator: "text", context: context)
      try context.save()
    } catch {
      isPresentingError = true
      print(error)
      errorMessage = error.localizedDescription
      context.reset()
    }
  }

  func itemFetchRequest(context: NSManagedObjectContext) -> NSFetchRequest<Item> {
    let request = Item.itemFetchRequest()
    
    if searchScope == .local {
      if current == nil {
        current = Item.root(context: context)
      }
      request.predicate = NSPredicate(format: "parent = %@ AND kind_ != 0 AND kind_ != 1", current!)
    }
    else {
      request.predicate = NSPredicate(format: "kind_ != 0 AND kind_ != 1")
    }

    request.sortDescriptors = [sorting.sortDescriptor(ascending: ascending)]
    return request
  }
}

struct ItemsView: View {
  @ObservedObject var viewModel: ItemsViewModel
  @Environment(\.managedObjectContext) var context

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
      .navigationBarTitle(titleName , displayMode: .inline)
      .navigationBarItems(trailing: HStack(spacing: 40) {
        if viewModel.current != nil {
            Button { viewModel.newDocument(context: context) }
              label: { Image(systemName: "doc.text") }
            Button { viewModel.newFolder(context: context) }
              label: { Image(systemName: "folder.badge.plus") }
        }
        Button { print("view mode") }
          label: { Image(systemName: "list.bullet")}
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
