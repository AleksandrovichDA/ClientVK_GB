# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'L1_AleksandrovichDenis' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'Alamofire', '~> 4.5’
  pod 'RealmSwift', '~> 3.0.2’
  pod 'SwiftyJSON'
  pod 'AlamofireImage', '~> 3.3'
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'FirebaseMessaging'

  # Pods for L1_AleksandrovichDenis

end

target 'iMessage' do
use_frameworks!
    pod 'RealmSwift', '~> 3.0.2’
end

def embedded_content_settings
    swift_version = Gem::Version.new(target_swift_version)
    should_embed = !target.requires_host_target? && pod_targets.any?(&:uses_swift?)
    embed_value = should_embed ? 'YES' : 'NO'

    puts 'Swift version is : #{swift_version}'
    puts swift_version
    puts target.native_target.resolved_build_setting('SWIFT_VERSION')
    puts target.native_target

    config = {
        'ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES' => embed_value,
        'EMBEDDED_CONTENT_CONTAINS_SWIFT' => embed_value,
    }

    if swift_version >= EMBED_STANDARD_LIBRARIES_MINIMUM_VERSION || !should_embed
        config.delete('EMBEDDED_CONTENT_CONTAINS_SWIFT')
    end

    config
end