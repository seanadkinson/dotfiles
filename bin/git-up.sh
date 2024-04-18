#!/bin/env zsh

# Add the following to your ~/.gitconfig
#
#  [alias]
#	   up = !zsh /path-to-this-script/git-up.sh
#
#  Then you can call
#
#     `git up`

# Remember current branch.
START_BRANCH=$(git branch --show-current --format='%(refname:short)')

get_local_branches() {
  # Gets local, which tracks origin.
  git branch -vv | grep origin | sed 's/*/ /g' | awk '{print $1}'
}

get_remote_branches() {
  git branch -r --format='%(refname:short)' | sed 's/origin\///' | grep -v HEAD
}

get_deleted_branches() {
  get_remote_branches | grep -Evf /dev/fd/0 <(get_local_branches) | awk '{print $1}'
}

get_new_branches() {
  get_local_branches | grep -Evf /dev/fd/0 <(get_remote_branches) | awk '{print $1}'
}

# Fetch latest.
# Updates only the view of remote branches and their commits.
# Does not fast forward local branches.
# Does not clone missing local remote branches.
git fetch --all -p >/dev/null

# Delete pruned local branches.
for branch in $(get_deleted_branches); do
  if [ "$branch" = "$START_BRANCH" ]; then
    printf "\n\nDeleting current branch \"%s\". Stashing changes and switching to master.\n" "$branch"

    # Go to the root dir in case branch switch removes current working dir.
    cd "$(git rev-parse --show-toplevel)" || exit 1
    git stash >/dev/null
    git checkout master >/dev/null
    START_BRANCH=master

    git branch -D "$branch" >/dev/null
  else
    git branch -D "$branch"
  fi

done

# Create missing local branches without switching to them.
for branch in $(get_new_branches); do
  git fetch . "origin/$branch:$branch" | grep -v "From ."
  git branch --set-upstream-to="origin/$branch" "$branch" > /dev/null
done

# Fast-forward all branches.
for branch in $(get_local_branches); do
  upstream=$(git config --get "branch.$branch.merge" | sed 's:refs/heads/::')
  if [ "$branch" = "$START_BRANCH" ]; then
    git merge --ff-only "origin/$upstream" | grep -v "Already up to date"
  else
    git fetch . "origin/$upstream:$branch"
  fi
done

echo ""
git branch -vv
echo ""
