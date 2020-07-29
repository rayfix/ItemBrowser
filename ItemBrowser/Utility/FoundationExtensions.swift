//
//  FoundationExtensions.swift
//  ItemBrowser
//
//  Created by Ray Fix on 7/26/20.
//

import Foundation

extension Data {
  var utf8: String? { String(data: self, encoding: .utf8 ) }
}

extension DateFormatter {
  static var short: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US")
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
  }()
}

extension ByteCountFormatter {
  static var shared: ByteCountFormatter = {
    let formatter = ByteCountFormatter()
    return formatter
  }()
}
