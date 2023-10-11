# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'Msuom-Client' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Msuom-Client

pod 'lottie-ios'
pod 'Alamofire'
pod 'Kingfisher'
pod 'Firebase/Messaging'
pod 'IQKeyboardManagerSwift'
pod 'IQKeyboardManager'
pod 'Firebase/DynamicLinks'
pod 'OpenTok'
pod 'lottie-ios'
pod 'Socket.IO-Client-Swift', '~> 16.0.1'

post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
          xcconfig_path = config.base_configuration_reference.real_path
          xcconfig = File.read(xcconfig_path)
          xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
          File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
          end
      end
  end

end
