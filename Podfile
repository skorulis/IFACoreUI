platform :ios, '8.0'
workspace 'IFACoreUI'
project 'IFACoreUI/IFACoreUI.xcodeproj'
use_frameworks!

target :IFACoreUI do

  # pod 'IFAFoundation'
  # pod 'IFAFoundation', :git => 'https://github.com/marcelo-schroeder/IFAFoundation.git', :branch => 'dev_iOS10_Cocoapods1'
  # pod 'IFAFoundation', :git => 'https://github.com/marcelo-schroeder/IFAFoundation.git', :branch => 'development'
pod 'IFAFoundation', :path => '/Users/mschroeder/myfiles/projects/Xcode/IFAFoundation/IFAFoundation_development'

  target :IFACoreUITests do
    pod 'IFATestingSupport'
#pod 'IFATestingSupport', :git => 'https://github.com/marcelo-schroeder/IFATestingSupport.git', :tag => 'v0.1.1'
# pod 'IFATestingSupport', :git => 'https://github.com/marcelo-schroeder/IFATestingSuport.git', :branch => 'development'
# pod 'IFATestingSupport', :path => '/Users/mschroeder/myfiles/projects/Xcode6/IFATestingSupport/IFATestingSupport_development'
    pod 'OCHamcrest', :inhibit_warnings => true
    pod 'OCMock'
  end

end

post_install do |installer_representation|
  installer_representation.pods_project.targets.each do |target|
    target.build_configurations.each do |config|

      # Restrict to extension API's only - Cocoapods is somehow coming to the conclusion that this should be set to NO, so this reverts that setting.
      if target.name == 'IFAFoundation'
        config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = 'YES'
      end

    end
  end
end