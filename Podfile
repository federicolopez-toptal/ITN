# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ImproveTheNews' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ImproveTheNews
  pod 'SDWebImage'
  pod 'FBSDKLoginKit'
  pod 'EventsCalendar'


framework_paths = [
    # Add frameworks as needed
    
  ]

  # https://medium.com/@ssthil75/how-i-solved-the-asset-validation-failed-invalid-executable-error-in-xcode-16-on-m2-macs-00b21ce0ba17
    # https://medium.com/@vcorva/how-to-fix-invalid-executable-contains-bitcode-issues-cc8a5b533181

  framework_paths.each do |framework_relative_path|
    strip_bitcode_from_framework(bitcode_strip_path, framework_relative_path)
  end
end