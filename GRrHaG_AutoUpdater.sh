
#################################################################################################################
##                        AutoUpdater by GRrHaG                                                                ##
##       https://github.com/GRrHaG/Freqtrade_Strategy_AutoUpdater.git                                          ##
##                                                                                                             ##
##            Auto Uptdater For Freqtrade and strategy                                                         ##
##                                                                                                             ##
#################################################################################################################
##               GENERAL RECOMMENDATIONS                                                                       ##
##  Add script to crontab :                                                                                    ##
##        typing "crontab -e" in terminal                                                                      ##
##        write on the bottom of the file: */5 * * * * bash -lc [YOUR AUTOUPDATER PATH]/GRrHaG_AutoUpdater.sh  ##
##               example : */5 * * * * bash -lc /home/pi/ft_userdata/tools/GRrHaG_AutoUpdater.sh               ##
##        use ctrl+o for save crontab and ctrl+x for quit crontab                                              ##
##        cd [YOUR AUTOUPDATER PATH]                                                                           ##
##        chmod +x GRrHaG_AutoUpdater.sh                                                                       ##
##                                                                                                             ##
#################################################################################################################
##               DONATIONS                                                                                     ##
##                                                                                                             ##
##   BTC:  1KNscj7drzt2DUUTQXYorxzFmVJcuZ2AQq                                                                  ##
##   ETH (ERC20):  0x82edaf1338450976ef97112ca7b80ed2df2f5208                                                  ##
##   BEP20/BSC (USDT, ETH, BNB, ...) :  0x82edaf1338450976ef97112ca7b80ed2df2f5208                             ##
##   TRC20/TRON (USDT, TRON, ...):  TGFwrnCn2tVU8RWESGhWbqKaCsLPUVZHbw                                         ##
##                                                                                                             ##
##               REFERRAL LINKS                                                                                ##
##                                                                                                             ##
##  Binance: https://accounts.binance.com/fr/register?ref=44193596                                             ##
##  Kucoin: https://www.kucoin.com/ucenter/signup?rcode=2N8fcx3                                                ##
#################################################################################################################


#!/bin/bash

GRRHAG_AUTOUPDATER_VERSION="1.09"
TIMESTAMP_YMD=$(date +"%Y-%m-%d")
TIMESTAMP_HM=$(date +"%H:%M")
TIMESTAMP_H=$(date +"%H")
TIMESTAMP_M=$(date +"%M")

AUTOUPDATER_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

CONFIG=$(cat ${AUTOUPDATER_PATH}/config_autoupdater.json)

ALLOW_UPDATE_AUTOUPDATER=$(cat ${AUTOUPDATER_PATH}/config_autoupdater.json | grep -o '\"ALLOW_UPDATE_AUTOUPDATER\": \".*' | sed "s/\"ALLOW_UPDATE_AUTOUPDATER\": \"//g"| sed 's/\",//')
ALLOW_UPDATE_FREQTRADE=$(cat ${AUTOUPDATER_PATH}/config_autoupdater.json | grep -o '\"ALLOW_UPDATE_FREQTRADE\": \".*' | sed "s/\"ALLOW_UPDATE_FREQTRADE\": \"//g"| sed 's/\",//')
ALLOW_UPDATE_STRATEGY=$(cat ${AUTOUPDATER_PATH}/config_autoupdater.json | grep -o '\"ALLOW_UPDATE_STRATEGY\": \".*' | sed "s/\"ALLOW_UPDATE_STRATEGY\": \"//g"| sed 's/\",//')
ALLOW_UPDATE_BLACKLIST=$(cat ${AUTOUPDATER_PATH}/config_autoupdater.json | grep -o '\"ALLOW_UPDATE_BLACKLIST\": \".*' | sed "s/\"ALLOW_UPDATE_BLACKLIST\": \"//g"| sed 's/\",//')
ALLOW_BLACKLIST_DETAIL=$(cat ${AUTOUPDATER_PATH}/config_autoupdater.json | grep -o '\"ALLOW_BLACKLIST_DETAIL\": \".*' | sed "s/\"ALLOW_BLACKLIST_DETAIL\": \"//g"| sed 's/\",//')
ALLOW_UPDATE_PAIRLIST=$(cat ${AUTOUPDATER_PATH}/config_autoupdater.json | grep -o '\"ALLOW_UPDATE_PAIRLIST\": \".*' | sed "s/\"ALLOW_UPDATE_PAIRLIST\": \"//g"| sed 's/\",//')
ALLOW_REBOOT=$(cat ${AUTOUPDATER_PATH}/config_autoupdater.json | grep -o '\"ALLOW_REBOOT\": \".*' | sed "s/\"ALLOW_REBOOT\": \"//g"| sed 's/\",//')
BOT_STRATEGY_NAME=$(cat ${AUTOUPDATER_PATH}/config_autoupdater.json | grep -o '\"BOT_STRATEGY_NAME\": \".*' | sed "s/\"BOT_STRATEGY_NAME\": \"//g"| sed 's/\",//')
BOT_PAIRLIST_NAME=$(cat ${AUTOUPDATER_PATH}/config_autoupdater.json | grep -o '\"BOT_PAIRLIST_NAME\": \".*' | sed "s/\"BOT_PAIRLIST_NAME\": \"//g"| sed 's/\",//')
BOT_BLACKLIST_NAME=$(cat ${AUTOUPDATER_PATH}/config_autoupdater.json | grep -o '\"BOT_BLACKLIST_NAME\": \".*' | sed "s/\"BOT_BLACKLIST_NAME\": \"//g"| sed 's/\",//')
FREQTRADE_HOME_PATH=$(cat ${AUTOUPDATER_PATH}/config_autoupdater.json | grep -o '\"FREQTRADE_HOME_PATH\": \".*' | sed "s/\"FREQTRADE_HOME_PATH\": \"//g"| sed 's/\",//')
FREQTRADE_STRATEGY_PATH=$(cat ${AUTOUPDATER_PATH}/config_autoupdater.json | grep -o '\"FREQTRADE_STRATEGY_PATH\": \".*' | sed "s/\"FREQTRADE_STRATEGY_PATH\": \"//g"| sed 's/\",//')
FREQTRADE_PAIRLIST_PATH=$(cat ${AUTOUPDATER_PATH}/config_autoupdater.json | grep -o '\"FREQTRADE_PAIRLIST_PATH\": \".*' | sed "s/\"FREQTRADE_PAIRLIST_PATH\": \"//g"| sed 's/\",//')
FREQTRADE_BLACKLIST_PATH=$(cat ${AUTOUPDATER_PATH}/config_autoupdater.json | grep -o '\"FREQTRADE_BLACKLIST_PATH\": \".*' | sed "s/\"FREQTRADE_BLACKLIST_PATH\": \"//g"| sed 's/\",//')
URL_GIT_FREQTRADE=$(cat ${AUTOUPDATER_PATH}/config_autoupdater.json | grep -o '\"URL_GIT_FREQTRADE\": \".*' | sed "s/\"URL_GIT_FREQTRADE\": \"//g"| sed 's/\",//')
URL_GIT_STRATEGY=$(cat ${AUTOUPDATER_PATH}/config_autoupdater.json | grep -o '\"URL_GIT_STRATEGY\": \".*' | sed "s/\"URL_GIT_STRATEGY\": \"//g"| sed 's/\",//')
telegram_token=$(cat ${AUTOUPDATER_PATH}/config_autoupdater.json | grep -o '\"token\": \".*' | sed "s/\"token\": \"//g"| sed 's/\",//')
telegram_chat_id=$(cat ${AUTOUPDATER_PATH}/config_autoupdater.json | grep -o '\"chat_id\": \".*' | sed "s/\"chat_id\": \"//g"| sed 's/\",//')
DOWNLOAD_STRATEGY_PATH=$(cat ${AUTOUPDATER_PATH}/config_autoupdater.json | grep -o '\"DOWNLOAD_STRATEGY_PATH\": \".*' | sed "s/\"DOWNLOAD_STRATEGY_PATH\": \"//g"| sed 's/\",//')
DOWNLOAD_AUTOUPDATER_PATH=$(cat ${AUTOUPDATER_PATH}/config_autoupdater.json | grep -o '\"DOWNLOAD_AUTOUPDATER_PATH\": \".*' | sed "s/\"DOWNLOAD_AUTOUPDATER_PATH\": \"//g"| sed 's/\",//')
INSTALLER=$(cat ${AUTOUPDATER_PATH}/config_autoupdater.json | grep -o '\"INSTALLER\": \".*' | sed "s/\"INSTALLER\": \"//g"| sed 's/\",//')
CUSTOM_CMD_VERSION=$(cat ${AUTOUPDATER_PATH}/config_autoupdater.json | grep -o '\"CUSTOM_CMD_VERSION\": \".*' | sed "s/\"CUSTOM_CMD_VERSION\": \"//g"| sed 's/\",//')
CUSTOM_CMD_ACTIVATE_VE=$(cat ${AUTOUPDATER_PATH}/config_autoupdater.json | grep -o '\"CUSTOM_CMD_ACTIVATE_VE\": \".*' | sed "s/\"CUSTOM_CMD_ACTIVATE_VE\": \"//g"| sed 's/\",//')
CUSTOM_CMD_CLOSE_VE=$(cat ${AUTOUPDATER_PATH}/config_autoupdater.json | grep -o '\"CUSTOM_CMD_CLOSE_VE\": \".*' | sed "s/\"CUSTOM_CMD_CLOSE_VE\": \"//g"| sed 's/\",//')

CUSTOM_CMD_START=$(cat ${AUTOUPDATER_PATH}/config_autoupdater.json | grep -o '\"CUSTOM_CMD_START\": \".*' | sed "s/\"CUSTOM_CMD_START\": \"//g"| sed 's/\",//')
CUSTOM_CMD_STOP=$(cat ${AUTOUPDATER_PATH}/config_autoupdater.json | grep -o '\"CUSTOM_CMD_STOP\": \".*' | sed "s/\"CUSTOM_CMD_STOP\": \"//g"| sed 's/\",//')
CUSTOM_CMD_PULL=$(cat ${AUTOUPDATER_PATH}/config_autoupdater.json | grep -o '\"CUSTOM_CMD_PULL\": \".*' | sed "s/\"CUSTOM_CMD_PULL\": \"//g"| sed 's/\",//')
CUSTOM_CMD_BUILD=$(cat ${AUTOUPDATER_PATH}/config_autoupdater.json | grep -o '\"CUSTOM_CMD_BUILD\": \".*' | sed "s/\"CUSTOM_CMD_BUILD\": \"//g"| sed 's/\",//')

url_git_autoupdater=https://api.github.com/repos/GRrHaG/AutoUpdater/releases/latest
latest_version_autoupdater=$(curl -s ${url_git_autoupdater} | grep -o '"tag_name": ".*"' | sed 's/"tag_name": "//' | sed 's/"//')
latest_version_freqtrade=$(curl -s ${URL_GIT_FREQTRADE} | grep -o '"tag_name": ".*"' | sed 's/"tag_name": "//' | sed 's/"//')
strategy_version=$(curl -s ${URL_GIT_STRATEGY} | grep -o '"tag_name": ".*"' | sed 's/"tag_name": "//' | sed 's/"//')
git_tarball_url=$(curl -s ${URL_GIT_STRATEGY} | grep -o '"tarball_url": ".*"' | sed 's/"tarball_url": "//' | sed 's/"//')
git_tarball_autoupdater_url=$(curl -s ${url_git_autoupdater} | grep -o '"tarball_url": ".*"' | sed 's/"tarball_url": "//' | sed 's/"//')
LATEST_STRATEGY_PATH=${DOWNLOAD_STRATEGY_PATH}"/NostalgiaForInfinity-"${strategy_version}
LATEST_AUTOUPDATER_PATH=${DOWNLOAD_AUTOUPDATER_PATH}"/AutoUpdater-"${latest_version_autoupdater}


SEND_START="<b>$TIMESTAMP_YMD $TIMESTAMP_HM :</b><b> New Update Found</b>"
SEND_N_U_FT="<pre>Freqtrade v"$latest_version_freqtrade"</pre>"
BlacklistDetail="<b>Blacklist Detail : </b>"
ExchangeTokens="<b>   Exchange Tokens</b>"
LeverageTokens="<b>   Leverage Tokens</b>"
StableTokens="<b>   Stable Tokens</b>"
FANTokens="<b>   FAN Tokens</b>"
OtherCoins="<b>   Other Coins</b>"
SEND_RELOAD="<pre>   Reload Freqtrade ... </pre>"
SEND_INSTALL_RELOAD="<pre>   Install and Reload Freqtrade ... </pre>"
SEND_RELOADED="<pre>   Reload has been completed!</pre>"
SEND_TIMESTAMP="$TIMESTAMP_YMD $TIMESTAMP_HM :"


if [ -e ${AUTOUPDATER_PATH}/history_autoupdater.txt ]; then
echo "$SEND_TIMESTAMP History Log File found"
Log_ID=$(cat ${AUTOUPDATER_PATH}/history_autoupdater.txt | grep -o 'ID=.* ;' | sed ':a;$q;N;1,$D;ba' | sed "s/ID=//g"| sed 's/ //' | sed 's/;//') 
strategy_version_log=$(cat ${AUTOUPDATER_PATH}/history_autoupdater.txt | grep -o 'Strategy_Update=.*' | sed "s/Strategy_Update=//g"| sed 's/ //' | sed ':a;$q;N;1,$D;ba') 
version_freqtrade_log=$(cat ${AUTOUPDATER_PATH}/history_autoupdater.txt | grep -o 'Freqtrade_Update=.*' | sed "s/Freqtrade_Update=//g"| sed 's/ //' | sed ':a;$q;N;1,$D;ba') 
nb_update_today_log=$(cat ${AUTOUPDATER_PATH}/history_autoupdater.txt | grep -c $TIMESTAMP_YMD) 
else
echo "$SEND_TIMESTAMP History Log File don't exist"
Log_ID=0
strategy_version_log="empty"
version_freqtrade_log="empty"
fi

if [ -e ${AUTOUPDATER_PATH}/history_autoupdater_error.txt ]; then
echo "$SEND_TIMESTAMP History ERROR Log File found"
Log_error_ID=$(cat ${AUTOUPDATER_PATH}/history_autoupdater_error.txt | grep -o 'ID=.* ;' | sed ':a;$q;N;1,$D;ba' | sed "s/ID=//g"| sed 's/ //' | sed 's/;//') 
nb_error_log=$(cat ${AUTOUPDATER_PATH}/history_autoupdater_error.txt | grep -c $TIMESTAMP_YMD) 
else
echo "$SEND_TIMESTAMP History Log File don't exist"
Log_error_ID=0
nb_error_log="0"
fi

echo "$SEND_TIMESTAMP STARTING SCRIPT"
echo "$SEND_TIMESTAMP AutoUpdater Version : $GRRHAG_AUTOUPDATER_VERSION"
echo "$SEND_TIMESTAMP Installer : $INSTALLER"
echo "$SEND_TIMESTAMP CONFIGURATION :"
echo "$SEND_TIMESTAMP Allow Update AutoUpdater : $ALLOW_UPDATE_AUTOUPDATER"
echo "$SEND_TIMESTAMP Allow Update Freqtrade : $ALLOW_UPDATE_FREQTRADE"
echo "$SEND_TIMESTAMP Allow Update Strategy : $ALLOW_UPDATE_STRATEGY"
echo "$SEND_TIMESTAMP Allow Update Blacklist : $ALLOW_UPDATE_BLACKLIST"
echo "$SEND_TIMESTAMP Allow Blacklist Detail : $ALLOW_BLACKLIST_DETAIL"
echo "$SEND_TIMESTAMP Allow Update Pailist : $ALLOW_UPDATE_PAIRLIST"
echo "$SEND_TIMESTAMP Allow Reboot : $ALLOW_REBOOT"
echo "$SEND_TIMESTAMP Strategy Name : $BOT_STRATEGY_NAME"
echo "$SEND_TIMESTAMP Pairlist Name : $BOT_PAIRLIST_NAME"
echo "$SEND_TIMESTAMP Blacklist Name : $BOT_BLACKLIST_NAME"
echo "$SEND_TIMESTAMP Freqtrade Home Path : $FREQTRADE_HOME_PATH"
echo "$SEND_TIMESTAMP Freqtrade Strategy Path : $FREQTRADE_STRATEGY_PATH"
echo "$SEND_TIMESTAMP Freqtrade Pairlist Path : $FREQTRADE_PAIRLIST_PATH"
echo "$SEND_TIMESTAMP Freqtrade Blacklist Path : $FREQTRADE_BLACKLIST_PATH"
echo "$SEND_TIMESTAMP URL GIT Freqtrade : $URL_GIT_FREQTRADE"
echo "$SEND_TIMESTAMP URL GIT Strategy : $URL_GIT_STRATEGY"

echo "$SEND_TIMESTAMP Latest Version of Freqtrade on Github : $latest_version_freqtrade"
echo "$SEND_TIMESTAMP Latest Version of Freqtrade on history_log : $version_freqtrade_log"
echo "$SEND_TIMESTAMP Latest Version of Strategy on Github : $strategy_version"
echo "$SEND_TIMESTAMP Latest Version of Strategy on history_log : $strategy_version_log"

echo "$SEND_TIMESTAMP URL for Donwload Latest Version of Strategy : $git_tarball_url"

if [ "$INSTALLER" == "docker-compose" ] ; then
cd $FREQTRADE_HOME_PATH 
EXE_FREQTRADE_VERSION(){
    version_freqtrade=$(docker-compose run --rm freqtrade --version)
    version_freqtrade=$(sed "s/freqtrade//g" <<< $version_freqtrade)
    version_freqtrade=$(sed ':a;N;$!ba;s/\r//g' <<< $version_freqtrade)
    version_freqtrade=$(sed ':a;N;$!ba;s/\n//g' <<< $version_freqtrade)

  }
EXE_FREQTRADE_PULL(){
    docker-compose stop  
    docker-compose pull
    docker-compose build 
    docker-compose up -d
  }
EXE_FREQTRADE_RESTART(){
    docker-compose stop  
    docker-compose build 
    docker-compose up -d 
  }
  
elif [ "$INSTALLER" == "sudo docker-compose" ] ; then
cd $FREQTRADE_HOME_PATH 
EXE_FREQTRADE_VERSION(){      
    version_freqtrade=$(sudo docker-compose run --rm freqtrade --version)
    version_freqtrade=$(sed "s/freqtrade//g" <<< $version_freqtrade)
    version_freqtrade=$(sed ':a;N;$!ba;s/\r//g' <<< $version_freqtrade)
    version_freqtrade=$(sed ':a;N;$!ba;s/\n//g' <<< $version_freqtrade)
  }
EXE_FREQTRADE_PULL(){
    sudo docker-compose stop  
    sudo docker-compose pull
    sudo docker-compose build 
    sudo docker-compose up -d
  }
EXE_FREQTRADE_RESTART(){
    sudo docker-compose stop  
    sudo docker-compose build 
    sudo docker-compose up -d 
  }
elif [ "$INSTALLER" == "custom" ] ; then 
EXE_FREQTRADE_VERSION(){
    $CUSTOM_CMD_ACTIVATE_VE
    version_freqtrade=$CUSTOM_CMD_VERSION
    version_freqtrade=$(sed "s/freqtrade//g" <<< $version_freqtrade)
    version_freqtrade=$(sed ':a;N;$!ba;s/\r//g' <<< $version_freqtrade)
    version_freqtrade=$(sed ':a;N;$!ba;s/\n//g' <<< $version_freqtrade)
    $CUSTOM_CMD_CLOSE_VE
  }
  EXE_FREQTRADE_PULL(){
    $CUSTOM_CMD_ACTIVATE_VE
    $CUSTOM_CMD_STOP  
    $CUSTOM_CMD_PULL
    $CUSTOM_CMD_BUILD 
    $CUSTOM_CMD_START
    $CUSTOM_CMD_CLOSE_VE
  }
EXE_FREQTRADE_RESTART(){
    $CUSTOM_CMD_ACTIVATE_VE
    $CUSTOM_CMD_STOP  
    $CUSTOM_CMD_BUILD 
    $CUSTOM_CMD_START 
    $CUSTOM_CMD_CLOSE_VE
  }
else
  
cd $FREQTRADE_HOME_PATH 
EXE_FREQTRADE_VERSION(){
      
    version_freqtrade=$(docker-compose run --rm freqtrade --version)
    version_freqtrade=$(sed "s/freqtrade//g" <<< $version_freqtrade)
    version_freqtrade=$(sed ':a;N;$!ba;s/\r//g' <<< $version_freqtrade)
    version_freqtrade=$(sed ':a;N;$!ba;s/\n//g' <<< $version_freqtrade)
  }
EXE_FREQTRADE_PULL(){
    docker-compose stop  
    docker-compose pull
    docker-compose build 
    docker-compose up -d
  }
EXE_FREQTRADE_RESTART(){
    docker-compose stop  
    docker-compose build 
    docker-compose up -d 
  }
		    
fi
EXE_FREQTRADE_VERSION

if [ "$ALLOW_UPDATE_AUTOUPDATER" == "Y" ] ; then
if [ ${GRRHAG_AUTOUPDATER_VERSION} != ${latest_version_autoupdater} ]; then

echo "$SEND_TIMESTAMP Create New Folder for Download Latest AutoUpdater $latest_version_autoupdater"

  mkdir -p ${LATEST_AUTOUPDATER_PATH}
  curl -s -L $git_tarball_autoupdater_url | tar xz -C ${LATEST_AUTOUPDATER_PATH} --strip-components 1
 
  SEND_A_V='%0A'"<b>AutoUpdater v$latest_version_autoupdater</b>"
  
  echo "$SEND_TIMESTAMP Download Latest AutoUpdater $latest_version_autoupdater"
    cp ${LATEST_AUTOUPDATER_PATH}/GRrHaG_AutoUpdater.sh ${AUTOUPDATER_PATH}/GRrHaG_AutoUpdater.sh
    SEND_A_U="<b>   AutoUpdater : </b><pre>Updated</pre>"
    echo "$SEND_TIMESTAMP AutoUpdater : Updated"
    
    Log_ID=$(($Log_ID + 1))    
    echo "$SEND_TIMESTAMP ; ID=$Log_ID ; AutoUpdater_Update=$latest_version_autoupdater" >> ${AUTOUPDATER_PATH}/history_autoupdater.txt
    
    SEND_TO_TELEGRAM_AUTOUPDATER=$SEND_START'%0A'$SEND_A_V'%0A'$SEND_A_U
    
      # Send message to telegram
  curl \
      -s \
      -X POST \
      --data "chat_id=$telegram_chat_id" \
      --data "text=$SEND_TO_TELEGRAM_AUTOUPDATER" \
      --data "parse_mode=HTML" \
      https://api.telegram.org/bot${telegram_token}/sendMessage
fi
fi


#####
  mkdir -p ${AUTOUPDATER_PATH}/temp
  mkdir -p ${AUTOUPDATER_PATH}/temp/blacklist
#####


if [ -n "$strategy_version" ] ; then	 #-n : retourne vrai si la taille de la chaîne n’est pas zéro

# If folder don't exist , create it , update NostalgiaForInfinityX.py, blacklist, pairlist and send Telegram message 


if [ ${strategy_version_log} != ${strategy_version} ]; then

echo "$SEND_TIMESTAMP Create New Folder for Download Latest Strategy $strategy_version"

  mkdir -p ${LATEST_STRATEGY_PATH}
  curl -s -L $git_tarball_url | tar xz -C ${LATEST_STRATEGY_PATH} --strip-components 1
 
  SEND_T_V='%0A'"<b>NostalgiaForInfinity $strategy_version</b>"
  
  if [ "$ALLOW_UPDATE_STRATEGY" == "Y" ] ; then
  echo "$SEND_TIMESTAMP Download Latest Strategy $strategy_version"
    cp ${LATEST_STRATEGY_PATH}/${BOT_STRATEGY_NAME} ${FREQTRADE_STRATEGY_PATH}/${BOT_STRATEGY_NAME}
    SEND_T_S_Y="<b>   Strategy : </b><pre>Updated</pre>"
    echo "$SEND_TIMESTAMP Strategy : Updated"
    
    Log_ID=$(($Log_ID + 1))    
    echo "$SEND_TIMESTAMP ; ID=$Log_ID ; Strategy_Update=$strategy_version" >> ${AUTOUPDATER_PATH}/history_autoupdater.txt
    
  else
    SEND_T_S_N="<b>   Strategy : </b><pre>Update Disabled</pre>"
    echo "$SEND_TIMESTAMP Strategy : Update Disabled"
  fi
  
  SEND_T_S=$SEND_T_S_Y$SEND_T_S_N
  
  if [ "$ALLOW_UPDATE_PAIRLIST" == "Y" ] ; then
    cp ${LATEST_STRATEGY_PATH}/configs/${BOT_PAIRLIST_NAME} ${FREQTRADE_PAIRLIST_PATH}/${BOT_PAIRLIST_NAME}
    SEND_T_P_Y="<b>   Pairlist : </b><pre>Updated</pre>"
    echo "$SEND_TIMESTAMP Pairlist : Updated"

  else
    SEND_T_P_N="<b>   Pairlist : </b><pre>Update Disabled</pre>"
    echo "$SEND_TIMESTAMP Pairlist : Update Disabled"
  fi
  
  SEND_T_P=$SEND_T_P_Y$SEND_T_P_N
  
  if [ "$ALLOW_UPDATE_BLACKLIST" == "Y" ] ; then

      if [ "$ALLOW_BLACKLIST_DETAIL" == "Y" ] ; then
      
      echo "$SEND_TIMESTAMP Blacklist Detail: Allow"
      cp ${LATEST_STRATEGY_PATH}/configs/${BOT_BLACKLIST_NAME} ${AUTOUPDATER_PATH}/temp/blacklist/latest_${BOT_BLACKLIST_NAME}
      cp ${FREQTRADE_BLACKLIST_PATH}/${BOT_BLACKLIST_NAME} ${AUTOUPDATER_PATH}/temp/blacklist/actual_${BOT_BLACKLIST_NAME}
      cd ${AUTOUPDATER_PATH}/temp/blacklist
      
          for file in  *.json
          do
            sed -i -e "s/,//g" "$file"
            sed -i -e "s/\.//g" "$file"
            sed -i -e "s/(//g" "$file"
            sed -i -e "s/)//g" "$file"
            sed -i -e "s/*//g" "$file"
            sed -i -e "s/{//g" "$file"
            sed -i -e "s/}//g" "$file"
            sed -i -e "s/://g" "$file"
            sed -i -e "s/\[//g" "$file"
            sed -i -e "s/\]//g" "$file"
            sed -i -e "s/\///g" "$file"
            sed -i -e "s/\"//g" "$file"
            sed -i -e "s/exchange//g" "$file"
            sed -i -e "s/pair_blacklist//g" "$file"
            sed -i -e "s/\ //g" "$file"
            sed -i -e "s+|+\n+g" "$file"
            sed -i -e "s/#.*$//" -i -e "/^$/d" "$file"
          done
  
#actual_blacklist=$(cat ${AUTOUPDATER_PATH}/temp/blacklist/actual_${BOT_BLACKLIST_NAME} | sed "s/,//g" | sed "s/\.//g" | sed "s/(//g" | sed "s/)//g" | sed "s/*//g" | sed "s/{//g" | sed "s/}//g" | sed "s/://g" | sed "s/\[//g" | sed "s/\]//g" | sed "s/\///g" | sed "s/\"//g" | sed "s/exchange//g" | sed "s/pair_blacklist//g" | sed "s/\ //g" | sed "s+|+\n+g" | sed "s/#.*$//" | sed "/^$/d")  
 
 echo "$actual_blacklist"
      sed -i -e "s/ExchangeTokens/ExchangeTokens_actual/g" actual_${BOT_BLACKLIST_NAME}
      sed -i -e "s/Leveragetokens/LeverageTokens_actual/g" actual_${BOT_BLACKLIST_NAME}
      sed -i -e "s/Stabletokens/StableTokens_actual/g" actual_${BOT_BLACKLIST_NAME}
      sed -i -e "s/FANTokens/FANTokens_actual/g" actual_${BOT_BLACKLIST_NAME}
      sed -i -e "s/OtherCoins/OtherCoins_actual/g" actual_${BOT_BLACKLIST_NAME}
    
      sed -i -e "s/ExchangeTokens/ExchangeTokens_latest/g" latest_${BOT_BLACKLIST_NAME}
      sed -i -e "s/Leveragetokens/LeverageTokens_latest/g" latest_${BOT_BLACKLIST_NAME}
      sed -i -e "s/Stabletokens/StableTokens_latest/g" latest_${BOT_BLACKLIST_NAME}
      sed -i -e "s/FANTokens/FANTokens_latest/g" latest_${BOT_BLACKLIST_NAME}
      sed -i -e "s/OtherCoins/OtherCoins_latest/g" latest_${BOT_BLACKLIST_NAME}
  
      awk 'NR==FNR {t[$0]++; next} !t[$0]' latest_${BOT_BLACKLIST_NAME} actual_${BOT_BLACKLIST_NAME} >Del_blacklist-kucoin
      sed -i -e ':a;N;$!ba;s/\n/-/g' Del_blacklist-kucoin
  
      grep -o -P '(?<=ExchangeTokens_actual).*(?=-LeverageTokens_actual)' Del_blacklist-kucoin > a_ET.txt
      grep -o -P '(?<=-LeverageTokens_actual).*(?=-StableTokens_actual)' Del_blacklist-kucoin > a_LT.txt
      grep -o -P '(?<=-StableTokens_actual).*(?=-FANTokens_actual)' Del_blacklist-kucoin > a_ST.txt
      grep -o -P '(?<=-FANTokens_actual).*(?=-OtherCoins_actual)' Del_blacklist-kucoin > a_FT.txt
      grep -oP '(?<=-OtherCoins_actual).*' Del_blacklist-kucoin > a_OC.txt
  
      awk 'NR==FNR {t[$0]++; next} !t[$0]' actual_${BOT_BLACKLIST_NAME} latest_${BOT_BLACKLIST_NAME} >Add_blacklist-kucoin
      sed -i -e ':a;N;$!ba;s/\n/+/g' Add_blacklist-kucoin
  
      grep -o -P '(?<=ExchangeTokens_latest).*(?=\+LeverageTokens_latest)' Add_blacklist-kucoin > l_ET.txt
      grep -o -P '(?<=\+LeverageTokens_latest).*(?=\+StableTokens_latest)' Add_blacklist-kucoin > l_LT.txt
      grep -o -P '(?<=\+StableTokens_latest).*(?=\+FANTokens_latest)' Add_blacklist-kucoin > l_ST.txt
      grep -o -P '(?<=\+FANTokens_latest).*(?=\+OtherCoins_latest)' Add_blacklist-kucoin > l_FT.txt
      grep -oP '(?<=\+OtherCoins_latest).*' Add_blacklist-kucoin > l_OC.txt
  
          for file in  *.txt
          do
            sed -i -e 's/$/<\/pre>/' "$file"
            sed -i -e 's/^/<pre>/' "$file"
            sed -i -e ':a;N;$!ba;s/\n//g' "$file"
          done
  
      SEND_a_ET=$(cat a_ET.txt)
      SEND_l_ET=$(cat l_ET.txt)
      SEND_a_LT=$(cat a_LT.txt)
      SEND_l_LT=$(cat l_LT.txt)
      SEND_a_ST=$(cat a_ST.txt)
      SEND_l_ST=$(cat l_ST.txt)
      SEND_a_FT=$(cat a_FT.txt)
      SEND_l_FT=$(cat l_FT.txt)
      SEND_a_OC=$(cat a_OC.txt)
      SEND_l_OC=$(cat l_OC.txt)
    
          #si vide
          if [ -z $SEND_a_ET ] && [ -z $SEND_l_ET ]; then
            SEND_ET=""
          else
            SEND_ET='%0A'$ExchangeTokens'%0A'"   "$SEND_a_ET" "$SEND_l_ET
          fi
  
          if [ -z $SEND_a_LT ] && [ -z $SEND_l_LT ]; then
            SEND_LT=""
          else
            SEND_LT='%0A'$LeverageTokens'%0A'"   "$SEND_a_LT" "$SEND_l_LT
          fi
  
          if [ -z $SEND_a_ST ] && [ -z $SEND_l_ST ]; then
            SEND_ST=""
          else
            SEND_ST='%0A'StableTokens'%0A'"   "$SEND_a_ST" "$SEND_l_ST
          fi
  
          if [ -z $SEND_a_FT ] && [ -z $SEND_l_FT ]; then
            SEND_FT=""
          else
            SEND_FT='%0A'$FANTokens'%0A'"   "$SEND_a_FT" "$SEND_l_FT
          fi
  
          if [ -z $SEND_a_OC ] && [ -z $SEND_l_OC ]; then
            SEND_OC=""
          else
            SEND_OC='%0A'$OtherCoins'%0A'"   "$SEND_a_OC" "$SEND_l_OC 
          fi
  
          if [ -z $SEND_a_ET ] && [ -z $SEND_l_ET ] && [ -z $SEND_a_LT ] && [ -z $SEND_l_LT ] && [ -z $SEND_a_ST ] && [ -z $SEND_l_ST ] && [ -z $SEND_a_FT ] && [ -z $SEND_l_FT ] && [ -z $SEND_a_OC ] && [ -z $SEND_l_OC ]; then
            SEND_T_B_Y_D=$BlacklistDetail" No change"
          else
            SEND_T_B_Y_D=$BlacklistDetail$SEND_ET$SEND_LT$SEND_ST$SEND_FT$SEND_OC
          fi
  
      rm -rf Add_*
      rm -rf Diff*
      rm -rf Del_*
      rm -rf a_*
      rm -rf l_*
      rm -rf actual_*
      rm -rf latest_*
      rm -f se*
      fi
  
  cp ${LATEST_STRATEGY_PATH}/configs/${BOT_BLACKLIST_NAME} ${FREQTRADE_BLACKLIST_PATH}/${BOT_BLACKLIST_NAME}
  SEND_T_B_Y="<b>   Blacklist : </b><pre>Updated</pre>"
  echo "$SEND_TIMESTAMP Blacklist : Updated"
  
  else
    SEND_T_B_N="<b>   Blacklist : </b><pre>Update Disabled</pre>."
    echo "$SEND_TIMESTAMP Blacklist : Update Disabled"
  fi

  SEND_T_B=$SEND_T_B_Y$SEND_T_B_N
  SEND_TO_TELEGRAM=$SEND_START'%0A'$SEND_T_V'%0A'$SEND_T_S'%0A'$SEND_T_P'%0A'$SEND_T_B
  SEND_TO_TELEGRAM_2='%0A'$SEND_T_B_Y_D
  
  # Send message to telegram
  curl \
      -s \
      -X POST \
      --data "chat_id=$telegram_chat_id" \
      --data "text=$SEND_TO_TELEGRAM" \
      --data "parse_mode=HTML" \
      https://api.telegram.org/bot${telegram_token}/sendMessage
  
  # Send message to telegram
  curl \
      -s \
      -X POST \
      --data "chat_id=$telegram_chat_id" \
      --data "text=$SEND_TO_TELEGRAM_2" \
      --data "parse_mode=HTML" \
      https://api.telegram.org/bot${telegram_token}/sendMessage
  
  if [ "$ALLOW_REBOOT" == "Y" ] ; then
    # Send message to telegram
    curl \
        -s \
        -X POST \
        --data "chat_id=$telegram_chat_id" \
        --data "text=$SEND_RELOAD" \
        --data "parse_mode=HTML" \
        https://api.telegram.org/bot${telegram_token}/sendMessage
    
    echo "$SEND_TIMESTAMP FREQTARDE : STOP"  

    EXE_FREQTRADE_RESTART

    echo "$SEND_TIMESTAMP FREQTARDE : START"  

    # Send message to telegram
    curl \
        -s \
        -X POST \
        --data "chat_id=$telegram_chat_id" \
        --data "text=$SEND_RELOADED" \
        --data "parse_mode=HTML" \
        https://api.telegram.org/bot${telegram_token}/sendMessage
  fi

    echo "$SEND_TIMESTAMP FREQTARDE : Reload has been completed!" 
else

echo "$SEND_TIMESTAMP Latest Strategy $strategy_version already install"

  if [ "$TIMESTAMP_H" == "23" ]; then

    if [ "$TIMESTAMP_M" == "54" -o "$TIMESTAMP_M" == "55" -o "$TIMESTAMP_M" == "56" -o "$TIMESTAMP_M" == "57" -o "$TIMESTAMP_M" == "58" -o "$TIMESTAMP_M" == "59" ]; then
    echo "$SEND_TIMESTAMP Send daily message"
      if [ "$nb_update_today_log" != "0" ]; then
            
        SEND_nb=$nb_update_today_log        
      
        # Send message to telegram
        curl \
            -s \
            -X POST \
            --data "chat_id=$telegram_chat_id" \
            --data "text=<b>$TIMESTAMP_YMD  $TIMESTAMP_HM :</b><pre> $SEND_nb Update Today</pre>" \
            --data "parse_mode=HTML" \
            https://api.telegram.org/bot${telegram_token}/sendMessage
        echo "$SEND_TIMESTAMP Daily Message : $SEND_nb Update Today"
      else  
    
        # If folder exist send Telegram message
        curl \
          -s \
          -X POST \
          --data "chat_id=$telegram_chat_id" \
          --data "text=<b>$TIMESTAMP_YMD  $TIMESTAMP_HM :</b><pre>  No Update Today</pre>" \
          --data "parse_mode=HTML" \
          https://api.telegram.org/bot${telegram_token}/sendMessage 
          echo "$SEND_TIMESTAMP Daily Message : No Update Today"     
      fi
      if [ "$nb_error_log" != "0" ]; then
            
        SEND_nb=$nb_error_log        
      
        # Send message to telegram
        curl \
            -s \
            -X POST \
            --data "chat_id=$telegram_chat_id" \
            --data "text=<b>$TIMESTAMP_YMD  $TIMESTAMP_HM :</b><pre> $SEND_nb Error Today</pre>" \
            --data "parse_mode=HTML" \
            https://api.telegram.org/bot${telegram_token}/sendMessage
        echo "$SEND_TIMESTAMP Daily Message : $SEND_nb Error Today"
      else  
    
        # If folder exist send Telegram message
        curl \
          -s \
          -X POST \
          --data "chat_id=$telegram_chat_id" \
          --data "text=<b>$TIMESTAMP_YMD  $TIMESTAMP_HM :</b><pre>  No Error Today</pre>" \
          --data "parse_mode=HTML" \
          https://api.telegram.org/bot${telegram_token}/sendMessage 
          echo "$SEND_TIMESTAMP Daily Message : No Error Today"     
      fi
    fi

  fi
fi

else
echo "$SEND_TIMESTAMP ERROR : Strategy Latest Version is empty"  

    Log_error_ID=$(($Log_error_ID + 1))
    echo "$SEND_TIMESTAMP ; ID=$Log_error_ID ; ERROR=Strategy Latest Version is empty" >> ${AUTOUPDATER_PATH}/history_autoupdater_error.txt
fi

if [ "$ALLOW_UPDATE_FREQTRADE" == "Y" ] ; then
echo "$SEND_TIMESTAMP Update FREQTRADE : allow"

	
	if [ ! -z "$latest_version_freqtrade" ] ; then	 #pas vide
	SEND_TO_TELEGRAM_3=$SEND_START'%0A'$SEND_N_U_FT'%0A'$SEND_INSTALL_RELOAD
	
       
    
  
		if [ -z "$version_freqtrade_log" ]; then		 #vide
    
    EXE_FREQTRADE_VERSION
    
		echo "$SEND_TIMESTAMP Update FREQTRADE : Actual Version $version_freqtrade"
		

    
			if [ ! -z "$version_freqtrade" ] ; then			
    Log_ID=$(($Log_ID + 1))    
    echo "$SEND_TIMESTAMP ; ID=$Log_ID ; Freqtrade_Update=$version_freqtrade" >> ${AUTOUPDATER_PATH}/history_autoupdater.txt
			
			fi
			
		else
		
		echo "$SEND_TIMESTAMP Update FREQTRADE : Actual Version in log file $version_freqtrade_log"
		

		
			if [ ${version_freqtrade_log} != ${latest_version_freqtrade} ] ; then			
			echo "$SEND_TIMESTAMP Update FREQTRADE : START Update"
			# Send message to telegram
			curl \
				-s \
				-X POST \
				--data "chat_id=$telegram_chat_id" \
				--data "text=$SEND_TO_TELEGRAM_3" \
				--data "parse_mode=HTML" \
				https://api.telegram.org/bot${telegram_token}/sendMessage
			
      EXE_FREQTRADE_PULL	  
			
				# Send message to telegram
			curl \
				-s \
				-X POST \
				--data "chat_id=$telegram_chat_id" \
				--data "text=$SEND_RELOADED" \
				--data "parse_mode=HTML" \
				https://api.telegram.org/bot${telegram_token}/sendMessage
        
      EXE_FREQTRADE_VERSION
      
      if [ ${version_freqtrade} = ${latest_version_freqtrade} ] ; then				
          Log_ID=$(($Log_ID + 1))    
    echo "$SEND_TIMESTAMP ; ID=$Log_ID ; Freqtrade_Update=$version_freqtrade" >> ${AUTOUPDATER_PATH}/history_autoupdater.txt
    else
          Log_ID=$(($Log_ID + 1))
    echo "$SEND_TIMESTAMP ; ID=$Log_ID ; ERROR=Fail to Update Freqtrade v$version_freqtrade to v$latest_version_freqtrade" >> ${AUTOUPDATER_PATH}/history_autoupdater.txt
    fi
      
			cd $AUTOUPDATER_PATH
			version_freqtrade_log=$(cat ${AUTOUPDATER_PATH}/history_autoupdater.txt | grep -o 'Freqtrade_Update=.*' | sed "s/Freqtrade_Update=//g"| sed 's/ //' | sed ':a;$q;N;1,$D;ba')
			
				if [ ${version_freqtrade_log} != ${latest_version_freqtrade} ] ; then				
				# Send message to telegram			
				curl \
					-s \
					-X POST \
					--data "chat_id=$telegram_chat_id" \
					--data "text=Status : FAIL to Update v$latest_version_freqtrade" \
					--data "parse_mode=HTML" \
					https://api.telegram.org/bot${telegram_token}/sendMessage
				echo "$SEND_TIMESTAMP FREQTARDE : FAIL to Update"  
				         
					else					
						curl \
					-s \
					-X POST \
					--data "chat_id=$telegram_chat_id" \
					--data "text=Status : Update in $version_freqtrade_log" \
					--data "parse_mode=HTML" \
					https://api.telegram.org/bot${telegram_token}/sendMessage
				 echo "$SEND_TIMESTAMP FREQTARDE : Update Success"
				        
				fi
			fi
		fi
	fi	
else
        
          Log_error_ID=$(($Log_error_ID + 1))
    echo "$SEND_TIMESTAMP ; ID=$Log_error_ID ; ERROR=Freqtrade Latest Version is empty" >> ${AUTOUPDATER_PATH}/history_autoupdater_error.txt
fi

echo "$SEND_TIMESTAMP AUTOUPDATER : No Update"  
 
exit
