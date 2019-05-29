Pod::Spec.new do |s|

  s.name         = "APLNetworkLayer"
  s.version      = "0.1.0"
  s.summary      = "APLNetworkLayer is a convenient interface for Apple's network framework that provides commonly used features."
  
  s.description  = <<-DESC
          This network layer is a wrapper for Apple's network classes and 
          functions that allows to use it conveniently made with Swift. It 
          provides all common features needed for network calls in iOS 
          development. 
                   DESC

  s.homepage     = "https://github.com/apploft/APLNetworkLayer.git"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author       = { "Christine Pühringer" => "christine.puehringer@apploft.de",
                     "Ahmet Akbal" => "ahmet.akbal@apploft.de" }
  
  s.swift_versions = ['4.0', '5.0']

  s.platform     = :ios, "11.0"

  s.source       = { :git => "https://github.com/apploft/APLNetworkLayer.git", :tag => s.version.to_s }

  s.source_files  = "Classes", "Classes/**/*.{swift}", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"

  s.requires_arc = true

  s.subspec 'Utilities' do |sp|
    sp.platform     = :ios, "10.0"
    sp.source_files = 'Utilities/Classes/**/*.{swift}'
  end

end
