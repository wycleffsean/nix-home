#! /usr/bin/sh

source "$SCRIPTDIR/share/utils.sh"

function depends_on {
    package_name=$1
    package="$XDG_CONFIG_HOME/${package_name}"
    info "depends on '${package_name}'"

    if [[ -x "${package}/check" ]];
    then
        "${package}/check"
        if [[ $? -eq 0 ]]; then return; fi
        if [[ -e "${package}/install" ]]
        then
            info "\tchecking '${package}'"
        else
            error "\tpackage '${cyan}${package_name}${default}' has no check script"
        fi
    else
	error "\tpackage '${cyan}${package_name}${default}' has no check script"
    fi
}
