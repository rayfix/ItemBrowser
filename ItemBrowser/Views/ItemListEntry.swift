//
//  ItemListEntry.swift
//  ItemBrowser
//
//  Created by Ray Fix on 7/28/20.
//

import SwiftUI
import CoreData




struct ItemListEntry: View {
  let item: Item

  var body: some View {
    HStack(spacing: 20) {
      icon(for: item)
      Text(item.name)
      Spacer()
      Text(DateFormatter.short.string(from: item.modified))
        .foregroundColor(.gray).padding()
      detail(for: item)
        .foregroundColor(.gray).padding()
    }
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
      .frame(width: 40)
  }

  private func detail(for item: Item) -> some View {
    let text: String
    switch item.kind {
    case .root:
      text = "root"
    case .trash:
      text = "trash"
    case .folder:
      let count = item.children.count
      text = count == 1 ? "1 item" : "\(count) items"
    case .bundle:
      text = "doc.richtext"
    case .regular:
      text = ByteCountFormatter.shared.string(fromByteCount: item.size_)
    }
    return Text(text)
  }
}
