//
//  IdentifierTypeSyntax+.swift
//  Mockapella
//
//  Created by Dominik Grodl on 18.12.2025.
//

import SwiftSyntax

extension IdentifierTypeSyntax {
    var isOptional: Bool {
        self.name.text == "Optional"
    }
}
