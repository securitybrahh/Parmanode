function overview_conf_add {
overview_conf_remove "${1}"
echo "${1}" | tee -a $oc >/dev/null
}

function overview_conf_remove {
delete_line "$oc" "${1}"
}