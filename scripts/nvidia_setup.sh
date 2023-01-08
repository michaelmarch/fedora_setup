packages="akmod-nvidia"

setup() {
    execute "sudo dracut --force"
    execute "sudo akmods --force"
}

#__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia
