# Setup
echo execute Swiftformat
cd ../Tools
SDKROOT=(xcrun --sdk macosx --show-sdk-path)
#swift package update #Uncomment this line temporarily to update the version used to the latest matching your BuildTools/Package.swift file
swift run -c release swiftformat "$SRCROOT"
