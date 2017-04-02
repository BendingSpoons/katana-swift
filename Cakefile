project.name = "Katana"

project.all_configurations.each do |configuration|
    configuration.settings["SWIFT_VERSION"] = "3.0"
end

# Katana iOS Framework target
katana_ios = target do |target|
    target.name = "Katana iOS"
    target.platform = :ios
    target.deployment_target = 8.4
    target.language = :swift
    target.type = :framework
    target.include_files = [
        "Katana/Core/**/*.swift",
        "Katana/Extensions/**/*.swift",
        "Katana/iOS/**/*.swift",
        "Katana/Plastic/**/*.swift",
        "Katana/Store/**/*.swift"
    ]

    target.all_configurations.each do |configuration|
        configuration.settings["INFOPLIST_FILE"] = "Katana/iOS/Info.plist"
        configuration.settings["PRODUCT_NAME"] = "Katana"
    end

    target.headers_build_phase do |phase|
        phase.public << "Katana/iOS/Katana.h"
    end

    unit_tests_for target do |unit_test|
        unit_test.linked_targets = [target]
        unit_test.include_files = [
            "KatanaTests/Animations/**/*.swift",
            "KatanaTests/Core/**/*.swift",
            "KatanaTests/Extensions/**/*.swift",
            "KatanaTests/IOS/**/*.swift",
            "KatanaTests/NodeDescriptions/**/*.swift",
            "KatanaTests/Plastic/**/*.swift",
            "KatanaTests/Storage/**/*.swift"
        ]

        unit_test.all_configurations.each do |configuration|
            configuration.settings["INFOPLIST_FILE"] = "KatanaTests/IOS/Info.plist"
        end
    end

    target.scheme(target.name)
end


# Katana Elements iOS Framework target
katana_elements_ios = target do |target|
    target.name = "KatanaElements iOS"
    target.platform = :ios
    target.deployment_target = 8.4
    target.language = :swift
    target.type = :framework
    target.include_files = [
        "KatanaElements/Common/**/*.swift",
        "KatanaElements/iOS/**/*.swift"
    ]

    target.all_configurations.each do |configuration|
        configuration.settings["INFOPLIST_FILE"] = "KatanaElements/iOS/Info.plist"
        configuration.settings["PRODUCT_NAME"] = "KatanaElements"
    end

    target.headers_build_phase do |phase|
        phase.public << "KatanaElements/iOS/KatanaElements.h"
    end

    target.scheme(target.name)
end

# iOS Demo target
demo_ios = target do |target|
    target.name = "Demo iOS"
    target.platform = :ios
    target.language = :swift
    target.deployment_target = 8.4
    target.type = :application
    target.linked_targets = [katana_ios, katana_elements_ios]
    
    target.include_files = [
        "Demo/Common/**/*.swift",
        "Demo/IOS/**/*.swift",
        "Demo/IOS/LunchScreen.storyboard",
    ]

    target.all_configurations.each do |configuration|
        configuration.product_bundle_identifier = "dk.bendingspoons.Demo"
        configuration.settings["INFOPLIST_FILE"] = "Demo/IOS/Info.plist"
        configuration.settings["PRODUCT_NAME"] = "Demo iOS"
    end

    target.scheme(target.name)
end

# Katana MacOS Framework target
katana_macos = target do |target|
    target.name = "Katana macOS"
    target.platform = :osx
    target.deployment_target = "10.10"
    target.language = :swift
    target.type = :framework
    target.include_files = [
        "Katana/Core/**/*.swift",
        "Katana/Extensions/**/*.swift",
        "Katana/MacOS/**/*.swift",
        "Katana/Plastic/**/*.swift",
        "Katana/Store/**/*.swift"
    ]

    target.all_configurations.each do |configuration|
        configuration.settings["INFOPLIST_FILE"] = "Katana/MacOS/Info.plist"
        configuration.settings["PRODUCT_NAME"] = "Katana"
    end

    target.headers_build_phase do |phase|
        phase.public << "Katana/MacOS/Katana.h"
    end

    unit_tests_for target do |unit_test|
        unit_test.linked_targets = [target]
        unit_test.include_files = [
            "KatanaTests/Animations/**/*.swift",
            "KatanaTests/Core/**/*.swift",
            "KatanaTests/Extensions/**/*.swift",
            "KatanaTests/MacOS/**/*.swift",
            "KatanaTests/NodeDescriptions/**/*.swift",
            "KatanaTests/Plastic/**/*.swift",
            "KatanaTests/Storage/**/*.swift"
        ]

        unit_test.all_configurations.each do |configuration|
            configuration.settings["INFOPLIST_FILE"] = "KatanaTests/MacOS/Info.plist"
        end
    end

    target.scheme(target.name)
end

# Katana Elements macOS Framework target
katana_elements_macos = target do |target|
    target.name = "KatanaElements macOS"
    target.platform = :osx
    target.deployment_target = "10.10"
    target.language = :swift
    target.type = :framework
    target.include_files = [
        "KatanaElements/Common/**/*.swift",
        "KatanaElements/MacOS/**/*.swift"
    ]

    target.all_configurations.each do |configuration|
        configuration.settings["INFOPLIST_FILE"] = "KatanaElements/MacOS/Info.plist"
        configuration.settings["PRODUCT_NAME"] = "KatanaElements"
    end

    target.headers_build_phase do |phase|
        phase.public << "KatanaElements/MacOS/KatanaElements.h"
    end

    target.scheme(target.name)
end

# macOS Demo target
demo_macos = target do |target|
    target.name = "Demo MacOS"
    target.platform = :osx
    target.language = :swift
    target.deployment_target = "10.10"
    target.type = :application
    target.linked_targets = [katana_macos, katana_elements_macos]
    
    target.include_files = [
        "Demo/Common/**/*.swift",
        "Demo/macOS/**/*.swift",
        "Demo/macOS/LunchScreen.storyboard",
    ]

    target.all_configurations.each do |configuration|
        configuration.product_bundle_identifier = "dk.bendingspoons.Demo"
        configuration.settings["INFOPLIST_FILE"] = "Demo/macOS/Info.plist"
        configuration.settings["PRODUCT_NAME"] = "Demo macOS"
    end

    target.scheme(target.name)
end

project.targets.each do |target|
    target.shell_script_build_phase "Lint", <<-SCRIPT 
    if which swiftlint >/dev/null; then
        swiftlint
    else
        echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
    fi
    SCRIPT
end