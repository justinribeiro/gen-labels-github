#!/bin/bash
#===============================================================================
#
#          FILE:  genLabelsGitHub.sh
#
#         USAGE:  ./genLabelsGitHub.sh
#
#   DESCRIPTION:  Add labels to a specific GitHub repo and remove the 
#                 default labels.
#
#        AUTHOR:  Justin Ribeiro <justin@justinribeiro.com>
#===============================================================================

#
# Holders
#
OPTIND=1
user=""
token=""
org=""
repo=""
verbose=""

#
# Labels we want to create. Similar to those used by Docker,
# with a twist for just my own needs
#
declare -A LABELS
LABELS=( 
  [kind/bug]=FF8C94 
  [kind/enhancement]=E8CAAF
  [kind/experimental]=bfdadc
  [kind/feature]=AAB3AB
  [kind/performance]=006b75
  [kind/question]=EBEFC9
  [priority/P0]=e11d21
  [priority/P1]=eb6420
  [priority/P2]=EBEFC9
  [priority/P3]=fef2c0
  [platform/windows]=F6FBFF
  [platform/mac]=F6FBFF
  [platform/ios]=F6FBFF
  [platform/android]=F6FBFF
  [platform/chrome-os]=F6FBFF
  [platform/linux]=F6FBFF
  [browser/safari]=ececec
  [browser/firefox]=ececec
  [browser/chrome]=ececec
  [browser/edge]=ececec
  [browser/samsung]=ececec
  [browser/opera]=ececec
  [browser/brave]=ececec
  [browser/ancient]=ececec
  [area/api]=fbca04
  [area/docs]=fbca04
  [area/security]=fbca04
  [area/testing]=fbca04
  [area/ui-ux]=fbca04
  [exp/beginner]=3B8686
  [exp/intermediate]=3B8686
  [exp/expert]=3B8686
  [status/confirmed]=c2e0c6
  [status/up-for-grabs]=fef2c0
  [status/needs-more-info]=C6A49A
  [status/needs-confirmation]=C6A49A
  [roadmap]=eb6420
)

#
# Default labels to remove from repo
#
declare -A REMOVE_LABELS
REMOVE_LABELS=( 
    [bug]=0
    [duplicate]=0
    [enhancement]=0
    [help%20wanted]=0
    [invalid]=0
    [question]=0
    [wontfix]=0
)

usage () { 
    cat <<EOM
    $(basename $0) - Add labels to a specific GitHub repo and remove the default labels.

    Usage:
        -u  Your GitHub user name.
        -t  Personal access token for access to GitHub API: https://github.com/settings/tokens
        -o  The GitHub organization or user where the repo exists
        -r  The GitHub repository name 
    
    Labels:
        Edit this script to define the labels you want specific to your use case.

EOM
    exit 0
}

while getopts "u:t:o:r:vh" opt; do
    case "$opt" in
    u)  user=$OPTARG
        ;;
    t)  token=$OPTARG
        ;;
    o)  org=$OPTARG
        ;;
    r)  repo=$OPTARG
        ;;
    h|\?)
        usage
        exit 0
        ;;
    v)  verbose="-v"
        ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

#
# If we don't have four magic vars, then we can't actually do anything
#
if [[ -z "${user// }" ]] || [[ -z "${token// }" ]] || [[ -z "${org// }" ]] || [[ -z "${repo// }" ]]
then
    echo "Error: -u YOUR_GITHUB_USER -t GITHUB_PERSONAL_TOKEN -o GITHUB_ORG -r GITHUB_REPO must be defined." >&2
    exit 1
fi

# Define our target
api_endpoint="https://api.github.com/repos/$org/$repo/labels"

#
# Remove all the basic labels that Github adds when generating a repo
#
for keys in "${!REMOVE_LABELS[@]}";
do
    curl -u $user:$token $verbose -X DELETE $api_endpoint/$keys;
done

#
# Add our labels and colors
#
for keys in "${!LABELS[@]}";
do
    curl -u $user:$token $verbose -X POST -d '{"name":"'$keys'","color":"'${LABELS[$keys]}'"}' $api_endpoint;
done