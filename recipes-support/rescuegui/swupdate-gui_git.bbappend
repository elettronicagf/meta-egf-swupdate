
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
	    file://config.txt;subdir=${S}/config \
	    file://set-right-fbdev-name.patch \
"

# remove unneeded systemd service
do_install:append () {
        rm -r ${D}${nonarch_base_libdir}/systemd
	rmdir ${D}${nonarch_base_libdir}
}

SYSTEMD_SERVICE:${PN} = ""