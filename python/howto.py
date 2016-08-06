python --version #check python version

range(8) #get a sequence of integers from 0 to 7
range(3,7) #get a sequence of integers from 3 to 6
range(2,11,2) #get a sequence of integers from 2 to 10, counting by 2
range(10,1,-2) #get a sequence of integers from 10 to 2, counting down by 2

li = [0,1,2,3,4]
li[1:3] #returns [1,2]
li[1:-1] #returns [1,2,3]

#this gets the parent directory of the parent directory of the currently executing file, 
# even if the file is called from a symbolicly linked file
os.path.dirname(os.path.dirname(os.path.realpath(__file__))) 

','.join(['a','b','c']) # 'a,b,c'
'a,b,c'.split(',') # ['a','b','c']
'a,b,c'.split(',',1) # ['a','b,c'] the second argument tells split the number of times to split

#read a config file
import ConfigParser
config = ConfigParser.ConfigParser()
config.read('mol-sdm.config')
rangeAssetName = config.get('DistanceRaster', 'RangeAsset')

#convert all values in dictionary d to float
d = {k:float(v) for k,v in d.items()}

#CSV files
import csv
with open('myfile.csv', 'rb') as csvfile:
    reader = csv.DictReader(csvfile) #use a dict reader
    firstrow = next(reader) #read first row as a dictionary



