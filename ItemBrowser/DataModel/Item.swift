//
//  Item.swift
//  ItemBrowser
//
//  Created by Ray Fix on 7/25/20.
//

import CoreData
import SwiftUI

enum ItemError: Error {
  case noRootItem
}

///
extension Item {
  var name: String {
    name_ ?? "Unknown Name"
  }

  var created: Date {
    created_ ?? Date()
  }

  var modified: Date {
    modified_ ?? Date()
  }

  var creator: String {
    creator_ ?? "unknown"
  }

  var isRoot: Bool {
    parent == nil
  }

  var children: Set<Item> {
    get { (children_ as? Set<Item>) ?? [] }
    set { children_ = newValue as NSSet }
  }

  enum Kind: Int64 {
    case root      = 0  // 🌲 root (system)
    case trash     = 1  // 🗑 trash (system)
    case folder    = 2  // 📁 (user created)
    case bundle    = 3  // 🗂 (user created)
    case regular   = 4  // 📄 (user created)
  }

  var kind: Kind {
    get {
      Kind(rawValue: kind_) ?? .regular
    }
    set {
      kind_ = newValue.rawValue
    }
  }
}

/// Find unique item name
extension Item {
  static func findUniqueName(for basename: String, in folder: Item) -> String {
    let request = Item.itemFetchRequest()
    request.predicate = NSPredicate(format: "parent = %@ AND name_ BEGINSWITH[c] %@", folder, basename)
    request.sortDescriptors = [Item.Sorting.name.sortDescriptor(ascending: false)]
    guard let last = try? folder.managedObjectContext?.fetch(request).first else {
      return basename
    }
    if let number = last.name.trailingInteger() {
      return basename + " \(number+1)"
    }
    else {
      return basename + " 2"
    }
  }}

/// Query Extensions
extension Item {
  static func itemFetchRequest() -> NSFetchRequest<Item> {
    NSFetchRequest<Item>(entityName: "Item")
  }

  /// May only run after the database is seeded
  static func root(context: NSManagedObjectContext) -> Item {
    let request = Item.itemFetchRequest()
    request.predicate = NSPredicate(format: "kind_ = %d", Kind.root.rawValue)
    request.sortDescriptors = []
    return try! context.fetch(request).first!  // better not fail
  }

    /// May only run after the database is seeded
  static func trash(context: NSManagedObjectContext) -> Item {
    let request = Item.itemFetchRequest()
    request.predicate = NSPredicate(format: "kind_ = %d", Kind.trash.rawValue)
    request.sortDescriptors = []
    return try! context.fetch(request).first!
  }
}

/// Initialization Helpers
extension Item {
  convenience init(kind: Kind, context: NSManagedObjectContext) {
    self.init(context: context)
    let now = Date()
    self.kind_ = kind.rawValue
    self.id = UUID()
    self.created_ = now
    self.modified_ = now
    self.name_ = ""
    self.creator_ = ""
  }

  // 📁 Folder Creation
  convenience init(folderName: String, in parent: Item, context: NSManagedObjectContext) {
    self.init(kind: .folder, context: context)
    self.name_ = Item.findUniqueName(for: folderName, in: parent)
    self.parent = parent
  }

  // 🗂 Bundle Creation
  convenience init(bundleName: String, in parent: Item, creator: String, context: NSManagedObjectContext) {
    self.init(kind: .bundle, context: context)
    self.name_ = Item.findUniqueName(for: bundleName, in: parent)
    self.parent = parent
    self.creator_ = creator
  }

  // 📄 Regular File Creation
  convenience init(filename: String, in parent: Item, creator: String, context: NSManagedObjectContext) {
    self.init(kind: .regular, context: context)
    self.name_ = Item.findUniqueName(for: filename, in: parent)
    self.parent = parent
    self.creator_ = creator
    self.size_ = Int64.random(in: 1...200000000)
  }
}

/// Query Helpers
extension Item {
  enum Sorting: CaseIterable {
    case name, created, modified, size, creator

    func sortDescriptor(ascending: Bool) -> NSSortDescriptor {
      let key: String
      switch self {
      case .name:
        key = "name_"
        return NSSortDescriptor(key: key, ascending: ascending,
                                selector: #selector(NSString.localizedStandardCompare))
      case .created:
        key = "created_"
      case .modified:
        key = "modified_"
      case .size:
        key = "size_"
      case .creator:
        key = "size_"
      }
      return NSSortDescriptor(key: key, ascending: ascending)
    }
  }
}

