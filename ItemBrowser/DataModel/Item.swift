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
    name_!
  }

  var created: Date {
    created_!
  }

  var modified: Date {
    modified_!
  }

  var creator: String {
    creator_!
  }

  var children: Set<Item> {
    get { (children_ as? Set<Item>) ?? [] }
    set { children_ = newValue as NSSet }
  }


  enum Kind: Int64 {
    case root      = 0  // 🌲 (system)
    case trash     = 1  // 🗑 (system)
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

  static func predicate(kind: Kind) -> NSPredicate {
    NSPredicate(format: "kind_ = %@", kind.rawValue)
  }
}

/// Query Extensions
extension Item {
  static func itemFetchRequest(context: NSManagedObjectContext) -> NSFetchRequest<Item> {
    NSFetchRequest<Item>(entityName: "Item")
  }

  static func root(context: NSManagedObjectContext) -> Item? {
    let request = Item.itemFetchRequest(context: context)
    request.predicate = NSPredicate(format: "kind_ = %@", Kind.root.rawValue)
    return try? context.fetch(request).first
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
    self.name_ = "/"
    self.creator_ = ""
  }

  // 📁 Folder Creation
  convenience init(folderName: String, in parent: Item, context: NSManagedObjectContext) {
    precondition(parent.kind != .regular)
    self.init(kind: .folder, context: context)
    self.name_ = folderName
    self.parent = parent
  }

  // 🗂 Bundle Creation
  convenience init(bundleName: String, in parent: Item, creator: String, context: NSManagedObjectContext) {
    precondition(parent.kind != .regular)
    self.init(kind: .bundle, context: context)
    self.name_ = bundleName
    self.parent = parent
    self.creator_ = creator
  }

  // 📄 Regular File Creation
  convenience init(filename: String, in parent: Item, creator: String, context: NSManagedObjectContext) {
    precondition(parent.kind != .regular)
    self.init(kind: .regular, context: context)
    self.name_ = filename
    self.parent = parent
    self.creator_ = creator
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
      return NSSortDescriptor(key: "name_", ascending: ascending)
    case .created:
      return NSSortDescriptor(key: "created_", ascending: ascending)
    case .modified:
      return NSSortDescriptor(key: "modified_", ascending: ascending)
    case .size:
      return NSSortDescriptor(key: "size_", ascending: ascending)
    case .creator:
      return NSSortDescriptor(key: "size_", ascending: ascending)
    case .tags:
      return NSSortDescriptor(key: "tag.name_", ascending: ascending)
    }
  }
}

