require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "RNSfActionSheet"
  s.version      = package["version"]
  s.summary      = "Custom SF Symbols ActionSheet"
  s.author       = "Gaauwe Rombouts"
  s.homepage     = "https://github.com/gaauwe/react-native-sf-action-sheet"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/gaauwe/react-native-sf-action-sheet.git", :tag => "v#{s.version}" }
  s.source_files  = "ios/**/*.{h,m,swift}"
  s.requires_arc = true


  s.dependency "React"
end

  