//
//  ItemCollectionView.swift
//  ItemBrowser
//
//  Created by Ray Fix on 7/25/20.
//

import SwiftUI


struct ItemCollectionView: View {

  enum Mode {
    case icons, list, columns
  }

  @State var itemStack: [UUID] = Item.rootUUID(<#T##self: Item##Item#>)
  @State var mode: Mode = .list
  @State var sorting: Item.Sorting = .name
  @State var ascending: Bool = true

  var body: some View {
    Text("OKAY")
  }
}

struct ItemCollectionView_Previews: PreviewProvider {
  static var previews: some View {
    ItemCollectionView()
  }
}
