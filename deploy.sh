#!/usr/bin/env sh

# 确保脚本抛出遇到的错误
set -e

echo "node version: $(node -v)"
echo "yarn version: $(yarn -v)"

echo "yarn install"

yarn install

echo "start building .......\n$BUILD_SCRIPT"
eval "$BUILD_SCRIPT"
echo "Building success"

echo "change dir"
ls -a
cd $BUILD_DIR

# shellcheck disable=SC2039

REPOSITORY_NAME="$TARGET_REPO"

# Get branch
# shellcheck disable=SC2039
DEPLOY_BRAN="$TARGET_BRANCH"
DEPLOY_REPO="https://enoracho:${ACCESS_TOKEN}@github.com/${REPOSITORY_NAME}.git"

echo "deploy"

echo ${USERNAME}
echo ${ACCESS_TOKEN}

git init
git config user.name "${USERNAME}"
git config user.email "${USERNAME}@enora.cho@gmail.com"

if [ "$CNAME" ]; then
  echo "Generating a CNAME file..."
  echo $CNAME > CNAME
fi

COMMIT_MESSAGE="Auto deploy from Github Actions"

git add .
git commit -m "$COMMIT_MESSAGE"
git status
git push --force $DEPLOY_REPO master:$DEPLOY_BRAN
rm -fr .git

cd $GITHUB_WORKSPACE

echo "Successfully deployed!" && \
echo "See: https://github.com/$REPOSITORY_NAME/tree/$DEPLOY_BRAN"