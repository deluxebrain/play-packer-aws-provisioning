net user /add "$env:BUILD_USER" "$env:BUILD_USER_PASSWORD"
net localgroup administrators packer /add

