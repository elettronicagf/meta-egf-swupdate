
IMAGE_INSTALL:append = " \
			swupdate \
			swupdate-client \
			swupdate-progress \
			u-boot-fw-utils \
"

IMAGE_FSTYPES += "ext4.zst"

# allow SWUpdate to flash a .ext4 file and expand filesystem to partition limits
IMAGE_INSTALL:append = " e2fsprogs-resize2fs"

# SWUpdate partitioning
SWU_WKS_FILE ?= "imx-imx-boot-bootpart-ota.wks.in"
WKS_FILE = "${SWU_WKS_FILE}"