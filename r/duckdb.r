dbConnect(duckdb(), .dbPF, read_only=TRUE) # Open in read only mode. Seems to not create a lock file

#To select a column that is a reserved keyword
"select spid, \"group\" from loc l where data_type='pa'"
