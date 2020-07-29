//
//  ItemStore.swift
//  ItemBrowser
//
//  Created by Ray Fix on 7/27/20.
//

import CoreData

final class ItemStore: ObservableObject {
  init() {
    let container = NSPersistentContainer(name: "ItemModel")
    container.loadPersistentStores { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    self.persistentContainer = container

    // Seed the database
    seed(context: container.viewContext)
  }

  var persistentContainer: NSPersistentContainer
  var viewContext: NSManagedObjectContext {
    persistentContainer.viewContext
  }
  var rootItem: Item {
    Item.root(context: viewContext)
  }
}

extension ItemStore {
  func seed(context: NSManagedObjectContext) {
    let request: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")

    guard let count = try? context.count(for: request) else {
      fatalError("Basic query failure")
    }
    if count == 0 {

      let root = Item(kind: .root, context: context)
      root.name_ = ".root"

      let trash = Item(kind: .trash, context: context)
      trash.name_ = ".trash"

      Tag.PresetColor.allCases.forEach { preset in
        let _ = Tag(preset: preset, context: context)
      }

      do {
        try context.safeIfChanged()
      }
      catch {
        print("Failed to populate database", error)
        return
      }
    }

    print("Database Ready")
  }
}
