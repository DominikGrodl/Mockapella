//
//  EnumCase.swift
//  Mockapella
//
//  Created by Dominik Grodl on 18.12.2025.
//

import Foundation
import SwiftSyntax

struct EnumCase {
    let caseName: String
    let parameters: [EnumParameter]
}

extension EnumCase {
    func buildEnumMethod(enumName: String) -> DeclSyntax? {
        if parameters.isEmpty {
            // The case has not associated values, so we don't need to mock it
            return nil
        }
        
        let signature = parameters
            .map {
                "\($0.name): \($0.type.name) = \($0.type.defaultValue(variableName: $0.name))"
            }
            .joined(separator: ",\n")
        
        let assigns = parameters
            .map {
                if $0.isExplicitlyNamed {
                    "\($0.name): \($0.name)"
                } else {
                    "\($0.name)"
                }
            }
            .joined(separator: ",\n")
        
        let body = """
        \(enumName).\(caseName)(
            \(assigns)
        )
        """
        
        return DeclSyntax(
            stringLiteral: MethodBuilder.build(
                type: .staticFunc(name: caseName.asEnumCaseMockMethodName),
                signature: signature,
                body: body,
                returns: "Self"
            )
        )
    }
}
