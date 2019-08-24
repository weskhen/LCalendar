#
#  Be sure to run `pod spec lint LCalendar.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "LCalendar"
  s.version      = "0.0.2"
  s.summary      = "日历选择器"
  s.description  = <<-DESC
  一款比钉钉更友善的日历选择器, 顺畅无卡顿
                     DESC

  s.homepage     = "https://github.com/weskhen/LCalendar.git"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "wujian" => "wujian516411567@163.com" } 
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/weskhen/LCalendar.git", :tag => "#{s.version}" }
  
  s.ios.deployment_target = '9.0'
  s.module_name = 'LCalendar'
  s.dependency 'Masonry'

  s.subspec 'CalendarView' do |ss|
    ss.source_files = 'Public/CalendarView/*.{h,m}'
    ss.subspec 'CalendarCollectionView' do |sss|
      sss.source_files = 'Public/CalendarView/CalendarCollectionView/*.{h,m}'
    end
  end
  
  s.frameworks = "UIKit", "Foundation"
  s.requires_arc = true

end
