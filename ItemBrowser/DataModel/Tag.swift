//
//  Tag.swift
//  ItemBrowser
//
//  Created by Ray Fix on 7/26/20.
//

import SwiftUI
import CoreData

extension Tag {

  enum PresetColor: String, CaseIterable  {
    case red, orange, yellow, green, blue, purple, gray

    var color: Color {
      switch self {
      case .red:
        return Color.red
      case .orange:
        return Color.orange
      case .yellow:
        return Color.yellow
      case .green:
        return Color.green
      case .blue:
        return Color.blue
      case .purple:
        return Color.purple
      case .gray:
        return Color.gray
      }
    }

    static func convertHexCode(_ hexCode: String) -> Color {
      Color.clear // TBD
    }
  }

  convenience init(preset: PresetColor, context: NSManagedObjectContext) {
    self.init(name: preset.rawValue.localizedCapitalized,
              colorName: preset.rawValue,
              context: context)
  }

  convenience init(name: String, colorName: String, context: NSManagedObjectContext) {
    self.init(context: context)
    self.name_ = name
    self.colorName_ = colorName
  }

  var color: Color {
    guard let colorName = colorName_?.lowercased() else {
      return Color.clear
    }
    if colorName.hasPrefix("#") {
      return PresetColor.convertHexCode(colorName)
    } else {
      return PresetColor(rawValue: colorName)?.color ?? Color.clear
    }
  }
}
