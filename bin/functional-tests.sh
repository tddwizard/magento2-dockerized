#!/usr/bin/env bash
set -e

while getopts ":t" opt; do
  case $opt in
    t)
      TROUBLESHOOTING=1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

#
# does not work in container?
#
#echo -e "\033[33mChecking requirements...\033[0m"
#if [ ! -d dev/tests/functional/vendor ]; then
#    echo -e "\033[34mPlease run 'composer install' in dev/tests/functional/vendor first\033[0m"
#    exit 1
#fi
#if [ ! -w dev/tests/functional ]; then
#    echo -e "\033[34mPlease make sure that dev/tests/functional is writable\033[0m"
#    exit 1
#fi
echo -e "\033[33mSetting Magento configuration...\033[0m"
./bin/magento config:set admin/security/use_form_key 0
./bin/magento config:set cms/wysiwyg/enabled disabled
./bin/magento config:set web/unsecure/base_url http://magento.lh/
./bin/magento config:set web/secure/base_url http://magento.lh/

cd dev/tests/functional
cp ./.htaccess.sample ./.htaccess

cd ./utils

if [ "$TROUBLESHOOTING" = 1 ]; then
    echo -e "\033[33mTroubleshooting...\033[0m"
    php -f mtf troubleshooting:check-all
fi
echo -e "\033[33mGenerating code...\033[0m"
/usr/local/bin/php generate.php

cd ..

echo -e "\033[33mRunning tests...\033[0m"
/usr/local/bin/php vendor/bin/phpunit
