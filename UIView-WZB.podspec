Pod::Spec.new do |s|
  s.name = "UIView-WZB"
  s.version = "2.0.0"
  s.summary = "Swift UIView helpers for drawing grid layouts and custom lines."
  s.homepage = "https://github.com/WZBbiao/UIView-WZB"
  s.license = "MIT"
  s.author = { "WZBbiao" => "544856638@qq.com" }
  s.platform = :ios, "11.0"
  s.module_name = "UIViewWZB"
  s.swift_version = "5.0"
  s.source = { :git => "https://github.com/WZBbiao/UIView-WZB.git", :tag => s.version }
  s.source_files = "Source/Swift/UIView+WZB/**/*.swift"
  s.frameworks = "UIKit"
end
