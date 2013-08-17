Pod::Spec.new do |s|
  s.name         = 'VKIMClient'
  s.version      = '0.5'
  s.summary      = "Client library for https://github.com/Unact/REST-XMPP-Client server."
  s.homepage     = 'https://github.com/vkovtash/VKIMClient'

  s.license      = 'MIT'
  s.author       = { 'Vlad Kovtash' => 'v.kovtash@gmail.com' }
  s.source       = { :git => 'https://github.com/vkovtash/VKIMClient.git', :tag => s.version.to_s }

  s.platform     = :ios, '5.1'
  s.requires_arc = true
  s.source_files = 'VKIMClient/**/*.{h,m}'
  
  s.dependency  'RestKit', '= 0.20.2'
end
