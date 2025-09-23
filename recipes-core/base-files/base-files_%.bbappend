
do_install:append () {
	install -m 0755 -d ${D}/mnt/data
	install -m 0755 -d ${D}/mnt/ota

	cat <<EOF >> ${D}${sysconfdir}/fstab

LABEL=data            /mnt/data                    ext4       defaults              0  2
LABEL=ota             /mnt/ota                     ext4       defaults              0  2
EOF
}

FILES:${PN} += "/mnt/data /mnt/ota"