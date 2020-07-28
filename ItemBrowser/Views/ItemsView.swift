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

final class ItemsViewModel: ObservableObject {

  @Published var current: Item?
  @Published var name: String?
  @Published var tag: Tag?
  @Published var sorting: Item.Sorting = .name
  @Published var ascending: Bool = true
  @Published var itemsDisplayMode: ItemsDisplayMode = .list
  @Published var isPresentingError: Bool = false
  @Published var errorMessage: String = ""

  func newFolder(context: NSManagedObjectContext) {
    do {
      let _ = Item(folderName: "Untitled Folder", in: current, context: context)
      try context.save()
    } catch {
      isPresentingError = true
      print(error)
      errorMessage = error.localizedDescription
    }
  }

  func itemFetchRequest(context: NSManagedObjectContext) -> NSFetchRequest<Item> {
    let request = Item.itemFetchRequest(context: context)
    request.predicate = NSPredicate(format: "kind_ != 0 AND kind_ != 1")
    request.sortDescriptors = sorting.sortDescriptor(ascending: ascending)
    return request
  }
}

struct ItemsView: View {
  @ObservedObject var viewModel: ItemsViewModel
  @Environment(\.managedObjectContext) var context

  var body: some View {
    ItemCollectionView(itemFetchRequest: viewModel.itemFetchRequest(context: context),
                       itemsDisplayMode: $viewModel.itemsDisplayMode)
      .navigationBarTitle("Items", displayMode: .inline)
      .navigationBarItems(trailing: HStack(spacing: 40) {
        Button { print("Add Document") }
          label: { Image(systemName: "doc.text") }
        Button { viewModel.newFolder(context: context) }
          label: { Image(systemName: "folder.badge.plus") }
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

struct ItemCollectionView: View {
  @FetchRequest var items: FetchedResults<Item>
  @Binding var itemsDisplayMode: ItemsDisplayMode

  init(itemFetchRequest: NSFetchRequest<Item>,
       itemsDisplayMode: Binding<ItemsDisplayMode>) {
    _items = FetchRequest(fetchRequest: itemFetchRequest)
    _itemsDisplayMode = itemsDisplayMode
  }

  var body: some View {
    List {
      ForEach(items) { item in
        Text(item.name)
      }
    }
  }
}


struct ItemCollectionView_Previews: PreviewProvider {
  static var previews: some View {
    ItemsView(viewModel: ItemsViewModel())
  }
}
