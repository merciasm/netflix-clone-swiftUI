# Jungle Devs - netflix-clone (iOS)

This repository contains the netflix-clone (iOS) project.

## Work Environment

- Swift 4.2
- Xcode 10.0+

## Dependencies

This project is currently using **cocoapods** to manage its dependencies. To update and install them all, run `pod repo update && pod install`.

### SwiftLint

[SwiftLint](https://github.com/realm/SwiftLint) is a linter tool used to improve the consistency and quality of the project by applying some code style rules. It is configured to run everytime a build is generated (`netflix-clone -> Build Phases -> SwiftLint`).

### Alamofire

[Alamofire](https://github.com/Alamofire/Alamofire) is an HTTP networking library written in Swift.

### RxSwift & RxCocoa

[RxSwift](https://github.com/ReactiveX/RxSwift) is a generic abstraction of computation expressed through Observable<Element> interface. Its intention is to enable easy composition of asynchronous operations and event/data streams.

RxCocoa provides Cocoa-specific capabilities for general iOS/macOS/watchOS & tvOS app development, such as Binders, Traits, and much more. It depends on both RxSwift and RxRelay.
