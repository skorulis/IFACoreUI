Pod::Spec.new do |s|
    s.name              = 'IFACoreUI'
    s.version           = '1.0.1'
    s.summary           = 'A Cocoa Touch framework to help you develop high quality iOS apps and app extensions faster.'
    s.homepage          = 'https://github.com/marcelo-schroeder/IFACoreUI'
    s.license           = 'Apache-2.0'
    s.author            = { 'Marcelo Schroeder' => 'marcelo.schroeder@infoaccent.com' }
    s.platform          = :ios, '8.0'
    s.requires_arc      = true
    s.source            = { :git => 'https://github.com/marcelo-schroeder/IFACoreUI.git', :tag => 'v1.0.1' }
    s.source_files      = 'IFACoreUI/IFACoreUI/classes/**/*.{h,m}'
    s.resource          = 'IFACoreUI/IFACoreUI/resources/**/*.*'
    s.dependency 'IFAFoundation'
end
