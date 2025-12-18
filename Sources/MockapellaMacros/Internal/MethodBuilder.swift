//
//  MethodBuilder.swift
//  Mockapella
//
//  Created by Dominik Grodl on 18.12.2025.
//

import Foundation

enum MethodBuilder {
    static func build(
        type: FunctionType,
        signature: String?,
        body: String,
        returns: String? = nil
    ) -> String {
        let returnSyntax = if let returns {
            " -> \(returns)"
        } else {
            ""
        }
        
        let signatureSyntax = if let signature {
            "\n\(signature)\n"
        } else {
            ""
        }

        return """
            \(type.syntax)(\(signatureSyntax))\(returnSyntax) {
                \(body)
            }
            """
    }
}
