//
//  ItemActions.swift
//  ItemBrowser
//
//  Created by Ray Fix on 7/29/20.
//

import SwiftUI
import CoreData

func hideKeyboard() {
  UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}

struct InlineItemNameEditor: View {
  @State var draft: String
  var itemToCommit: Item
  @State private var error = false


  func isValid() -> Bool {
    false
  }

  var body: some View {
    Text(draft)
//        TextField("",
//                  text: $draft) { isEditing in
//                    error = false
//                  } onCommit: {
//                    if isValid() {
//                      error = false
//                      itemToCommit.name_ = draft
//                      itemToCommit.updateModified(date: Date())
//                      guard let context = itemToCommit.managedObjectContext else {
//                        return
//                      }
//                      try? context.save()
//                    } else {
//                      draft = itemToCommit.name
//                      error = true
//                    }
//                  }.shakeModifier(enable: error)
  }
}

struct ShakeEffect: GeometryEffect {
  init(_ activated: Bool) {
    x = activated ? 4 : 0
  }

  func effectValue(size: CGSize) -> ProjectionTransform {
    ProjectionTransform(CGAffineTransform(translationX: 5*sin(1.2 * .pi * x),
                                          y: 0))
  }
  var x: CGFloat
  var animatableData: CGFloat {
    get { x }
    set { x = newValue}
  }
}

extension View {
  func shakeModifier(enable: Bool) -> some View {
    self.modifier(ShakeEffect(enable))
      .animation(enable ? .linear(duration: 0.25) : .none)
  }
}

extension View {
  func actions(for item: Item) -> some View {
    contextMenu {
      if item.isInTrash() {
        Button { item.deletePermanently() } label: {
          HStack {
            Text("Delete Permanently")
            Image(systemName: "trash")
          }
        }
        Button { item.restore() } label: {
          HStack {
            Text("Restore")
            Image(systemName: "trash.slash")
          }
        }
      }
      else {
        Button { item.moveToTrash() } label: {
          HStack {
            Text("Delete")
            Image(systemName: "trash")
          }
        }
      }
    }
  }
}
