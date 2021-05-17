import JavaScriptCore

public enum PasswordCheckerError: Error {
    case unableToCreateJSContext
    case unableToGetScript
    case unableToParseResult
}

// For more, available properties - https://github.com/dropbox/zxcvbn#usage
public struct PasswordInfo {
    let score: Int32
}

public enum PasswordChecker {

    public static func getPasswordScore(_ password: String,
                                        userInputs: [String] = []) -> Result<PasswordInfo, PasswordCheckerError> {

        guard let jsContext = JSContext() else {
            return .failure(PasswordCheckerError.unableToCreateJSContext)
        }

        guard let passwordCheckerPath = Bundle.module.path(forResource: JSScript.scriptName, ofType: JSScript.scriptType),
              let passwordCheckerJS = try? String(contentsOfFile: passwordCheckerPath, encoding: String.Encoding.utf8) else {
            
            return .failure(PasswordCheckerError.unableToGetScript)
        }

        jsContext.evaluateScript(passwordCheckerJS)

        jsContext.setObject(password, forKeyedSubscript: JSKey.password.asNSString)
        jsContext.setObject(userInputs, forKeyedSubscript: JSKey.userInputs.asNSString)

        guard let result = jsContext.evaluateScript(JSScript.scriptToEvaluate),
              let score = result.objectForKeyedSubscript(JSKey.score.rawValue)?.toInt32() else {
            
            return .failure(PasswordCheckerError.unableToParseResult)
        }

        let passwordInfo = PasswordInfo(score: score)

        return .success(passwordInfo)
    }
}

private extension PasswordChecker {

    enum JSKey: String, RawRepresentable {
        case password
        case userInputs = "user_inputs"
        case score

        var asNSString: NSString {
            rawValue as NSString
        }
    }

    enum JSScript {
        static let scriptName = "zxcvbn"
        static let scriptType = "js"
        static let scriptToEvaluate = "zxcvbn(password, user_inputs)"
    }
}
