#Count processes running as each user:

ps -ef | awk '{print$1}' | sort | uniq -c | sort -nr
