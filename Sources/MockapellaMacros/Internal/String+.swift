//
//  String+.swift
//  Mockapella
//
//  Created by Dominik Grodl on 18.12.2025.
//

import Foundation

extension String {
    var swiftQualified: String {
        "Swift.\(self)"
    }
    
    var generatedSignifierPrefixed: String {
        "_$\(self)"
    }
    
    var asEnumCaseMockMethodName: String {
        "\(self)Mock"
    }
}
