#http://johnkerl.org/miller/doc/10-min.html

#---- outputing files ----
mlr --csv head
mlr --csv head -n 4

mlr --csv filter '$behav == 4' sample.csv #filter
mlr --csv --opprint --from sample.csv stats1 -a count -f bird_id -g bird_id #group by bird_id and count number of rows

--csv #is a normal csv
--icsv #is a csv in the form of field=value
--ooprint #pretty prints the results to the screen
-I #performs the file manipulation in place

#use 'head then' command to test out command on smaler dataset 
mlr --csv head -n 4 then cut -x -f l8ndvi_monthly_30m obsbg_anno.bak

#---- dropping fields ----
mlr --csv cut -x -f l8ndvi_monthly_30m obsbg_anno.bak > obsbg_anno.csv

#---- extracting data ----

#Extract id column from a control file into an array
popIds=($(mlr --csv filter '$run==1' then cut -f pop_id ctfs/population.csv | tail -n +2))

#---- creating new fields ----
mlr --csv --opprint put -S '$type=typeof($bird_id)' sample_walk.csv #see the data type
mlr --csv --opprint put -S '$tag_id=sub($bird_id, "^([0-9]{4})0([0-9]{3})$", "\1")' sample_walk.csv #pull out the first 4 digits
# -S keeps the bird_id field as character and does not convert to number
# \1 refers to the first group match
mlr --csv put -S '$bird_id =~ "^([0-9]{4})0([0-9]{3})$"; $tag_id="\1"; $ring_id="\2"' sample_walk.csv #both tag_id and ring_id
#note the =~ operator as the first item. Then, \1 and \2 group matches persist to the next column defintion.

mlr --csv put '$timestamp = $date . "T" . $time . "Z"' sample_walk.csv #string concatenation

#---- grouping ----
#use to get a list of unique values in a column
mlr --csv --from storks_4ben_walk.csv stats1 -a count -f tag_id -g tag_id #count, grouped by tag_id
