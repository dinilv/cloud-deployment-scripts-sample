cd ~/code/backend/cmp-config/log
sudo rm -rf *
cd ../
source ~/.rvm/scripts/rvm
rvm use default
#kill existing process
rspid=$(cat resque_schedule.pid)
kill -9 $rspid
rwpid=$(cat resque.pid)
kill -9 $rwpid
rwpid2=$(cat resque2.pid)
kill -9 $rwpid2
rwpid3=$(cat resque3.pid)
kill -9 $rwpid3
pids=($(ps -ef | grep 'resque' | grep 'access_log' | awk '{print $2}'))
for i in "${pids[@]}"
do
   :
  echo $i
  kill -9 $i
done
#start process
env COUNT='10' PIDFILE=./resque.pid BACKGROUND=yes QUEUE=access_log,mailing_queue,currency_exchange_queue,token_renew_queue,\
aggregator_campaign_media_daily,aggregator_campaign_media_cp_daily,aggregator_campaign_operator_daily,aggregator_campaign_operator_cp_daily,\
aggregator_campaign_daily,aggregator_campaign_cp_daily,\
aggregator_campaign_thirty,aggregator_campaign_lifetime,\
aggregator_campaign_media_lifetime,aggregator_campaign_operator_lifetime\
RAILS_ENV=development rake resque:workers >> log/resque_campaign.log &

env COUNT='1' PIDFILE=./resque2.pid BACKGROUND=yes QUEUE=aggregator_account_media_daily,,aggregator_account_operator_daily,aggregator_account_daily,\
aggregator_account_media_lifetime,aggregator_account_operator_lifetime,aggregator_account_lifetime\
RAILS_ENV=development rake resque:workers >> log/resque_account.log &

env COUNT='10' PIDFILE=./resque3.pid BACKGROUND=yes QUEUE=aggregator_msisdn_daily,aggregator_msisdn_lifetime\
RAILS_ENV=development rake resque:workers >> log/resque_msisdn.log &

env PIDFILE=./resque_schedule.pid BACKGROUND=yes QUEUE="*"\
RAILS_ENV=development rake resque:scheduler >> log/resque_schedule.log &
