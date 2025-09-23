FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:class-target = " file://fw_env.config"

do_install:append:class-target() {
	install -d ${D}${sysconfdir}
	install -m 644 ${WORKDIR}/fw_env.config ${D}${sysconfdir}
}

FILES:${PN}:append:class-target = " ${sysconfdir}"

EXTRA_OECMAKE += "-DDEFAULT_ENV_FILE='/etc/u-boot-imx-egf-initial-env'"

RDEPENDS:${PN}:append:class-target = "u-boot-default-env"