
myrec.dtype.names #print headers of the recarray

#save myrecarray to csv file. 
# first make the header
# fmt='%s' so it saves all fields as strings
# comments='' so that it won't print a '#' at the beginning
header = ','.join(myrec.dtype.names)
np.savetxt('myrec.csv',myrec, fmt='%s', delimiter=',', header=header, comments='') 

#open a csv file from disk and load into a recarray
with open(csvFilePath,'rb') as csvfile:
    csvrows = [row.replace('"', '') for row in csvfile]
    feats = np.recfromcsv(csvrows, delimiter=',', autostrip=True)
