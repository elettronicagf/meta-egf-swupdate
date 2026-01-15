
do_install:append () {
	install -m 0755 -d ${D}/mnt/data
	install -m 0755 -d ${D}${SWU_TMPDIR}

	cat <<EOF >> ${D}${sysconfdir}/fstab

LABEL=data            /mnt/data                    ext4       defaults              0  2
LABEL=ota             ${SWU_TMPDIR}                     ext4       defaults              0  2
EOF
}

FILES:${PN} += "/mnt/data ${SWU_TMPDIR}"