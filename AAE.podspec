Pod::Spec.new do |s|
  s.name             = 'AAE'
  s.version          = '0.4.0'
  s.summary          = 'A collection of utility classes and extensions'
  s.swift_version    = '5.0'

  s.description      = <<-DESC
These are extensions and classes that I use across projects.
                       DESC

  s.homepage         = 'https://github.com/anconaesselmann/AAE'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'anconaesselmann' => 'axel@anconaesselmann.com' }
  s.source           = { :git => 'https://github.com/anconaesselmann/AAE.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.watchos.deployment_target = '3.0'

  s.source_files = 'AAE/Classes/**/*'

  # s.resource_bundles = {
  #   'AAE' => ['AAE/Assets/*.png']
  # }

  s.dependency 'RxSwift', '= 5.0.0'
  s.ios.dependency 'RxCocoa', '= 5.0.0'
  s.dependency 'RxOptional', '= 4.0.0'
  s.dependency 'SDWebImage', '= 5.0'
  s.dependency 'Alamofire', '= 5.0.0-rc.1'
  s.dependency 'SafeCollectionAccess'
  s.ios.dependency 'constrain'
  s.dependency 'Contain'
  s.dependency 'LoadableResult'
  s.dependency 'RxLoadableResult'
  s.dependency 'KeychainQueryBuilder'
  s.dependency 'URN'
end
