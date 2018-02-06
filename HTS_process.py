#################################
#####                      ######
#####      HTS_process.py  ######
#####                      ######
#################################
#####                      ######
##### AUTHOR: KYLE STIERS  ######
# https://github.com/KyleStiers #
#################################

from collections import OrderedDict
from datetime import datetime

#filename = input('what is the name of the file to be opened: ')

with open("HTSresults.txt", 'r') as o:
    listdata = o.readlines()
    
plate_flag = 0
datablock = ""
hts = {}
temp_times = OrderedDict()
ordered_time_deltas = []

###############
## FUNCTIONS ##
###############

def flatten_list(string):
    return(','.join(map(str, string))) 
    
def get_row(well):
    return(int(well/12)+1)
    
def get_column(well):
    return((well-((get_row(well)-1)*12))+1)

def get_type(key,well):
    pos = get_column(well)
    pos_cntrl_wells = ["1","13","25","37","49","61","73","85"]
    neg_cntrl_wells = ["12","24","36","48","60","72","84","96"]
    if str(pos) in pos_cntrl_wells:
        return("posCTRL")
    if str(pos) in neg_cntrl_wells:
        return("negCTRL")
    else:
        if(int(mydict_end[key+"_end"].split(",")[well]) > 400000 or int(mydict_first[key].split(",")[well]) > 400000):
            return("overload")
        else:
            return("sample")

def get_compound(well):
    ##TODO
    return(0)

def get_times(times):
    # Example of times, '11:30:13'
    temp = []
    FMT = '%H:%M:%S'
    for i in range(1,(len(times)/2)+1):
        temp_delta = datetime.strptime(times["Plate_"+str(i)+"_end"], FMT)-datetime.strptime(times["Plate_"+str(i)], FMT)
        temp.append(temp_delta.total_seconds())
    return(temp)
    
def get_rate(key,i,plate):
        diff = int(mydict_end[key+"_end"].split(",")[i])-int(mydict_first[key].split(",")[i])
        return(diff/ordered_time_deltas[(plate-1)])
    
#####################
#### END FUNCTIONS ##   
##################### 

for line in listdata:
    if line.find("Plate_")!=-1:
        index = line.index("Plate_")
        time_index = line.index(":")
        plate_name= line[index:(index+8)].strip(",")
        if plate_name in temp_times:
            temp_times[plate_name+"_end"] = line[(time_index-2):(time_index+6)]
        else:
            temp_times[plate_name] = line[(time_index-2):(time_index+6)]
    if line.find("EnVisionData") !=-1:
        if plate_name in hts:
            hts[plate_name+"_end"] = datablock
        else:
            hts[plate_name]= datablock
        datablock=""
    else:
        datablock += line

ordered_time_deltas = get_times(temp_times)
#print(ordered_time_deltas)

mydict_first = OrderedDict()  # keeps things in order
mydict_end = OrderedDict()

for i in range(1,(len(hts)/2)+1):
    mydict_first["Plate_"+str(i)] = flatten_list(hts["Plate_"+str(i)].split("\n")[1:9])
    mydict_end["Plate_"+str(i)+"_end"] = flatten_list(hts["Plate_"+str(i)+"_end"].split("\n")[1:9])

#print(mydict_first)
#print(mydict_end)

formatted_data = 'Barcode,XPOS,YPOS,WELL_USAGE,COMPOUND,VALUE'
plate_counter = 1
for key in mydict_first:
    for i in range(0,96):
        formatted_data += "\n"+key+","+str(get_row(i))+","+str(get_column(i))+","+get_type(key,i)+","+str(get_compound(i))+","+str(get_rate(key,i,plate_counter))
    plate_counter += 1
with open("output.csv", "w") as text_file:
    text_file.write("{0}".format(formatted_data))