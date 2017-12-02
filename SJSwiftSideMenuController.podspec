#
# Be sure to run `pod lib lint SJSwiftSideMenuController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SJSwiftSideMenuController'
  s.version          = '0.2'
  s.summary          = 'SJSwiftSideMenuController is Side Menu Controller for both Side Left & Right Menu.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
SJSwiftSideMenuController is Side Menu Controller for both Side Left & Right Menu With Both type of Side menu That is SlideOver and SlideView.
By only this menu controller you can use both left and right side menu with both type of sliding menu that is SlideOver the main view and SlideView with the main view.
You have to just set property and the meny get reflect with you requirement.
                       DESC

  s.homepage         = 'https://github.com/sumitjagdev/SJSwiftSideMenuController'
#s.screenshots     = 'https://github.com/sumitjagdev/SJSwiftSideMenuController/blob/master/image01.png, https://github.com/sumitjagdev/SJSwiftSideMenuController/blob/master/image02.png, https://github.com/sumitjagdev/SJSwiftSideMenuController/blob/master/image03.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sumit Jagdev' => 'sumitjagdev3@gmail.com' }
  s.source           = { 
  :git => 'https://github.com/sumitjagdev/SJSwiftSideMenuController.git', 
  :tag => s.version.to_s 
  }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SJSwiftSideMenuController/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SJSwiftSideMenuController' => ['SJSwiftSideMenuController/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
end
