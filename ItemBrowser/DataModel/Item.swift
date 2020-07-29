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

}


/// Query Extensions
extension Item {
  static func itemFetchRequest(context: NSManagedObjectContext) -> NSFetchRequest<Item> {
    NSFetchRequest<Item>(entityName: "Item")
  }

  static func trash(context: NSManagedObjectContext) -> Item? {
    let request = Item.itemFetchRequest(context: context)
    request.predicate = NSPredicate(format: "kind_ = %0", Kind.trash.rawValue)
    return try? context.fetch(request).first
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
  convenience init(folderName: String, in parent: Item?, context: NSManagedObjectContext) {
    self.init(kind: .folder, context: context)
    self.name_ = folderName
    self.parent = parent
  }

  // 🗂 Bundle Creation
  convenience init(bundleName: String, in parent: Item?, creator: String, context: NSManagedObjectContext) {
    self.init(kind: .bundle, context: context)
    self.name_ = bundleName
    self.parent = parent
    self.creator_ = creator
  }

  // 📄 Regular File Creation
  convenience init(filename: String, in parent: Item?, creator: String, context: NSManagedObjectContext) {
    self.init(kind: .regular, context: context)
    self.name_ = filename
    self.parent = parent
    self.creator_ = creator
    self.size_ = 10000000
  }
}

/// Query Helpers
extension Item {
  enum Sorting: CaseIterable {
    case name, created, modified, size, creator, tags

    func sortDescriptor(ascending: Bool) -> [NSSortDescriptor] {

      let key: String
      switch self {
      case .name:
        key = "name_"
      case .created:
        key = "created_"
      case .modified:
        key = "modified_"
      case .size:
        key = "size_"
      case .creator:
        key = "size_"
      case .tags:
        key = "tag.name_"
      }
      return [NSSortDescriptor(key: key, ascending: ascending)]
    }
  }
}

