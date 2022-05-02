#!/bin/sh

pip_url="https://bootstrap.pypa.io/get-pip.py"
agent_url="https://github.com/nginxinc/nginx-amplify-agent"
agent_conf_path="/etc/amplify-agent"
agent_conf_file="${agent_conf_path}/agent.conf"
nginx_conf_file="/etc/nginx/nginx.conf"
py3_min_ver="3.6"

set -e

install_warn1 () {
    echo "The script will install git, python (including libraries and headers), wget"
    echo "and possibly some other additional packages unless already found on this system."
    echo ""
    printf "Continue (y/n)? "
    #read line
    line=y
    test "${line}" = "y" -o "${line}" = "Y" || \
        exit 1
    echo ""
}

check_python () {
    printf "Checking if Python %s or newer exists ..." $py3_min_ver

    command -V python3 > /dev/null 2>&1 && py_command='python3'

    if [ -z "${py_command}" ]; then
        found_python='no'
        printf "\033[31m python3 could not be found!\033[0m\n\n"
        case "$os" in
            ubuntu|debian)
                printf "\033[32m Please check and install Python package:\033[0m\n\n"
                printf "     ${sudo_cmd}apt-cache pkgnames | grep ${python_package_deb}\n"
                printf "     ${sudo_cmd}apt-get install ${python_package_deb}\n\n"
                ;;
            centos|rhel|amzn)
                printf "\033[32m Please check and install Python package:\033[0m\n\n"
                printf "     ${sudo_cmd}yum list ${python_package_rpm}\n"
                printf "     ${sudo_cmd}yum install ${python_package_rpm}\n\n"
                ;;
        esac
    else
        python_version=`${py_command} -c 'import sys; print("{0}.{1}".format(sys.version_info[0], sys.version_info[1]))'`

        if [ $? -ne 0 ]; then
            printf "\033[31m failed to detect Python version!\033[0m\n\n"
            exit 1
        fi

        if [ $(echo "$python_version" | tr -d '.') -lt $(echo "$py3_min_ver" | tr -d '.') ]; then
            printf "\033[31m %s found!\033[0m\n\n" $python_version
            exit 1
        fi

        found_python='yes'
        printf " yes (%s)\n" "$($py_command --version)"
    fi
}

check_python_headers () {
    if [ "${found_python}" = 'no' ]; then
        echo 'no'
        return
    fi

    set +e
    INCLUDEPY=$(${py_command} -c 'import sysconfig as s; print(s.get_config_vars()["INCLUDEPY"])' 2>/dev/null)
    rc=$?
    set -e

    if [ $rc != 0 ]; then
        echo 'no'
        return
    fi

    test -f "$INCLUDEPY/Python.h" && echo 'yes' || echo 'no'
}

get_pip () {
    # check whether pip is already installed
    set +e
    ${py_command} -m pip --version >/dev/null 2>&1
    rc=$?
    set -e

    if [ $rc -eq 0 ]; then
        echo "${py_command} -m pip"
        return
    fi

    # try to install pip from OS repositories
    set +e
    case "$os" in
        freebsd)
            ${sudo_cmd} pkg install -y py$(echo $python_version | tr -d '.')-pip >&2
            ;;
        sles)
            ${sudo_cmd} zypper install -y python3-pip >&2
            ;;
        alpine)
            ${sudo_cmd} apk add py3-pip >&2
            ;;
        fedora)
            ${sudo_cmd} dnf -y install python3-pip >&2
            ;;
        *)
            false
            ;;
    esac
    rc=$?
    set -e

    if [ $rc -eq 0 ]; then
        echo "${py_command} -m pip"
        return
    fi

    # last resort - try to install pip via get-pip
    rm -f get-pip.py
    ${downloader} ${pip_url} >&2
    ${py_command} get-pip.py --ignore-installed --user >&2
    echo "${py_command} -m pip"
}

check_packages () {
    check_python

    for i in git wget curl gcc
    do
        printf "Checking if ${i} exists ... "
        if command -V ${i} >/dev/null 2>&1; then
            eval "found_${i}='yes'"
            echo 'yes'
        else
            eval "found_${i}='no'"
            echo 'no'
        fi
    done

    printf 'Checking if Python headers exists ... '
    found_python_dev=$(check_python_headers)
    echo $found_python_dev

    echo
}

# Detect the user for the agent to use
detect_amplify_user() {
    if [ -f "${agent_conf_file}" ]; then
        amplify_user=`grep -v '#' ${agent_conf_file} | \
                      grep -A 5 -i '\[.*nginx.*\]' | \
                      grep -i 'user.*=' | \
                      awk -F= '{print $2}' | \
                      sed 's/ //g' | \
                      head -1`

        nginx_conf_file=`grep -A 5 -i '\[.*nginx.*\]' ${agent_conf_file} | \
                         grep -i 'configfile.*=' | \
                         awk -F= '{print $2}' | \
                         sed 's/ //g' | \
                         head -1`
    fi

    if [ -f "${nginx_conf_file}" ]; then
        nginx_user=`grep 'user[[:space:]]' ${nginx_conf_file} | \
                    grep -v '[#].*user.*;' | \
                    grep -v '_user' | \
                    sed -n -e 's/.*\(user[[:space:]][[:space:]]*[^;]*\);.*/\1/p' | \
                    awk '{ print $2 }' | head -1`
    fi

    if [ -z "${amplify_user}" ]; then
        test -n "${nginx_user}" && \
        amplify_user=${nginx_user} || \
        amplify_user="nginx"
    fi
}

printf "\n --- This script will install the NGINX Amplify Agent from source ---\n\n"

# Detect root
if [ "`id -u`" = "0" ]; then
    sudo_cmd=""
else
    if command -V sudo >/dev/null 2>&1; then
        sudo_cmd="sudo "
        echo "HEADS UP - will use sudo, you need to be in sudoers(5)"
        echo ""
    else
        echo "Started as non-root, sudo not found, exiting."
        exit 1
    fi
fi

# if [ -n "$API_KEY" ]; then
#     api_key=$API_KEY
# else
#     echo " What's your API key? Please check the docs and the UI."
#     echo ""
#     printf " Enter your API key: "
#     read api_key
#     echo ""
# fi

if uname -m | grep "_64" >/dev/null 2>&1; then
    arch64="yes"
else
    arch64="no"
fi

printf " Please select your OS family: \n\n"
echo " 1. FreeBSD"
echo " 2. SLES"
echo " 3. Alpine"
echo " 4. Fedora"
echo " 5. Other"
echo ""
printf " ==> "

#read line
line=5
line=`echo $line | sed 's/^\(.\).*/\1/'`

echo ""

case $line in
    # FreeBSD
    1)
        os="freebsd"

        install_warn1
        check_packages

        if [ "${found_python}" = "no" ]; then
            ${sudo_cmd} pkg install -y python3
            check_python
        fi
        test "${found_git}" = "no" && ${sudo_cmd} pkg install -y git
        test "${found_wget}" = "no" -a "${found_curl}" = "no" &&  ${sudo_cmd} pkg install -y wget
        ;;
    # SLES
    2)
        os="sles"

        install_warn1
        check_packages

        if [ "${found_python}" = "no" ]; then
            ${sudo_cmd} zypper install -y python3
            check_python
        fi
        test "${found_python_dev}" = "no" && ${sudo_cmd} zypper install -y python3-devel
        test "${found_git}" = "no" && ${sudo_cmd} zypper install -y git
        test "${found_wget}" = "no" -a "${found_curl}" = "no" &&  ${sudo_cmd} zypper install -y wget
        ;;
    # Alpine
    3)
        os="alpine"

        install_warn1
        check_packages

        if [ "${found_python}" = "no" ]; then
            ${sudo_cmd} apk add --no-cache python3
            check_python
        fi
        test "${found_python_dev}" = "no" && ${sudo_cmd} apk add --no-cache python3-dev
        test "${found_git}" = "no" && ${sudo_cmd} apk add --no-cache git
        ${sudo_cmd} apk add --no-cache util-linux procps libffi-dev
        test "${found_wget}" = "no" -a "${found_curl}" = "no" &&  ${sudo_cmd} dnf -y install wget
        test "${found_gcc}" = "no" && ${sudo_cmd} apk add --no-cache gcc musl-dev linux-headers
        ;;
    # Fedora
    4)
        os="fedora"

        install_warn1
        check_packages

        if [ "${found_python}" = "no" ]; then
            ${sudo_cmd} dnf -y install python3
            check_python
        fi
        test "${found_python_dev}" = "no" && ${sudo_cmd} dnf -y install python3-devel
        test "${found_git}" = "no" && ${sudo_cmd} dnf -y install git
        test "${found_wget}" = "no" -a "${found_curl}" = "no" && ${sudo_cmd} dnf -y install wget
        test "${found_gcc}" = "no" && ${sudo_cmd} dnf -y install gcc redhat-rpm-config procps
        ;;
    5)
        echo "Before continuing with this installation script, please make sure that"
        echo "the following extra packages are installed on your system: git, Python $py3_min_ver or newer,"
        echo "Python development headers, wget and gcc. Please install them manually if needed."
        echo ""
        printf "Continue (y/n)? "
        #read line
        line=y
        echo ""
        test "${line}" = "y" -o "${line}" = "Y" || \
            exit 1

        check_packages
        ;;
    *)
        echo "Unrecognized option, exiting."
        echo ""
        exit 1
esac

if [ "$found_curl" = "yes" ]; then
    downloader="curl -fs -O"
elif [ "$found_wget" = "yes" ]; then
    downloader="wget -q"
else
    echo "no curl or wget found, exiting"
    exit 1
fi

# Set up Python stuff
PIP=$(get_pip)
printf "PIP version: $($PIP --version)\n\n"
$PIP install --user wheel
$PIP install --user setuptools netifaces distro

# Clone the Amplify Agent repo
${sudo_cmd} rm -rf nginx-amplify-agent
git clone ${agent_url}

# Install the Amplify Agent
cd nginx-amplify-agent

if [ "${os}" = "fedora" -a "${arch64}" = "yes" ]; then
    echo '[install]' > setup.cfg
    echo 'install-purelib=$base/lib64/python' >> setup.cfg
fi

REQUIREMENTS=packages/nginx-amplify-agent/requirements.txt
if [ -f packages/nginx-amplify-agent/requirements-py$(echo $python_version | tr -d '.').txt ]; then
    REQUIREMENTS=packages/nginx-amplify-agent/requirements-py$(echo $python_version | tr -d '.').txt
fi

SETUPPY=packages/nginx-amplify-agent/setup.py
if [ -f packages/nginx-amplify-agent/setup-py$(echo $python_version | tr -d '.').py ]; then
    SETUPPY=packages/nginx-amplify-agent/setup-py$(echo $python_version | tr -d '.').py
fi

printf "\nUsing requirements from: %s\nUsing setup.py from: %s\n\n" $REQUIREMENTS $SETUPPY

$PIP install --upgrade --target=amplify --no-compile -r $REQUIREMENTS

if [ "${os}" = "fedora" -a "${arch64}" = "yes" ]; then
    rm setup.cfg
fi

cp $SETUPPY ./setup.py
${py_command} setup.py build
${sudo_cmd} ${py_command} setup.py install
${sudo_cmd} install -o root -m755 nginx-amplify-agent.py /usr/bin/

if [ "$os" = "freebsd" ]; then
    py_executable=$($py_command -c 'import sys; print(sys.executable)')
    ${sudo_cmd} sed -i '' -e "1s,.*,\#\!${py_executable}," /usr/bin/nginx-amplify-agent.py
fi

# Generate new config file for the agent
${sudo_cmd} rm -f ${agent_conf_file}
${sudo_cmd} sh -c "sed -e 's/api_key.*$/api_key = $api_key/' ${agent_conf_file}.default > ${agent_conf_file}"
${sudo_cmd} chmod 644 ${agent_conf_file}

detect_amplify_user

if ! grep ${amplify_user} /etc/passwd >/dev/null 2>&1; then
    if [ "${os}" = "freebsd" ]; then
        ${sudo_cmd} pw user add ${amplify_user}
    elif [ "${os}" = "alpine" ]; then
        ${sudo_cmd} adduser -D -S -h /var/cache/nginx -s /sbin/nologin ${amplify_user}
    else
        ${sudo_cmd} useradd ${amplify_user}
    fi
fi

${sudo_cmd} chown ${amplify_user} ${agent_conf_path} >/dev/null 2>&1
${sudo_cmd} chown ${amplify_user} ${agent_conf_file} >/dev/null 2>&1

# Create directories for the agent in /var/log and /var/run
${sudo_cmd} mkdir -p /var/log/amplify-agent
${sudo_cmd} chmod 755 /var/log/amplify-agent
${sudo_cmd} chown ${amplify_user} /var/log/amplify-agent

${sudo_cmd} mkdir -p /var/run/amplify-agent
${sudo_cmd} chmod 755 /var/run/amplify-agent
${sudo_cmd} chown ${amplify_user} /var/run/amplify-agent

echo ""
echo " --- Finished successfully! --- "
echo ""
echo " To start the Amplify Agent use:"
echo ""
echo " # sudo -u ${amplify_user} ${py_command} /usr/bin/nginx-amplify-agent.py start \ "
echo "                   --config=/etc/amplify-agent/agent.conf \ "
echo "                   --pid=/var/run/amplify-agent/amplify-agent.pid"
echo ""
echo " To stop the Amplify Agent use:"
echo ""
echo " # sudo -u ${amplify_user} ${py_command} /usr/bin/nginx-amplify-agent.py stop \ "
echo "                   --config=/etc/amplify-agent/agent.conf \ "
echo "                   --pid=/var/run/amplify-agent/amplify-agent.pid"
echo ""

exit 0
