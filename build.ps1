# Simple powershell script to build for multiple arches
# Will build arm/v7 and amd64 if no arguments specified
# To be able to run this script run: 
# "Set-ExecutionPolicy -Scope Process Unrestricted"
# This script uses docker buildx, which is still experimental
# To enable this add `"experimental": "enabled"` to ~/.docker/config.json

if ($args[0] =! "") {
    switch ($args[0]) {
        "armhf" { docker buidlx build --platform linux/arm/v7 .; break }
        "amd64" { docker buildx build --platform linux/amd64 .; break }
        Default { docker buildx build --platform linux/amd64,linux/arm/v7 .; break }
    }
}