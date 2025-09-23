FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"

PACKAGECONFIG_CONFARGS = ""

SRC_URI += " \
	    file://09-swupdate-args \
	    file://swupdate.cfg \
"

# additional dependencies required to run swupdate on the target
RDEPENDS:${PN} += "u-boot-fw-utils"

BOARDNAME ?= "${MACHINE}"
BOARDREV ?= "revA"

do_install:append() {
    install -m 0644 ${WORKDIR}/09-swupdate-args ${D}${libdir}/swupdate/conf.d/
    sed -i "s#@BOARDNAME@#${BOARDNAME}#g" ${D}${libdir}/swupdate/conf.d/09-swupdate-args
    sed -i "s#@BOARDREV@#${BOARDREV}#g" ${D}${libdir}/swupdate/conf.d/09-swupdate-args

    install -d ${D}${sysconfdir}
    install -m 644 ${WORKDIR}/swupdate.cfg ${D}${sysconfdir}
}

# TODO
# TMPDIR sullo storage anziché in RAM (opzionale)