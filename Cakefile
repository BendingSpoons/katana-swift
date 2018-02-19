project.name = "Katana"

# Katana Framework target
katana = target do |target|
    target.name = "Katana"
    target.platform = :ios
    target.deployment_target = 9.0
    target.language = :swift
    target.type = :framework
    target.include_files = [
        "Katana/**/*.swift",
    ]

    target.all_configurations.each do |configuration|
        configuration.settings["INFOPLIST_FILE"] = "Katana/Info.plist"
        configuration.settings["PRODUCT_NAME"] = "Katana"
	    configuration.settings["SWIFT_VERSION"] = "4.0"
    end

    target.headers_build_phase do |phase|
        phase.public << "Katana/Katana.h"
    end

    # unit_tests_for target do |unit_test|
    #     unit_test.linked_targets = [target]
    #     unit_test.include_files = [
    #         "KatanaTests/Animations/**/*.swift",
    #         "KatanaTests/Core/**/*.swift",
    #         "KatanaTests/Extensions/**/*.swift",
    #         "KatanaTests/IOS/**/*.swift",
    #         "KatanaTests/NodeDescriptions/**/*.swift",
    #         "KatanaTests/Plastic/**/*.swift",
    #         "KatanaTests/Storage/**/*.swift"
    #     ]

    #     unit_test.all_configurations.each do |configuration|
    #         configuration.settings["INFOPLIST_FILE"] = "KatanaTests/IOS/Info.plist"
	#     configuration.settings["SWIFT_VERSION"] = "4.0"
    #     end
    # end

    target.scheme(target.name)
end

# # iOS Demo target
# demo_ios = target do |target|
#     target.name = "Demo iOS"
#     target.platform = :ios
#     target.language = :swift
#     target.deployment_target = 9.0
#     target.type = :application
#     target.linked_targets = [katana_ios, katana_elements_ios]
    
#     target.include_files = [
#         "Demo/Common/**/*.swift",
#         "Demo/IOS/**/*.swift",
#         "Demo/IOS/LunchScreen.storyboard",
#     ]

#     target.all_configurations.each do |configuration|
#         configuration.product_bundle_identifier = "dk.bendingspoons.Demo"
#         configuration.settings["INFOPLIST_FILE"] = "Demo/IOS/Info.plist"
#         configuration.settings["PRODUCT_NAME"] = "Demo iOS"
# 	configuration.settings["SWIFT_VERSION"] = "4.0"
#     end

#     target.scheme(target.name)
# end