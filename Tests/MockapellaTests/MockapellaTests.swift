import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(MockapellaMacros)
import MockapellaMacros

let testMacros: [String: Macro.Type] = [
    "Mocked": MockedMacro.self,
]
#endif

final class MockapellaTests: XCTestCase {
    func testMacroWithBuiltInTypes() throws {
        #if canImport(MockapellaMacros)
        assertMacroExpansion(
            """
            @Mocked
            struct ABC {
                let a: String
                let b: Int
            }
            """,
            expandedSource: #"""
            struct ABC {
                let a: String
                let b: Int
            
                private init(
                    _$a: Swift.String,
                    _$b: Swift.Int
                ) {
                    self.a = _$a
                    self.b = _$b
                }
            
                static func mock(
                    a: Swift.String = "a",
                    b: Swift.Int = "b".count
                ) -> Self {
                    self.init(
                    _$a: a,
                    _$b: b
                    )
                }
            }
            """#,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testMacroWithCustomTypes() throws {
        #if canImport(MockapellaMacros)
        assertMacroExpansion(
            """
            @Mocked
            struct ABC {
                let a: String
                let b: SomeCustomType
            }
            """,
            expandedSource: #"""
            struct ABC {
                let a: String
                let b: SomeCustomType
            
                private init(
                    _$a: Swift.String,
                    _$b: SomeCustomType
                ) {
                    self.a = _$a
                    self.b = _$b
                }
            
                static func mock(
                    a: Swift.String = "a",
                    b: SomeCustomType = SomeCustomType.mock()
                ) -> Self {
                    self.init(
                    _$a: a,
                    _$b: b
                    )
                }
            }
            """#,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testMacroWithEnum() throws {
        #if canImport(MockapellaMacros)
        assertMacroExpansion(
            """
            @Mocked
            enum ABC {
                case firstCase
                case thirdCase(count: Int, String, ABC)
                case secondCase(Int)
            }
            """,
            expandedSource: #"""
            enum ABC {
                case firstCase
                case thirdCase(count: Int, String, ABC)
                case secondCase(Int)
            
                static func thirdCaseMock(
                    count: Swift.Int = "count".count,
                    arg1: Swift.String = "arg1",
                    arg2: ABC = ABC.mock()
                ) -> Self {
                    ABC.thirdCase(
                    count: count,
                    arg1,
                    arg2
                    )
                }
            
                static func secondCaseMock(
                    arg0: Swift.Int = "arg0".count
                ) -> Self {
                    ABC.secondCase(
                    arg0
                    )
                }
            
                static func mock() -> Self {
                    ABC.firstCaseMock()
                }
            }
            """#,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

}
