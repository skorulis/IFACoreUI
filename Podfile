platform :ios, '8.0'
workspace 'IFACoreUI'
xcodeproj 'IFACoreUI/IFACoreUI.xcodeproj'
link_with 'IFACoreUI', 'IFACoreUITests'
use_frameworks!

target :IFACoreUI do

  # pod 'IFAFoundation', :git => 'https://github.com/marcelo-schroeder/IFAFoundation.git', :branch => 'dev_iOS10'
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