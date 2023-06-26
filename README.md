# PasswordChecker

PasswordChecker is a wrapper over [zxcvbn](https://github.com/dropbox/zxcvbn)   
Dropbox's online zxcvbn test - https://lowe.github.io/tryzxcvbn/

## Example

```swift
let passwordChecker = try? PasswordChecker()

let password = "2-Ubvrr23dsf2"
let result = passwordChecker?.getPasswordScore(password, userInputs: ["Vlad", "2-Ubvrr23"])

switch result {
case let .success(passwordInfo):
    debugPrint(passwordInfo.score)
    
case let .failure(error):
    debugPrint(error.localizedDescription)
    
case .none:
    assertionFailure("PasswordChecker is not initialised!")
}
```

## Installation

### Cocoapods
PasswordChecker is available through CocoaPods. To install it, simply add the following line to your Podfile:
```pod 'PasswordChecker' ```

### Swift Package Manager
File > Swift Packages > Add Package Dependency

OR

Update dependencies in ```Package.swift```

```swift
dependencies: [
  .package(url: "https://github.com/Loupehope/PasswordChecker.git", .exact("1.1.0")),
],
```

Useful scripts:
- `./scripts/lint.sh` - run project's linter
