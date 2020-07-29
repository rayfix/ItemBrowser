//
//  ItemGridEntry.swift
//  ItemBrowser
//
//  Created by Ray Fix on 7/29/20.
//

import SwiftUI

struct ItemGridEntry: View {
  let item: Item

  var body: some View {
    VStack {
      icon(for: item)
      Text(item.name)
    }.padding()
  }

  private func icon(for item: Item) -> some View {
    let name: String
    switch item.kind {
    case .root:
      name = "folder"
    case .trash:
      name = "trash"
    case .folder:
      name = "folder.fill"
    case .bundle:
      name = "doc.richtext"
    case .regular:
      name = "doc"
    }
    return Image(systemName: name)
      .resizable()
      .foregroundColor(.blue)
      .aspectRatio(contentMode: .fit)
      .opacity(0.5)
      .frame(width: 70)
  }
}
