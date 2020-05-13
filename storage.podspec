Pod::Spec.new do |s|
  s.name        = "Storage"
  s.version     = "1.0.2"
  s.summary     = "Elegant way to store data in Swift"
  s.homepage    = "https://github.com/siam-biswas/Storage"
  s.license     = { :type => "MIT" }
  s.authors     = { "Siam Biswas" => "siam.biswas@icloud.com" }

  s.requires_arc = true
  s.swift_version = "4.2"
  s.ios.deployment_target = "8.0"
  s.source   = { :git => "https://github.com/siam-biswas/Storage.git", :tag => s.version }
  s.source_files = "Source/Storage/*.swift"
end
