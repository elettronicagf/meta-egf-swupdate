#
# Reduced version of ext4 image: it does not contain data
# that is in folders that are mountpoints of external partitions.
# Standard ext4 image contains also data that is in folders that
# are mountpoints of external partitions: this data is copied into
# external partitions by wic (as stated in .wks file).
# Using this image allows to reduce the .swu file size (usually data
# that resides on partitions other than rootfs is not meant to be updated).
#

SWU_EXCLUDE_PATHS ?= "/mnt/data ${SWU_TMPDIR}"

IMAGE_ROOTFS_SWU = "${WORKDIR}/swu-rootfs"

oe_mkext4swufs () {

	rm -rf ${IMAGE_ROOTFS_SWU}
	cp -a ${IMAGE_ROOTFS} ${IMAGE_ROOTFS_SWU}

	# remove all contents not needed in .swu file
	# NOTE: delete also hidden data: to do this, use find command (no shopt here to set dotglob)
	for d in ${SWU_EXCLUDE_PATHS}
	do
		find ${IMAGE_ROOTFS_SWU}$d/ -mindepth 1 -delete
	done

	fstype=$1
	extra_imagecmd=""

	if [ $# -gt 1 ]; then
		shift
		extra_imagecmd=$@
	fi

	# If generating an empty image the size of the sparse block should be large
	# enough to allocate an ext4 filesystem using 4096 bytes per inode, this is
	# about 60K, so dd needs a minimum count of 60, with bs=1024 (bytes per IO)
	eval local COUNT=\"0\"
	eval local MIN_COUNT=\"60\"
	if [ $ROOTFS_SIZE -lt $MIN_COUNT ]; then
		eval COUNT=\"$MIN_COUNT\"
	fi
	# Create a sparse image block
	bbdebug 1 Executing "dd if=/dev/zero of=${IMGDEPLOYDIR}/${IMAGE_NAME}.$fstype seek=$ROOTFS_SIZE count=$COUNT bs=1024"
	dd if=/dev/zero of=${IMGDEPLOYDIR}/${IMAGE_NAME}.$fstype seek=$ROOTFS_SIZE count=$COUNT bs=1024
	bbdebug 1 "Actual Rootfs size:  `du -s ${IMAGE_ROOTFS_SWU}`"
	bbdebug 1 "Actual Partition size: `stat -c '%s' ${IMGDEPLOYDIR}/${IMAGE_NAME}.$fstype`"
	bbdebug 1 Executing "mkfs.ext4 -F $extra_imagecmd ${IMGDEPLOYDIR}/${IMAGE_NAME}.$fstype -d ${IMAGE_ROOTFS_SWU}"
	mkfs.ext4 -F $extra_imagecmd ${IMGDEPLOYDIR}/${IMAGE_NAME}.$fstype -d ${IMAGE_ROOTFS_SWU}
	# Error codes 0-3 indicate successfull operation of fsck (no errors or errors corrected)
	fsck.ext4 -pvfD ${IMGDEPLOYDIR}/${IMAGE_NAME}.$fstype || [ $? -le 3 ]
	rm -r ${IMAGE_ROOTFS_SWU}
	# shrink file
	resize2fs ${IMGDEPLOYDIR}/${IMAGE_NAME}.$fstype
}

IMAGE_CMD:ext4-swu = "oe_mkext4swufs ext4-swu ${EXTRA_IMAGECMD}"

EXTRA_IMAGECMD:ext4-swu ?= "-i 4096"

do_image_ext4-swu[depends] += "e2fsprogs-native:do_populate_sysroot"

IMAGE_TYPES:append = " ext4-swu"
