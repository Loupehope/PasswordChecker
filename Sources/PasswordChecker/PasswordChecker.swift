import JavaScriptCore

public enum PasswordCheckerError: Error {
    case unableToCreateJSContext
    case unableToGetScript
    case unableToParseResult
}

// For more, available properties - https://github.com/dropbox/zxcvbn#usage
public struct PasswordInfo {
    public let score: Int32
}

public class PasswordChecker {
    
    private let jsContext: JSContext
    
    public init() throws {
        guard let jsContext = JSContext() else {
            throw PasswordCheckerError.unableToCreateJSContext
        }
        
        guard let passwordCheckerPath = Bundle.module.path(forResource: JSScript.scriptName, ofType: JSScript.scriptType),
              let passwordCheckerJS = try? String(contentsOfFile: passwordCheckerPath, encoding: String.Encoding.utf8) else {
            
            throw PasswordCheckerError.unableToGetScript
        }
        
        jsContext.exceptionHandler = { _, exception in
            assertionFailure(exception?.toString() ?? JSScript.unknownError)
        }
        
        jsContext.evaluateScript(passwordCheckerJS)
        
        self.jsContext = jsContext
    }
    
    public func getPasswordScore(_ password: String,
                                 userInputs: [String] = []) -> Result<PasswordInfo, PasswordCheckerError> {
        
        let result = jsContext.objectForKeyedSubscript(JSScript.scriptName)?
            .call(withArguments: [password, userInputs])
        
        guard let score = result?.objectForKeyedSubscript(JSKey.score.rawValue)?.toInt32() else {
            return .failure(PasswordCheckerError.unableToParseResult)
        }
        
        let passwordInfo = PasswordInfo(score: score)
        
        return .success(passwordInfo)
    }
}

private extension PasswordChecker {
    
    enum JSKey: String, RawRepresentable {
        case score
    }
    
    enum JSScript {
        static let scriptName = "zxcvbn"
        static let scriptType = "js"
        static let unknownError = "Unknown JSError"
    }
}
