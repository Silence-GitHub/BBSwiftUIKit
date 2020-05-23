Pod::Spec.new do |s|

  s.name         = 'BBSwiftUIKit'
  s.version      = '0.1.0'
  s.summary      = 'A SwiftUI library with powerful UIKit features.'

  s.description  = <<-DESC
                   Get and set scroll view `contentOffset`.
                   Set scroll view `isPagingEnabled`, `bounces` and other properties.
                   Pull down or up table view to refresh data or load more data.
                   Reload table view data or rows.
                   Scroll table view to the specific row.
                   Get and set page control `currentPage`.
                   DESC

  s.homepage     = 'https://github.com/Silence-GitHub/BBSwiftUIKit'

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author       = { 'Kaibo Lu' => 'lukaibolkb@gmail.com' }

  s.platform     = :ios, '13.0'

  s.swift_version = '5.0'

  s.source       = { :git => 'https://github.com/Silence-GitHub/BBSwiftUIKit.git', :tag => s.version }

  s.requires_arc = true

  s.source_files  = 'BBSwiftUIKit/BBSwiftUIKit/*.{h,swift}'

end
