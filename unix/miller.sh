
mlr --csv filter '$behav == 4' sample.csv #filter
mlr --csv --opprint --from sample.csv stats1 -a count -f bird_id -g bird_id #group by bird_id and count number of rows
