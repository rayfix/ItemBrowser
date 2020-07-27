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

/// Abstraction for kind
extension Item {
  enum Kind: Int64 {
    case root      = 0  // 🌲 (system)
    case trash     = 1  // 🗑 (system)
    case folder    = 2  // 📁 (user created)
    case bundle    = 3  // 🗂 (user created)
    case regular   = 4  // 📄 (user created)
  }

  var kind: Kind {
    get {
      Kind(rawValue: kindValue) ?? .regular
    }
    set {
      kindValue = newValue.rawValue
    }
  }

  static func predicate(kind: Kind) -> NSPredicate {
    NSPredicate(format: "kindValue = %@", kind.rawValue)
  }
}

/// Query Extensions
extension Item {

  func fetchRequest() -> NSFetchRequest<Item> {
    NSFetchRequest(entityName: "Item")
  }

  func rootUUID(context: NSManagedObjectContext) -> UUID? {
    let request = fetchRequest()
    request.predicate = NSPredicate(format: "kindValue = 0")
    return try? context.fetch(request).first?.id
  }
}


/// Initialization Helpers
extension Item {
  convenience init(kind: Kind, context: NSManagedObjectContext) {
    self.init(context: context)
    let now = Date()
    self.kind = kind
    self.id = UUID()
    self.created = now
    self.modified = now
    self.name = "/"
    self.creator = ""
  }

  // 📁 Folder Creation
  convenience init(folderName: String, in parent: Item, context: NSManagedObjectContext) {
    precondition(parent.kind != .regular)
    self.init(kind: .folder, context: context)
    self.name = folderName
    self.parent = parent
  }

  // 🗂 Bundle Creation
  convenience init(bundleName: String, in parent: Item, creator: String, context: NSManagedObjectContext) {
    precondition(parent.kind != .regular)
    self.init(kind: .bundle, context: context)
    self.name = bundleName
    self.parent = parent
    self.creator = creator
  }

  // 📄 Regular File Creation
  convenience init(filename: String, in parent: Item, creator: String, context: NSManagedObjectContext) {
    precondition(parent.kind != .regular)
    self.init(kind: .regular, context: context)
    self.name = filename
    self.parent = parent
    self.creator = creator
  }
}

/// Query Helpers
extension Item {
  enum Sorting: CaseIterable {
    case name, created, modified, size, creator, tags
  }

  static func sortDescriptor(by sorting: Sorting, ascending: Bool) -> NSSortDescriptor {
    switch sorting {
    case .name:
      return NSSortDescriptor(key: "name", ascending: ascending)
    case .created:
      return NSSortDescriptor(key: "created", ascending: ascending)
    case .modified:
      return NSSortDescriptor(key: "modified", ascending: ascending)
    case .size:
      return NSSortDescriptor(key: "size", ascending: ascending)
    case .creator:
      return NSSortDescriptor(key: "size", ascending: ascending)
    case .tags:
      return NSSortDescriptor(key: "tag.name", ascending: ascending)
    }
  }
}

