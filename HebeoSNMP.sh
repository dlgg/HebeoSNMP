#!/bin/bash
# TODO
#

PEN="44687"
FBXSTATS="/usr/local/bin/fbx_stats"
#DEBUG=1


[ ${DEBUG} ] && echo $(date) | tee -a /tmp/snmp.log
[ ${DEBUG} ] && echo START $0 $1 $2 $3 | tee -a /tmp/snmp.log

###
### the first line should be the OID of the returned value, the second should be its
### TYPE (one of the text strings : integer, gauge, counter, timeticks, ipaddress,
### objectid, or string ), and the third should be the value itself
###

  ###################
 ####################
#####################
###               ###
##  Locals checks ###
#                 ##
###################

check_memcache() {
  [ ${DEBUG} ] && echo check_memcache $1 $2 $3 | tee -a /tmp/snmp.log
  pgrep memcache >/dev/null 2>&1; [ $? -ne 0 ] && exit 1
  echo $1
  echo STRING
  expect -c 'spawn telnet 127.0.0.1 11211; send -- "stats\r\n"; expect END; exit'|egrep ' (bytes|limit_maxbytes|get_hits|get_misses|curr_items|curr_connections|total_connections|bytes_read|bytes_written|cmd_get|cmd_set) '|sed -e 's/^STAT\ //' -e 's/\ /=/' -e 's/\x0D$//' |xargs echo
}

check_netstat() {
  [ ${DEBUG} ] && echo check_netstat $1 | tee -a /tmp/snmp.log
  [ $(echo $(uname -r)|grep -c grsec) -eq 0 ] && CMDRET=$(netstat -utan |tail -n +3|awk '{print $6}'|sort|uniq -c|awk '{printf("%s=%s ",$2,$1)}') || CMDRET=$(sudo netstat -utan |tail -n +3|awk '{print $6}'|sort|uniq -c|awk '{printf("%s=%s ",$2,$1)}')
  echo $1
  echo STRING
  eval UDP_LISTEN${CMDRET}
  echo "ESTABLISHED=${ESTABLISHED:-0} SYN_SENT=${SYN_SENT:-0} SYN_RECV=${SYN_RECV:-0} FIN_WAIT1=${FIN_WAIT1:-0} FIN_WAIT2=${FIN_WAIT2:-0} TIME_WAIT=${TIME_WAIT:-0} CLOSE=${CLOSE:-0} CLOSE_WAIT=${CLOSE_WAIT:-0} LAST_ACK=${LAST_ACK:-0} LISTEN=${LISTEN:-0} CLOSING=${CLOSING:-0} UNKNOWN=${UNKNOWN:-0}"
}

check_netstat_established() {
  [ ${DEBUG} ] && echo check_netstat $1 >>/tmp/snmp.log
  [ $(echo $(uname -r)|grep -c grsec) -eq 0 ] && CMDRET=$(netstat -utan |tail -n +3|awk '{print $6}'|sort|uniq -c|awk '{printf("%s=%s ",$2,$1)}') || CMDRET=$(sudo netstat -utan |tail -n +3|awk '{print $6}'|sort|uniq -c|awk '{printf("%s=%s ",$2,$1)}')
  echo $1
  echo INTEGER
  eval UDP_LISTEN${CMDRET}
  echo "${ESTABLISHED:-0}"
}
check_netstat_syn_sent() {
  [ ${DEBUG} ] && echo check_netstat $1 >>/tmp/snmp.log
  [ $(echo $(uname -r)|grep -c grsec) -eq 0 ] && CMDRET=$(netstat -utan |tail -n +3|awk '{print $6}'|sort|uniq -c|awk '{printf("%s=%s ",$2,$1)}') || CMDRET=$(sudo netstat -utan |tail -n +3|awk '{print $6}'|sort|uniq -c|awk '{printf("%s=%s ",$2,$1)}')
  echo $1
  echo INTEGER
  eval UDP_LISTEN${CMDRET}
  echo "${SYN_SENT:-0}"
}
check_netstat_syn_recv() {
  [ ${DEBUG} ] && echo check_netstat $1 >>/tmp/snmp.log
  [ $(echo $(uname -r)|grep -c grsec) -eq 0 ] && CMDRET=$(netstat -utan |tail -n +3|awk '{print $6}'|sort|uniq -c|awk '{printf("%s=%s ",$2,$1)}') || CMDRET=$(sudo netstat -utan |tail -n +3|awk '{print $6}'|sort|uniq -c|awk '{printf("%s=%s ",$2,$1)}')
  echo $1
  echo INTEGER
  eval UDP_LISTEN${CMDRET}
  echo "${SYN_RECV:-0}"
}
check_netstat_fin_wait1() {
  [ ${DEBUG} ] && echo check_netstat $1 >>/tmp/snmp.log
  [ $(echo $(uname -r)|grep -c grsec) -eq 0 ] && CMDRET=$(netstat -utan |tail -n +3|awk '{print $6}'|sort|uniq -c|awk '{printf("%s=%s ",$2,$1)}') || CMDRET=$(sudo netstat -utan |tail -n +3|awk '{print $6}'|sort|uniq -c|awk '{printf("%s=%s ",$2,$1)}')
  echo $1
  echo INTEGER
  eval UDP_LISTEN${CMDRET}
  echo "${FIN_WAIT1:-0}"
}
check_netstat_fin_wait2() {
  [ ${DEBUG} ] && echo check_netstat $1 >>/tmp/snmp.log
  [ $(echo $(uname -r)|grep -c grsec) -eq 0 ] && CMDRET=$(netstat -utan |tail -n +3|awk '{print $6}'|sort|uniq -c|awk '{printf("%s=%s ",$2,$1)}') || CMDRET=$(sudo netstat -utan |tail -n +3|awk '{print $6}'|sort|uniq -c|awk '{printf("%s=%s ",$2,$1)}')
  echo $1
  echo INTEGER
  eval UDP_LISTEN${CMDRET}
  echo "${FIN_WAIT2:-0}"
}
check_netstat_time_wait() {
  [ ${DEBUG} ] && echo check_netstat $1 >>/tmp/snmp.log
  [ $(echo $(uname -r)|grep -c grsec) -eq 0 ] && CMDRET=$(netstat -utan |tail -n +3|awk '{print $6}'|sort|uniq -c|awk '{printf("%s=%s ",$2,$1)}') || CMDRET=$(sudo netstat -utan |tail -n +3|awk '{print $6}'|sort|uniq -c|awk '{printf("%s=%s ",$2,$1)}')
  echo $1
  echo INTEGER
  eval UDP_LISTEN${CMDRET}
  echo "${TIME_WAIT:-0}"
}
check_netstat_close() {
  [ ${DEBUG} ] && echo check_netstat $1 >>/tmp/snmp.log
  [ $(echo $(uname -r)|grep -c grsec) -eq 0 ] && CMDRET=$(netstat -utan |tail -n +3|awk '{print $6}'|sort|uniq -c|awk '{printf("%s=%s ",$2,$1)}') || CMDRET=$(sudo netstat -utan |tail -n +3|awk '{print $6}'|sort|uniq -c|awk '{printf("%s=%s ",$2,$1)}')
  echo $1
  echo INTEGER
  eval UDP_LISTEN${CMDRET}
  echo "${CLOSE:-0}"
}
check_netstat_close_wait() {
  [ ${DEBUG} ] && echo check_netstat $1 >>/tmp/snmp.log
  [ $(echo $(uname -r)|grep -c grsec) -eq 0 ] && CMDRET=$(netstat -utan |tail -n +3|awk '{print $6}'|sort|uniq -c|awk '{printf("%s=%s ",$2,$1)}') || CMDRET=$(sudo netstat -utan |tail -n +3|awk '{print $6}'|sort|uniq -c|awk '{printf("%s=%s ",$2,$1)}')
  echo $1
  echo INTEGER
  eval UDP_LISTEN${CMDRET}
  echo "${CLOSE_WAIT:-0}"
}
check_netstat_last_ack() {
  [ ${DEBUG} ] && echo check_netstat $1 >>/tmp/snmp.log
  [ $(echo $(uname -r)|grep -c grsec) -eq 0 ] && CMDRET=$(netstat -utan |tail -n +3|awk '{print $6}'|sort|uniq -c|awk '{printf("%s=%s ",$2,$1)}') || CMDRET=$(sudo netstat -utan |tail -n +3|awk '{print $6}'|sort|uniq -c|awk '{printf("%s=%s ",$2,$1)}')
  echo $1
  echo INTEGER
  eval UDP_LISTEN${CMDRET}
  echo "${LAST_ACK:-0}"
}
check_netstat_listen() {
  [ ${DEBUG} ] && echo check_netstat $1 >>/tmp/snmp.log
  [ $(echo $(uname -r)|grep -c grsec) -eq 0 ] && CMDRET=$(netstat -utan |tail -n +3|awk '{print $6}'|sort|uniq -c|awk '{printf("%s=%s ",$2,$1)}') || CMDRET=$(sudo netstat -utan |tail -n +3|awk '{print $6}'|sort|uniq -c|awk '{printf("%s=%s ",$2,$1)}')
  echo $1
  echo INTEGER
  eval UDP_LISTEN${CMDRET}
  echo "${LISTEN:-0}"
}
check_netstat_closing() {
  [ ${DEBUG} ] && echo check_netstat $1 >>/tmp/snmp.log
  [ $(echo $(uname -r)|grep -c grsec) -eq 0 ] && CMDRET=$(netstat -utan |tail -n +3|awk '{print $6}'|sort|uniq -c|awk '{printf("%s=%s ",$2,$1)}') || CMDRET=$(sudo netstat -utan |tail -n +3|awk '{print $6}'|sort|uniq -c|awk '{printf("%s=%s ",$2,$1)}')
  echo $1
  echo INTEGER
  eval UDP_LISTEN${CMDRET}
  echo "${CLOSING:-0}"
}
check_netstat_unknown() {
  [ ${DEBUG} ] && echo check_netstat $1 >>/tmp/snmp.log
  [ $(echo $(uname -r)|grep -c grsec) -eq 0 ] && CMDRET=$(netstat -utan |tail -n +3|awk '{print $6}'|sort|uniq -c|awk '{printf("%s=%s ",$2,$1)}') || CMDRET=$(sudo netstat -utan |tail -n +3|awk '{print $6}'|sort|uniq -c|awk '{printf("%s=%s ",$2,$1)}')
  echo $1
  echo INTEGER
  eval UDP_LISTEN${CMDRET}
  echo "${UNKNOWN:-0}"
}

check_inode_nr() {
  echo $1
  echo STRING
  while read nr free; do echo "INODE-NR=${nr} INODE-NR-FREE=${free}"; done </proc/sys/fs/inode-nr
}

check_inode_df() {
  echo $1
  echo STRING
  df -i|egrep -v ' (Inodes|/dev|/var/|/lib/)' |while read part inodes used free percent mount ; do
    echo ${mount}-inode-total=${inodes:-0} ${mount}-inode-free=${free:-0} ${mount}-inode-used=${used:-0} ${mount}-inode-percent=${percent%%%}
  done
}

check_threads() {
  echo $1
  echo STRING
  grep -s '^Threads' /proc/[0-9]*/status | awk '{ sum += $2; } END { printf "threads=%i\n",sum; }'
}

check_entropy() {
  [ ! -e /proc/sys/kernel/random/entropy_avail ] && exit 0
  echo $1
  echo STRING
  echo entropy=$(cat /proc/sys/kernel/random/entropy_avail)
}

check_interrupts() {
  echo $1
  echo STRING
  awk '$1 == "intr" { printf(" intr.value=%s",$2) }
       $1 == "ctxt" { printf(" ctx.value=%s",$2) }' /proc/stat
  echo
}

check_irqstats() {
  echo $1
  echo STRING
  echo Not implemented
}

check_iostats() {
  echo $1
  echo STRING
                                                 # rd_ios rd_merges rd_sectors rd_ticks wr_ios wr_merges wr_sectors wr_ticks ios_in_prog tot_ticks rq_ticks
  cat /proc/diskstats |while read major minor disk rio    rmerge    rsect      ruse     wio    wmerge    wsect      wuse     running     use       aveq; do
    if [ ${major} -eq 8 -o ${major} -eq 9 -o ${major} -eq 252 ]; then
      echo ${disk}-readio=${rio} ${disk}-writeio=${wio} ${disk}-readblock=${rsect} ${disk}-writeblock=${wsect} ${disk}-readlatency=${ruse} ${disk}-writelatency=${wuse} ${disk}-readmerge=${rmerge} ${disk}-writemerge=${wmerge} ${disk}-runningio=${running} ${disk}-iotime=${use} ${disk}-ioweight=${aveq}
    fi
  done|xargs echo
}

check_forks() {
  echo $1
  echo STRING
  echo "fork_rate=$(awk '/processes/ {print $2}' /proc/stat)"
}

check_procprio() {
  echo $1
  echo STRING
  echo "high=$(ps --no-header -eo stat | grep -c \<) low=$(ps --no-header -eo stat | grep -c N) locked=$(ps --no-header -eo stat | grep -c L)"
}
check_filetable() {
  echo $1
  echo STRING
  awk '{printf("handles=%s free_handles=%s max=%s\n",$1,$2,$3)}' < /proc/sys/fs/file-nr
}

check_apache() {
  pgrep apache2 >/dev/null 2>&1; [ $? -ne 0 ] && exit 2
  afile="/tmp/apachestatus"
  wget -O ${afile} -q 'http://localhost/server-status/?auto'
  echo $1
  echo STRING
  egrep '^(CPULoad|Uptime|ReqPerSec|BytesPerSec|BusyWorkers|IdleWorkers)' ${afile} |xargs echo
#CPULoad: .00229375
#Uptime: 323923
#ReqPerSec: .000666825
#BytesPerSec: 10.5522
#BytesPerReq: 15824.6
#BusyWorkers: 27
#IdleWorkers: 9
#Scoreboard: K__KKCKKKK_KW_K_KK___KKKKK_KK.KK.K..
  rm ${afile}
}

check_apache_requests() {
  pgrep apache2 >/dev/null 2>&1; [ $? -ne 0 ] && exit 2
  afile="/tmp/apachestatus"
  wget -O ${afile} -q 'http://localhost/server-status/?auto'
  echo $1
  echo STRING
  RET=$(grep '^Scoreboard' ${afile} |cut -d: -f 2|sed 's/\(.\)/\1\n/g'|grep -v ^$|grep -v '^\ $'|sort|uniq -c|awk '{printf("%s=%s\n",$2,$1)}'|sed -e 's/^_/apache2waiting/' -e 's/^S/apache2starting/' -e 's/^R/apache2reading/' -e 's/^W/apache2reply/' -e 's/^K/apache2keepalive/' -e 's/^D/apache2dnslookup/' -e  's/^C/apache2closing/' -e 's/^L/apache2logging/' -e 's/^G/apache2graceful/' -e 's/^I/apache2idle/' -e 's/^\./apache2open/'|xargs echo)
  rm ${afile}
  eval ${RET}
  echo "apache2waiting=${apache2waiting:-0} apache2starting=${apache2starting:-0} apache2reading=${apache2reading:-0} apache2reply=${apache2reply:-0} apache2keepalive=${apache2keepalive:-0} apache2dnslookup=${apache2dnslookup:-0} apache2closing=${apache2closing:-0} apache2logging=${apache2logging:-0} apache2graceful=${apache2graceful:-0} apache2idle=${apache2idle:-0} apache2open=${apache2open:-0}"
}
check_apache_requests_waiting() {
  pgrep apache2 >/dev/null 2>&1; [ $? -ne 0 ] && exit 2
  afile="/tmp/apachestatuswaiting"
  wget -O ${afile} -q 'http://localhost/server-status/?auto'
  echo $1
  echo INTEGER
  RET=$(grep '^Scoreboard' ${afile} |cut -d: -f 2|sed 's/\(.\)/\1\n/g'|grep -v ^$|grep -v '^\ $'|sort|uniq -c|awk '{printf("%s=%s\n",$2,$1)}'|sed -e 's/^_/apache2waiting/' |xargs echo)
  rm ${afile}
  eval ${RET}
  echo "${apache2waiting:-0}"
}
check_apache_requests_starting() {
  pgrep apache2 >/dev/null 2>&1; [ $? -ne 0 ] && exit 2
  afile="/tmp/apachestatusstarting"
  wget -O ${afile} -q 'http://localhost/server-status/?auto'
  echo $1
  echo INTEGER
  RET=$(grep '^Scoreboard' ${afile} |cut -d: -f 2|sed 's/\(.\)/\1\n/g'|grep -v ^$|grep -v '^\ $'|sort|uniq -c|awk '{printf("%s=%s\n",$2,$1)}'|sed -e 's/^S/apache2starting/' |xargs echo)
  rm ${afile}
  eval ${RET}
  echo "${apache2starting:-0}"
}
check_apache_requests_reading() {
  pgrep apache2 >/dev/null 2>&1; [ $? -ne 0 ] && exit 2
  afile="/tmp/apachestatusreading"
  wget -O ${afile} -q 'http://localhost/server-status/?auto'
  echo $1
  echo INTEGER
  RET=$(grep '^Scoreboard' ${afile} |cut -d: -f 2|sed 's/\(.\)/\1\n/g'|grep -v ^$|grep -v '^\ $'|sort|uniq -c|awk '{printf("%s=%s\n",$2,$1)}'|sed -e 's/^R/apache2reading/' |xargs echo)
  rm ${afile}
  eval ${RET}
  echo "${apache2reading:-0}"
}
check_apache_requests_reply() {
  pgrep apache2 >/dev/null 2>&1; [ $? -ne 0 ] && exit 2
  afile="/tmp/apachestatusreply"
  wget -O ${afile} -q 'http://localhost/server-status/?auto'
  echo $1
  echo INTEGER
  RET=$(grep '^Scoreboard' ${afile} |cut -d: -f 2|sed 's/\(.\)/\1\n/g'|grep -v ^$|grep -v '^\ $'|sort|uniq -c|awk '{printf("%s=%s\n",$2,$1)}'|sed -e 's/^R/apache2reply/' |xargs echo)
  rm ${afile}
  eval ${RET}
  echo "${apache2reply:-0}"
}
check_apache_requests_keepalive() {
  pgrep apache2 >/dev/null 2>&1; [ $? -ne 0 ] && exit 2
  afile="/tmp/apachestatuskeepalive"
  wget -O ${afile} -q 'http://localhost/server-status/?auto'
  echo $1
  echo INTEGER
  RET=$(grep '^Scoreboard' ${afile} |cut -d: -f 2|sed 's/\(.\)/\1\n/g'|grep -v ^$|grep -v '^\ $'|sort|uniq -c|awk '{printf("%s=%s\n",$2,$1)}'|sed -e 's/^K/apache2keepalive/' |xargs echo)
  rm ${afile}
  eval ${RET}
  echo "${apache2keepalive:-0}"
}
check_apache_requests_dnslookup() {
  pgrep apache2 >/dev/null 2>&1; [ $? -ne 0 ] && exit 2
  afile="/tmp/apachestatusdnslookup"
  wget -O ${afile} -q 'http://localhost/server-status/?auto'
  echo $1
  echo INTEGER
  RET=$(grep '^Scoreboard' ${afile} |cut -d: -f 2|sed 's/\(.\)/\1\n/g'|grep -v ^$|grep -v '^\ $'|sort|uniq -c|awk '{printf("%s=%s\n",$2,$1)}'|sed -e 's/^D/apache2dnslookup/' |xargs echo)
  rm ${afile}
  eval ${RET}
  echo "${apache2dnslookup:-0}"
}
check_apache_requests_closing() {
  pgrep apache2 >/dev/null 2>&1; [ $? -ne 0 ] && exit 2
  afile="/tmp/apachestatusclosing"
  wget -O ${afile} -q 'http://localhost/server-status/?auto'
  echo $1
  echo INTEGER
  RET=$(grep '^Scoreboard' ${afile} |cut -d: -f 2|sed 's/\(.\)/\1\n/g'|grep -v ^$|grep -v '^\ $'|sort|uniq -c|awk '{printf("%s=%s\n",$2,$1)}'|sed -e 's/^C/apache2closing/' |xargs echo)
  rm ${afile}
  eval ${RET}
  echo "${apache2closing:-0}"
}
check_apache_requests_logging() {
  pgrep apache2 >/dev/null 2>&1; [ $? -ne 0 ] && exit 2
  afile="/tmp/apachestatuslogging"
  wget -O ${afile} -q 'http://localhost/server-status/?auto'
  echo $1
  echo INTEGER
  RET=$(grep '^Scoreboard' ${afile} |cut -d: -f 2|sed 's/\(.\)/\1\n/g'|grep -v ^$|grep -v '^\ $'|sort|uniq -c|awk '{printf("%s=%s\n",$2,$1)}'|sed -e 's/^L/apache2logging/' |xargs echo)
  rm ${afile}
  eval ${RET}
  echo "${apache2logging:-0}"
}


  ####################
 #####################
######################
###                ###
##  Freebox checks ###
#                  ##
####################

check_freebox_system_uptime_value() {
  echo $1
  echo INTEGER
  ${FBXSTATS} system uptime_raw
}

  ###############
 ################
#################
###           ###
##  Main loop ###
#             ##
###############

snmpget() {
  [ ${DEBUG} ] && echo sget $0 $1 $2 $3 |tee -a /tmp/snmp.log
  case $1 in 
    .1.3.6.1.4.1.44687.1.1         ) check_memcache $1 ;;
    .1.3.6.1.4.1.44687.1.2         ) check_netstat $1 ;;
    .1.3.6.1.4.1.44687.1.2.1       ) check_netstat_established $1 ;;
    .1.3.6.1.4.1.44687.1.2.2       ) check_netstat_syn_sent $1 ;;
    .1.3.6.1.4.1.44687.1.2.3       ) check_netstat_syn_recv $1 ;;
    .1.3.6.1.4.1.44687.1.2.4       ) check_netstat_fin_wait1 $1 ;;
    .1.3.6.1.4.1.44687.1.2.5       ) check_netstat_fin_wait2 $1 ;;
    .1.3.6.1.4.1.44687.1.2.6       ) check_netstat_time_wait $1 ;;
    .1.3.6.1.4.1.44687.1.2.7       ) check_netstat_close $1 ;;
    .1.3.6.1.4.1.44687.1.2.8       ) check_netstat_close_wait $1 ;;
    .1.3.6.1.4.1.44687.1.2.9       ) check_netstat_last_ack $1 ;;
    .1.3.6.1.4.1.44687.1.2.10      ) check_netstat_listen $1 ;;
    .1.3.6.1.4.1.44687.1.2.11      ) check_netstat_closing $1 ;;
    .1.3.6.1.4.1.44687.1.2.12      ) check_netstat_unknown $1 ;;
    .1.3.6.1.4.1.44687.1.3         ) check_inode_nr $1 ;;
    .1.3.6.1.4.1.44687.1.4         ) check_inode_df $1 ;;
    .1.3.6.1.4.1.44687.1.5         ) check_threads $1 ;;
    .1.3.6.1.4.1.44687.1.6         ) check_entropy $1 ;;
    .1.3.6.1.4.1.44687.1.7         ) check_interrupts $1 ;;
    .1.3.6.1.4.1.44687.1.8         ) check_irqstats $1 ;;
    .1.3.6.1.4.1.44687.1.9         ) check_iostats $1 ;;
    .1.3.6.1.4.1.44687.1.10        ) check_forks $1 ;;
    .1.3.6.1.4.1.44687.1.11        ) check_procprio $1 ;;
    .1.3.6.1.4.1.44687.1.12        ) check_filetable $1 ;;
    .1.3.6.1.4.1.44687.1.13        ) check_apache $1 ;;
    .1.3.6.1.4.1.44687.1.14        ) check_apache_requests $1 ;;
    .1.3.6.1.4.1.44687.1.14.1      ) check_apache_requests_waiting $1 ;;
    .1.3.6.1.4.1.44687.1.14.2      ) check_apache_requests_starting $1 ;;
    .1.3.6.1.4.1.44687.1.14.3      ) check_apache_requests_reading $1 ;;
    .1.3.6.1.4.1.44687.1.14.4      ) check_apache_requests_reply $1 ;;
    .1.3.6.1.4.1.44687.1.14.5      ) check_apache_requests_keepalive $1 ;;
    .1.3.6.1.4.1.44687.1.14.6      ) check_apache_requests_dnslookup $1 ;;
    .1.3.6.1.4.1.44687.1.14.7      ) check_apache_requests_closing $1 ;;
    .1.3.6.1.4.1.44687.1.14.8      ) check_apache_requests_logging $1 ;;
    .1.3.6.1.4.1.44687.2           ) check_freebox $1 ;;
    .1.3.6.1.4.1.44687.2.1         ) check_freebox_api_version $1 ;;
    .1.3.6.1.4.1.44687.2.2         ) check_freebox_lan_hosts $1 ;;
    .1.3.6.1.4.1.44687.2.2.1       ) check_freebox_lan_hosts_total $1 ;;
    .1.3.6.1.4.1.44687.2.2.2       ) check_freebox_lan_hosts_online $1 ;;
    .1.3.6.1.4.1.44687.2.3         ) check_freebox_freeplugs $1 ;;
    .1.3.6.1.4.1.44687.2.4         ) check_freebox_upnp $1 ;;
    .1.3.6.1.4.1.44687.2.20        ) check_freebox_system $1 ;;
    .1.3.6.1.4.1.44687.2.20.1      ) check_freebox_system_mac $1 ;;
    .1.3.6.1.4.1.44687.2.20.2      ) check_freebox_system_board_name $1 ;;
    .1.3.6.1.4.1.44687.2.20.3      ) check_freebox_system_fan_rpm $1 ;;
    .1.3.6.1.4.1.44687.2.20.4      ) check_freebox_system_temp_sw $1 ;;
    .1.3.6.1.4.1.44687.2.20.5      ) check_freebox_system_uptime $1 ;;
    .1.3.6.1.4.1.44687.2.20.6      ) check_freebox_system_uptime_value $1 ;;
    .1.3.6.1.4.1.44687.2.20.7      ) check_freebox_system_temp_cpub $1 ;;
    .1.3.6.1.4.1.44687.2.20.8      ) check_freebox_system_temp_cpum $1 ;;
    .1.3.6.1.4.1.44687.2.20.9      ) check_freebox_system_serial $1 ;;
    .1.3.6.1.4.1.44687.2.20.10     ) check_freebox_system_firmware_version $1 ;;
    .1.3.6.1.4.1.44687.2.21        ) check_freebox_connection $1 ;;
    .1.3.6.1.4.1.44687.2.22        ) check_freebox_lan $1 ;;
  esac
}

while getopts ":g:" opts
do
  case ${opts} in
    g ) snmpget $2;;
    * ) exit 0;;
  esac
done

