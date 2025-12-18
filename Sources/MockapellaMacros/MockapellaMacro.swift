import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct MockedMacro: MemberMacro {
    public static func expansion<S: DeclGroupSyntax, C: MacroExpansionContext>(
        of node: AttributeSyntax,
        providingMembersOf declaration: S,
        conformingTo protocols: [TypeSyntax],
        in context: C
    ) throws -> [DeclSyntax] {
        if let structDeclaration = declaration.as(StructDeclSyntax.self) {
            return try handle(structDeclaration)
        }

        if let enumDeclaration = declaration.as(EnumDeclSyntax.self) {
            return try handle(enumDeclaration)
        }

        fatalError()
    }

    static func handle(_ declaration: StructDeclSyntax) throws -> [DeclSyntax] {
        let variables = declaration
            .memberBlock
            .members
            .compactMap {
                $0.decl.as(VariableDeclSyntax.self)
            }
            .flatMap(\.bindings)
            .compactMap { variable in
                if variable.accessorBlock == nil,
                    let name = variable.pattern.as(IdentifierPatternSyntax.self)?.identifier,
                    let annotation = variable.typeAnnotation
                {
                    if let type = annotation.type.as(IdentifierTypeSyntax.self) {
                        if type.isOptional {
                            return Parameter(
                                name: name.text,
                                type: extractOptionalGenericType(from: type),
                                isOptional: true
                            )
                        } else {
                            return Parameter(
                                name: name.text,
                                type: DataType(syntax: type),
                                isOptional: false
                            )
                        }
                    }

                    if let type = annotation
                        .type
                        .as(OptionalTypeSyntax.self)?
                        .wrappedType
                        .as(IdentifierTypeSyntax.self)
                    {
                        return Parameter(
                            name: name.text,
                            type: DataType(syntax: type),
                            isOptional: true
                        )
                    }
                }

                return nil
            }

        return [
            variables.buildInit(),
            variables.buildMockMethod(),
        ]
    }

    static func handle(_ declaration: EnumDeclSyntax) throws -> [DeclSyntax] {
        let cases = declaration
            .memberBlock
            .members
            .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
            .flatMap(\.elements)
            .map {
                EnumCase(
                    caseName: $0.name.text,
                    parameters: $0.parameterClause.buildEnumParameters()
                )
            }
        
        let firstMethodName = cases[0].caseName.asEnumCaseMockMethodName
        
        let specializedMethods = cases.compactMap { $0.buildEnumMethod(enumName: declaration.name.text) }
        
        let generalMockMethod = DeclSyntax(
            stringLiteral: MethodBuilder.build(
                type: .staticFunc(name: "mock"),
                signature: nil,
                body: "\(declaration.name.text).\(firstMethodName)()",
                returns: "Self"
            )
        )
        
        return specializedMethods + [generalMockMethod]
    }

    static func extractOptionalGenericType(from typeName: IdentifierTypeSyntax) -> DataType {
        guard
            let argument = typeName.genericArgumentClause?.arguments.first,
            let genericTypeName = argument.argument.as(IdentifierTypeSyntax.self)?.name
        else {
            fatalError()
        }

        return DataType(token: genericTypeName)
    }
}

@main
struct MockapellaPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        MockedMacro.self
    ]
}
