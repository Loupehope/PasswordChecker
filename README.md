# PasswordChecker

PasswordChecker is a wrapper over [zxcvbn](https://github.com/dropbox/zxcvbn).

## Example

```swift
let password = "2-Ubvrr23dsf2"

let result = PasswordChecker.getPasswordScore(password, userInputs: ["Max", "Petrov"])
        
switch result {
case let .success(passwordInfo):
    debugPrint(passwordInfo.score)

case let .failure(error):
    debugPrint(error.localizedDescription)
}
```

## Installation

```swift
dependencies: [
  .package(url: "https://github.com/Loupehope/PasswordChecker.git", .exact("1.0.0")),
],
```



