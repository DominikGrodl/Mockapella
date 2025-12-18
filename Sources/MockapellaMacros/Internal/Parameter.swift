//
//  Parameter.swift
//  Mockapella
//
//  Created by Dominik Grodl on 18.12.2025.
//

import Foundation
import SwiftSyntax

struct Parameter: Equatable {
    let name: String
    let type: DataType
    let isOptional: Bool
}

extension Array<Parameter> {
    func buildInit() -> DeclSyntax {
        let signature = self.map {
            "\($0.name.generatedSignifierPrefixed): \($0.type.name)\($0.isOptional ? "?" : "")"
        }.joined(separator: ",\n")

        let body = self.map {
            "self.\($0.name) = \($0.name.generatedSignifierPrefixed)"
        }.joined(separator: "\n")

        return DeclSyntax(
            stringLiteral: MethodBuilder.build(
                type: .initializer,
                signature: signature,
                body: body
            )
        )
    }
    
    func buildMockMethod() -> DeclSyntax {
        let signature =
            self
            .map {
                "\($0.name): \($0.type.name)\($0.isOptional ? "?" : "") = \($0.type.defaultValue(variableName: $0.name))"
            }
            .joined(separator: ",\n")

        let assigns =
            self
            .map {
                "\($0.name.generatedSignifierPrefixed): \($0.name)"
            }
            .joined(separator: ",\n")

        let body = """
            self.init(
                \(assigns)
            )
            """
        
        return DeclSyntax(
            stringLiteral: MethodBuilder.build(
                type: .staticFunc(name: "mock"),
                signature: signature,
                body: body,
                returns: "Self"
            )
        )
    }
}
