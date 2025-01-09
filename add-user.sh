#!/bin/bash

USERNAME="dev"
USER_UID="1000"
USER_GID="1000"

if id -u vscode > /dev/null 2>&1; then
    userdel vscode
    rm -R /home/vscode
elif id -u ubuntu > /dev/null 2>&1; then
    userdel ubuntu
    rm -R /home/ubuntu
fi

# Create a non-root user to match UID/GID.
groupadd --gid $USER_GID $USERNAME
useradd -s /bin/bash --uid $USER_UID --gid $USERNAME -m $USERNAME

# Add add sudo support for non-root user
if [ "${USERNAME}" != "root" ] && [ "${EXISTING_NON_ROOT_USER}" != "${USERNAME}" ]; then
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME
    chmod 0440 /etc/sudoers.d/$USERNAME
    EXISTING_NON_ROOT_USER="${USERNAME}"
fi

# *********************************
# ** Shell customization section **
# *********************************

if [ "${USERNAME}" = "root" ]; then
    user_home="/root"
# Check if user already has a home directory other than /home/${USERNAME}
elif [ "/home/${USERNAME}" != $( getent passwd $USERNAME | cut -d: -f6 ) ]; then
    user_home=$( getent passwd $USERNAME | cut -d: -f6 )
else
    user_home="/home/${USERNAME}"
    if [ ! -d "${user_home}" ]; then
        mkdir -p "${user_home}"
        chown ${USERNAME}:${group_name} "${user_home}"
    fi
fi

# *********************************
# ** Ensure config directory **
# *********************************
user_config_dir="${user_home}/.config"
if [ ! -d "${user_config_dir}" ]; then
    mkdir -p "${user_config_dir}"
    chown ${USERNAME}:${group_name} "${user_config_dir}"
fi
