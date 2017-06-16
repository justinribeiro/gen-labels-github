# gen-labels-github
Bash script that calls GitHub API, remove default repo labels, and adds new labels.

## Usage

```sh
➜ ./generateLabelsGithub.sh -h
    generateLabelsGithub.sh - Add labels to a specific GitHub repo and remove the default labels.

    Usage:
        -u  Your GitHub user name.
        -t  Personal access token for access to GitHub API: https://github.com/settings/tokens
        -o  The GitHub organization or user where the repo exists
        -r  The GitHub repository name 
    
    Labels:
        Edit this script to define the labels you want specific to your use case.

```

## Install

```sh
➜ wget https://raw.githubusercontent.com/justinribeiro/gen-labels-github/master/genLabelsGitHub.sh -O ~/.local/bin/genLabelsGitHub.sh
➜ chmod +x ~/.local/bin/genLabelsGitHub.sh
```

## Edit labels

All the labels are contained in the script itself (I gen the same set a lot with not a lot of variation). Simply edit the `LABELS` array:
```
declare -A LABELS
LABELS=(
  [somelabel]=somecolor
  [kind/bug]=FF8C94 
  ...
)
```

## Where did the labels come from?

Kind of a mix-match of some projects, but you can see a similar (though larger set) in [moby/moby](https://github.com/moby/moby).