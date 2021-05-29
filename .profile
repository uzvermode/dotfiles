# xrdb -merge ~/.Xresources
export LC_TIME="en_GB.UTF-8"
export NO_AT_BRIDGE=1
export DE=xfce
export EDITOR=nano

# Imagemagick
export MAGICK_TEMPORARY_PATH=/tmp
export MAGICK_MEMORY_LIMIT=2048MB
export MAGICK_DISK_LIMIT=256MB
export MAGICK_MAP_LIMIT=4096MB

# JAVA + Android
export JAVA_HOME=/usr/lib/jvm/default
export ANDROID_SDK_ROOT=/home/coder/Devel/.env/android-sdk
export ANDROID_SDK_HOME=/home/coder/Devel/.env/emulator
export ANDROID_EMULATOR_HOME=/home/coder/Devel/.env/emulator
export GRADLE_USER_HOME=/home/coder/Devel/.env/gradle
export FLUTTER_HOME=/opt/flutter
export GOPATH=${HOME}/Devel/go
#export GOBIN={$GOPATH}/bin
export PATH=${HOME}/.bin:${GOPATH}/bin:${HOME}/.cargo/bin:${FLUTTER_HOME}/bin:${HOME}/.pub-cache/bin:${ANDROID_SDK_ROOT}/emulator:${PATH}
# export PATH=$HOME/.bin:$HOME/.cargo/bin:$PATH

#xmodmap ~/.Xmodmap

export QT_QPA_PLATFORMTHEME=gtk2
# export QT_STYLE_OVERRIDE=Matcha-sea
# Go
# export GOPATH=/home/data/dev/go
