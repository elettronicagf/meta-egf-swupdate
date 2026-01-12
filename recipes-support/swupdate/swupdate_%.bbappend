FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"

PACKAGECONFIG_CONFARGS = ""

SRC_URI += " \
	    file://09-swupdate-args \
	    file://swupdate.cfg \
"

# additional dependencies required to run swupdate on the target
RDEPENDS:${PN} += "u-boot-fw-utils"

do_install:append() {
    install -m 0644 ${WORKDIR}/09-swupdate-args ${D}${libdir}/swupdate/conf.d/
    sed -i "s#@BOARDNAME@#${SWU_BOARDNAME}#g" ${D}${libdir}/swupdate/conf.d/09-swupdate-args
    sed -i "s#@BOARDREV@#${SWU_BOARDREV}#g" ${D}${libdir}/swupdate/conf.d/09-swupdate-args

    install -d ${D}${sysconfdir}
    install -m 644 ${WORKDIR}/swupdate.cfg ${D}${sysconfdir}

    # rename .swu file after an update via USB
    sed -i \
    '\#ExecStart=.*#a ExecStopPost=/bin/sh -c "NAME=$(ls /tmp/%I/*.swu 2>/dev/null | head -n 1); [ \\"$EXIT_STATUS\\" == \\"0\\" ] && S=OK || S=KO; [ -n \\"$NAME\\" ] && mv $NAME $NAME.$S || true"' \
    ${D}${systemd_system_unitdir}/swupdate-usb@.service
}

# TODO
# TMPDIR sullo storage anziché in RAM (opzionale)