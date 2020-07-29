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
    ZStack {
      RoundedRectangle(cornerRadius: 20).fill(Color.white)
      VStack {
        icon(for: item)
        Text(item.name).foregroundColor(.black)
        if let parent = item.parent, parent.kind != .root, parent.kind != .trash  {
          Text(parent.name)
            .foregroundColor(.gray)
            .font(.caption2)
        }
        Text(DateFormatter.short.string(from: item.modified))
          .foregroundColor(.gray)
          .font(.caption2)
      }.padding()
    }
    .actions(for: item)
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
