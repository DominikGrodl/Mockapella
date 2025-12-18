//
//  DataType.swift
//  Mockapella
//
//  Created by Dominik Grodl on 18.12.2025.
//


enum DataType: Equatable {
    case string
    case integer(String)
    case float
    case double
    case boolean
    case character
    case custom(String)

    init(syntax: IdentifierTypeSyntax) {
        self.init(name: syntax.name.text)
    }

    init(token: TokenSyntax) {
        self.init(name: token.text)
    }

    private init(name: String) {
        self =
            switch name {
            case "Int", "Int8", "UInt8", "Int32", "UInt32", "Int64", "UInt64": .integer(name)
            case "String": .string
            case "Float": .float
            case "Double": .double
            case "Bool": .boolean
            case "Character": .character
            default: .custom(name)
            }
    }

    var name: String {
        switch self {
        case .string: "String".swiftQualified
        case .integer(let subtype): "\(subtype)".swiftQualified
        case .float: "Float".swiftQualified
        case .double: "Double".swiftQualified
        case .boolean: "Bool".swiftQualified
        case .character: "Character".swiftQualified
        case .custom(let name): name
        }
    }
}