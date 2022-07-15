alias gitlog='git log --pretty=format:"%h - %an, %ar : %s" -10'
alias gitpurgeoriginals="find . -type f -name '*.orig' -delete"
alias gitpurgebranches='git branch | grep -v "*" | xargs -I % git branch -d %'

function gitPurgeFile() {
  set -x
  filewithpath=$1
  if [ ! -f $filewithpath ]; then
    echo "file $filewithpath does not exist"
    return
  fi

  git filter-branch --force --index-filter \
    "git rm --cached --ignore-unmatch $filewithpath" \
    --prune-empty --tag-name-filter cat -- --all
  echo "$filewithpath" >>.gitignore

  grep "$filewithpath" .gitignore >/dev/null 2>&1
  if [ "$?" -eq "1" ]; then
    git add .gitignore
    git commit -m "Add $filewithpath to .gitignore"
  fi
  echo "Removed $filewithpath from your git repo. Execute 'git push origin --force --all' to apply these changes."
}

function git_lazy_push() {
  if [ -z ${1+x} ]; then MSG=$(git status -s); else MSG=$1; fi
  git add -A && git commit -m "$MSG" && git push
}

function git_unfuck_author() {
  # https://stackoverflow.com/questions/3042437/change-commit-author-at-one-specific-commit
  matchingEmail=$1
  replaceWith=$2
  for commit in $(git log --pretty=format:"%h - %an, %ar : %s : %ae" -100 | grep -i $matchingEmail | awk '{print $1}'); do
    echo $commit
    branch=$(git branch | grep '*' | awk '{print $2}')
    git checkout $commit &&
      git commit --amend --author $replaceWith --no-edit &&
      newcommit=$(git log --pretty=format:"%h" -1) &&
      git replace $commit $newcommit &&
      git filter-branch -f -- --all &&
      git replace -d $commit &&
      git checkout $branch
  done

}
