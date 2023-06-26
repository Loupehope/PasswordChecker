Pod::Spec.new do |s|
  s.name             = 'PasswordChecker'
  s.version          = '1.4.0'
  s.summary          = 'PasswordChecker is a wrapper over zxcvbn.'
  s.homepage         = 'https://github.com/loupehope/PasswordChecker'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'loupehope' => 'suhomlinov.dev@gmail.com' }
  s.source           = { :git => 'https://github.com/loupehope/PasswordChecker.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.source_files = 'Sources/PasswordChecker/*.swift'
  s.swift_versions = ['5']
  s.resource_bundles = {
    'PasswordCheckerResources' => ['Sources/PasswordChecker/zxcvbn/**/*']
  }
end
