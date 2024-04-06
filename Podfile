# Uncomment the next line to define a global platform for your project
 platform :ios, '14.0'

target 'ERCWallet' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ERCWallet

  # network
	pod 'Alamofire'
  pod 'Moya/RxSwift'
  
  # reactive
  pod 'Action'
  pod 'NSObject+Rx'
  pod 'RxSwift'
  pod 'RxCocoa'
  
  # web3
  pod 'CryptoSwift'
  pod 'web3swift'
  pod 'BigInt'
  
  # UI relative
  pod 'SnapKit'
  pod 'ProgressHUD'
  pod 'IQKeyboardManagerSwift'
  
  # other
  pod 'R.swift'
  pod 'MMKV'

  target 'ERCWalletTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ERCWalletUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "14.0"
    end
  end
end
