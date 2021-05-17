import JavaScriptCore

enum PasswordChecker {
    
    static func getPasswordScore(_ password: String) throws -> Int32 {
        guard let jsContext = JSContext() else {
            throw NSError()
        }
        
        // Load zxcvbn into JSContext
        guard let zxcvbnPath = Bundle.module.path(forResource: "zxcvbn", ofType: "js") else {
            throw NSError()
        }

        let zxcvbnJS = try String(contentsOfFile: zxcvbnPath, encoding: String.Encoding.utf8)
        jsContext.evaluateScript(zxcvbnJS)
        
        // Set password to context, evaluate script and get result
        jsContext.setObject(password, forKeyedSubscript: "password" as NSString)

        guard let result = jsContext.evaluateScript("zxcvbn(password)"),
              let value = result.objectForKeyedSubscript("score") else {
            throw NSError()
        }
        
        return value.toInt32()
    }
}
