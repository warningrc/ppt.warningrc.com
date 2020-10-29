#!/bin/bash
rm -rf ./publish

nodeppt release

rm -rf ./publish/.git

rsync -artvz --delete ./publish/ aliyun:/data/webroot/ppt/
