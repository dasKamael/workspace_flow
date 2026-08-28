Pod::Spec.new do |s|
  s.name             = 'workspace_flow_system'
  s.version          = '0.1.0'
  s.summary          = 'macOS system bridge for Focus.'
  s.description      = 'Screens, app launching, accessibility window control, status item, login item, blocked page window.'
  s.homepage         = 'https://coodoo.de'
  s.license          = { :type => 'Proprietary' }
  s.author           = { 'coodoo GmbH' => 'info@coodoo.de' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '13.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
