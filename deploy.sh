#!/bin/bash


echo "${TRAVIS_PULL_REQUEST}"
echo "${TRAVIS_EVENT_TYPE}"

git clone https://github.com/1haodian/incubator-eagle.git eagle
cd eagle
git checkout master
git status


echo "Git remote..."
git remote add upstream https://github.com/apache/incubator-eagle.git
git remote set-url origin "https://${GH_TOKEN}@${GH_REF}"

echo "Set git id..."
git config  user.name "Travis-CI"
git config  user.email "travis@yhd.com"

echo "Fetch..."
git fetch upstream

echo "Rebase..."
git rebase upstream/master 

echo "Pushing with force ..."
git push --force origin master > /dev/null 2>&1 || exit 1
echo "Pushed deployment successfully"

 # Is this not a build which was triggered by setting a new tag?
    if [ -z "$TRAVIS_TAG" ]; then
      echo -e "Starting to tag commit.\n"
      # Add tag and push to master.
      git tag -a eagle-v${TRAVIS_BUILD_NUMBER} -m "Travis build $TRAVIS_BUILD_NUMBER pushed a tag."
      git push origin --tags
      git fetch origin

      echo -e "Done magic with tags.\n"
  fi

exit 0
