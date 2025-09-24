
# following section is taken from Styhead release
PACKAGECONFIG[gridnav] = ",,"

LVGL_CONFIG_LV_USE_GRIDNAV = "${@bb.utils.contains('PACKAGECONFIG', 'gridnav', '1', '0', d)}"

do_configure:append() {
    sed -r \
        -e "s|^([[:space:]]*#define LV_USE_GRIDNAV[[:space:]]).*|\1${LVGL_CONFIG_LV_USE_GRIDNAV}|" \
        -i "${S}/lv_conf.h"
}