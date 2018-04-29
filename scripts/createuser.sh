#!/usr/bin/env bash
#
# based on blacklabelops script (https://raw.githubusercontent.com/blacklabelops/alpine/master/imagescripts/createuser.sh)
# origin author: Steffen Bleul <sbl@blacklabelops.com>
#

set -o errexit

readonly CUR_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

source $CUR_DIR/dockeruser.sh

dockerUser
printUserInfo
