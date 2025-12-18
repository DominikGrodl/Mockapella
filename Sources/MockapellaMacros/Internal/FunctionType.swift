//
//  FunctionType.swift
//  Mockapella
//
//  Created by Dominik Grodl on 18.12.2025.
//

import Foundation

enum FunctionType {
    case initializer
    case staticFunc(name: String)

    var syntax: String {
        switch self {
        case .initializer: "private init"
        case .staticFunc(let name): "static func \(name)"
        }
    }
}
