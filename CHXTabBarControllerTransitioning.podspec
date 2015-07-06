Pod::Spec.new do |s|
  s.name         = "CHXTabBarControllerTransitioning"
  s.version      = "0.2"
  s.summary      = "UITabBarController Transitioning animation!"
  s.homepage     = "https://github.com/atcuan/CHXTabBarControllerTransitioning"
  s.license      = "MIT"
  s.author             = { "Moch" => "atcuan@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/atcuan/CHXTabBarControllerTransitioning.git",
:tag => s.version.to_s }
  s.requires_arc = true
  s.source_files  = "CHXTabBarControllerTransitioning/Source/*.{h,m}"
  s.frameworks = 'Foundation', 'UIKit'
end
