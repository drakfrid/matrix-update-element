#!/bin/bash
# Script for semi-automatically updating Element Web
# Run from the directory where Element Web is located (e.g. /var/www/element/)
# Edit this script before running the first time

set -x # for debugging / more info

read -p "Version? (e.g. 1.11.30) " _version

echo "downloading from gh"
wget https://github.com/vector-im/element-web/releases/download/v"$_version"/element-v"$_version".tar.gz.asc https://github.com/vector-im/element-web/releases/download/v"$_version"/element-v"$_version".tar.gz

if [ "$?" -ne 0 ]; then exit; fi

echo "verifying"
# You need to have imported the element release key to do this (https://github.com/vector-im/element-web#getting-started)
gpg --verify element-v"$_version".tar.gz.asc element-v"$_version".tar.gz
read -p "Is the signature good? (y/n) " _good
case "$_good" in 
  y|Y ) echo "yes";;
  n|N ) echo "no" && exit;;
  * ) echo "invalid" && exit;;
esac

echo "untar"
tar -xzf element-v"$_version".tar.gz

# Copy old files
# echo "copying modified files from old version"
# cp element/{config.json,welcome.html} element-v"$_version"/

echo "changing owner"
chown -R www-data:www-data element-v"$_version"

echo "create new link"
rm element && ln -s /var/www/element.site/element-v"$_version" /var/www/element.site/element

echo "delete downloaded files"
rm element-v"$_version".tar.gz.asc element-v"$_version".tar.gz
