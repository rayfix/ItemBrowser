//
//  CoreDataExtensions.swift
//  ItemBrowser
//
//  Created by Ray Fix on 7/27/20.
//

import CoreData

extension NSPredicate {
  static var all = NSPredicate(format: "TRUEPREDICATE")
  static var none = NSPredicate(format: "FALSEPREDICATE")
}

extension NSManagedObjectContext {
  func safeIfChanged() throws {
    if self.hasChanges {
      try self.save()
    }
  }
}
