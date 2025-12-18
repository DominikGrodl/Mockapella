//
//  EnumCaseParameterClauseSyntax+.swift
//  Mockapella
//
//  Created by Dominik Grodl on 18.12.2025.
//

import SwiftSyntax


extension Optional<EnumCaseParameterClauseSyntax> {
    func buildEnumParameters() -> [EnumParameter] {
        guard let self else { return [] }
        
        return self.parameters
            .enumerated()
            .compactMap {
                guard let identifier = $1.type.as(IdentifierTypeSyntax.self) else {
                    return nil
                }
                
                return EnumParameter(
                    name: $1.firstName?.text ?? "arg\($0)",
                    type: DataType(syntax: identifier),
                    isExplicitlyNamed: $1.firstName != nil
                )
            }
    }
}
