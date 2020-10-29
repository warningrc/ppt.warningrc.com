#!/bin/bash
rm -rf ./dist

nodeppt build limiter.md

rm -rf ./dist/.git

rsync -artvz --delete ./dist/ aliyun:/data/webroot/ppt/
