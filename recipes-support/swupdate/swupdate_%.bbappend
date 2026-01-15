FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"

PACKAGECONFIG_CONFARGS = ""

SRC_URI += " \
	    file://09-swupdate-args \
	    file://swupdate.cfg \
	    file://swupdate.defaultenv \
"

# additional dependencies required to run swupdate on the target
RDEPENDS:${PN} += "u-boot-fw-utils"

python () {
    ### move the TMPDIR to SWU_TMPDIR ###
    # set SWU_TMPDIR in variables used to produce swupdate.socket file
    d.setVar('SWUPDATE_SOCKET_CTRL_PATH', d.getVar('SWU_TMPDIR') + '/sockinstctrl')
    d.setVar('SWUPDATE_SOCKET_PROGRESS_PATH', d.getVar('SWU_TMPDIR') + '/swupdateprog')
}

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

    ### move the TMPDIR to SWU_TMPDIR ###
    # install and set default env file for systemd files
    install -d ${D}${sysconfdir}/default
    install -m 644 ${WORKDIR}/swupdate.defaultenv ${D}${sysconfdir}/default/swupdate
    sed -i "s,@@SWU_TMPDIR@@,${SWU_TMPDIR},g" ${D}${sysconfdir}/default/swupdate

    # add the default env file in all systemd services
    sed -i \
    '\#\[Service\]#a EnvironmentFile=-/etc/default/swupdate' \
    ${D}${systemd_system_unitdir}/swupdate.service \
    ${D}${systemd_system_unitdir}/swupdate-progress.service \
    ${D}${systemd_system_unitdir}/swupdate-usb@.service
}