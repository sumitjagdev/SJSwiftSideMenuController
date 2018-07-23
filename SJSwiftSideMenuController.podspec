
Pod::Spec.new do |s|
    s.name             = 'SJSwiftSideMenuController'
    s.version          = '1.1.1'
    s.summary          = 'SJSwiftSideMenuController is Side Menu Controller for both Side Left & Right Menu.'

    s.description      = <<-DESC
    SJSwiftSideMenuController is Side Menu Controller for both Side Left & Right Menu With Both type of Side menu That is SlideOver and SlideView.
    By only this menu controller you can use both left and right side menu with both type of sliding menu that is SlideOver the main view and SlideView with the main view.
    You have to just set property and the meny get reflect with you requirement.
    DESC

    s.homepage         = 'https://github.com/sumitjagdev/SJSwiftSideMenuController'

s.screenshots     ='https://raw.githubusercontent.com/sumitjagdev/SJSwiftSideMenuController/master/image01.png'

    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Sumit Jagdev' => 'sumitjagdev3@gmail.com' }
    s.source           = {
    :git => 'https://github.com/sumitjagdev/SJSwiftSideMenuController.git',
    :tag => s.version.to_s
    }

    s.ios.deployment_target = '8.0'

    s.source_files = 'SJSwiftSideMenuController/Classes/**/*'

    s.frameworks = 'UIKit'

end
