//
//  ItemsViewModel.swift
//  ItemBrowser
//
//  Created by Ray Fix on 7/29/20.
//

import SwiftUI
import CoreData

final class ItemsDisplayMode: ObservableObject {
  enum Style {
    case icons, list
  }
  
  @Published var style: Style = .icons
  @Published var sorting: Item.Sorting = .name
  @Published var ascending: Bool = true

  var sortDescriptors: [NSSortDescriptor] {
    [sorting.sortDescriptor(ascending: ascending)]
  }
}

enum ItemsSeachScope {
  case global, local
}

final class ItemsViewModel: ObservableObject {

  @Published var searchScope = ItemsSeachScope.local
  @Published var current: Item?
  @Published var name: String?
  @Published var tag: Tag?
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

  func itemFetchRequest(context: NSManagedObjectContext, sortDescriptors: [NSSortDescriptor]) -> NSFetchRequest<Item> {
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

    request.sortDescriptors = sortDescriptors
    return request
  }
}

