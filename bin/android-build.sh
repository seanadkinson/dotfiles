#!/usr/bin/env bash

function downloadBundle {
    echo ""
    echo "Downloading bundle, make sure packager is running"
    eval  curl "http://localhost:8081/index.android.bundle?platform=android" -o "/Users/seanadkinson/code/HthuNative/android/app/src/main/assets/index.android.bundle"
}

function buildRelease {
    echo ""
    echo "Building release..."
    cd /Users/seanadkinson/code/HthuNative/android
    eval ./gradlew assembleRelease
}

function signAPK {
    echo ""
    echo "Signing APK..."
    eval jarsigner -verbose -keystore /Users/seanadkinson/.android/debug.keystore /Users/seanadkinson/code/HthuNative/android/app/build/outputs/apk/app-release-unsigned.apk debug
}

function alignAPK {
    echo ""
    echo "Aligning APK..."
    eval zipalign -f -v 4 /Users/seanadkinson/code/HthuNative/android/app/build/outputs/apk/app-release-unsigned.apk /Users/seanadkinson/code/HthuNative/android/app/build/outputs/apk/app-release-aligned.apk
}

function installAPK {
    echo ""
    echo "Installing APK to device"
    eval adb install /Users/seanadkinson/code/HthuNative/android/app/build/outputs/apk/app-release-aligned.apk
}

if [ "$1" = "-install" ]; then
    installAPK
else
    downloadBundle
    buildRelease
    signAPK
    alignAPK
    installAPK
fi
