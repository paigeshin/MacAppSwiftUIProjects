//
//  Stock.swift
//  MenuBarApp-SwiftUI
//
//  Created by paige shin on 2023/02/26.
//

import Foundation

struct Stock: Decodable {
    let symbol: String
    let description: String
    let price: Double
}
