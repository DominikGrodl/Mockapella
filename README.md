# Mockapella

Mockapella is a Swift Macro library providing useful functionality for easily mocking you custom types for use in Previews.

> [!IMPORTANT]
> Mockapella is in a very early stage of development

## How it works

The library works by examining your types and generating the code needed to easily mock your types. 
It provides a `static func mock(...)` method with default values which you can easily invoke inside Previews, or any other part of your code base, if the concept fits.

For example a custom type like this:

```swift
@Mocked
struct Player {
  let name: String
  let level: Int
  let progress: Double
}
```

would get automatically generated mock method like this:
```swift
static func mock(
  name: String = \..\
  level: Int = \...\
  progress: Double = \...\
) -> Self {
  ...
}
```
This mock method is just a plain old function, which means you can invoke it either with the default values
specified by the signature (`Player.mock()`) or specify any number of argument you want yourself, such as `Player.mock(level: 999)`

The library also supports nested mocked types. When it detects a non-Swift data type, it invokes the mock method on it. A struct like this:

```swift
@Mocked
struct Person {
  let someNestedCustomType: CustomType
}
```

gets this mock method signature:

```swift
static func mock(
  someNestedCustomType: CustomType = CustomType.mock()
) -> Self {
  ...
}
```

it is then up to you to decide which way you want to provide the mock method. You can either annotate the type itself with Mocked macro again, or provide the static mock method youself.

## Default values

As you can see further up the document, the macro provides default values for Swift built in types. It may sound like it is not possible for the macro to gather all the necessary context
to provide a sensible default for every value, and that is completely true. This is why the default is a context unaware value derived from the name of the variable. This next table shows
how the defaults are created:

| Type  | Defult |
| ------------- | ------------- |
| String  | name of the variable  |
| Int, Double, Float  | number of characters of the name  |
| Character  | first character of the name  |
| Bool  | whether the name is a multiple of 2  |
| custom  | `Type.mock()`  |

The defaults are not meant to represent a sensible value, but a quick way to get the mock up and running. You can always provide your own value when calling the mock.

## Usage

Mocked macro can currently be applied to non-generic structs and enums.

## Limitations

There are currently some limitations to how one can use the generated symbols. The main one, for the purpose of this library, is when using Preview.
Unfortunately due to how macro generated code can interact with each other (i.e. it can't), it is currently not possible to invoke the `mock` method from inside the `#Preview`
macro, as any code inside won't be able to see the method. There are two solutions:

* You can resort back to using the PreviewProvider struct (which, funnily enough, seems to be a little bit more stable in Xcode 26 😉)
* Or you can define you own static method on the type, which invokes the mock under the hood. Although this approach makes using the macro a little redundant.




























