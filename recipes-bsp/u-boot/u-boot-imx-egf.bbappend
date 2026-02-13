
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
	    file://restricted-saved-env.cfg \
	    file://bootcount.cfg \
	    file://redund-env.cfg \
	    file://0001-Add-swupdate-env-common-include.patch \
	    file://0002-Add-swupdate-stuff-in-env.patch \
"

# TODO
# aggiungere il supporto e l'avvio del watchdog (anche nel kernel) (opzionale)