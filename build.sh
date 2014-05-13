#!/bin/bash

set -e

IOSSDK_VER="7.1"
MYCFG="Release"
# MYCFG="Debug"

# xcodebuild -showsdks

cd framework
xcodebuild -project GPUImage.xcodeproj -target GPUImage -configuration ${MYCFG} -sdk iphoneos${IOSSDK_VER} build
xcodebuild -project GPUImage.xcodeproj -target GPUImage -configuration ${MYCFG} -sdk iphonesimulator${IOSSDK_VER} build
cd ..

cd build
# for the fat lib file
mkdir -p ${MYCFG}-iphone/lib
xcrun -sdk iphoneos lipo -create ${MYCFG}-iphoneos/libGPUImage.a ${MYCFG}-iphonesimulator/libGPUImage.a -output ${MYCFG}-iphone/lib/libGPUImage.a
xcrun -sdk iphoneos lipo -info ${MYCFG}-iphone/lib/libGPUImage.a
# for header files
mkdir -p ${MYCFG}-iphone/include
cp ../framework/Source/*.h ${MYCFG}-iphone/include
cp ../framework/Source/iOS/*.h ${MYCFG}-iphone/include

# Build static framework
mkdir -p GPUImage.framework/Versions/A
cp ${MYCFG}-iphone/lib/libGPUImage.a GPUImage.framework/Versions/A/GPUImage
mkdir -p GPUImage.framework/Versions/A/Headers
cp ${MYCFG}-iphone/include/*.h GPUImage.framework/Versions/A/Headers
ln -sfh A GPUImage.framework/Versions/Current
ln -sfh Versions/Current/GPUImage GPUImage.framework/GPUImage
ln -sfh Versions/Current/Headers GPUImage.framework/Headers
