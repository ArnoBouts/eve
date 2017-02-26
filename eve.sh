#!/bin/sh

: ${PLUGIN_ACTION:="commit"}
: ${PLUGIN_GIT_USER_NAME:="Eve"}
: ${PLUGIN_GIT_USER_EMAIL:="eve@no-cloud.fr"}
: ${PLUGIN_GIT_REPOSITORY:=$(echo ${DRONE_REPO_LINK} | sed -e 's/-eve//1')}
: ${PLUGIN_GIT_USER:=${DRONE_REPO_OWNER}}

clone() {
	mkdir eve
	echo "Cloning ${PLUGIN_GIT_REPOSITORY}"
	git clone -q ${PLUGIN_GIT_REPOSITORY} eve
}

commit() {

	cd eve

	if [ "$(git status -s)" = "" ]
	then
		echo "Allready up-to-date"
		exit 0
	fi

	git config --global user.name "${PLUGIN_GIT_USER_NAME}"
	git config --global user.email "${PLUGIN_GIT_USER_EMAIL}"
	git config --global push.default simple

	echo ${PLUGIN_GIT_REPOSITORY} | sed -e "s#https://#https://${PLUGIN_GIT_USER}:${PLUGIN_GIT_PASSWORD}@#1" >> ~/.git-credentials
	git config --global credential.helper store
 
	git commit -a -m "Auto update"

	git push
}

if [ "${PLUGIN_ACTION}" = "clone" ]
then
	clone
elif [ "${PLUGIN_ACTION}" = "commit" ]
then
	commit
fi
