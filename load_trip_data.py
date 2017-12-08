#------------------------
# load_trip_data.py
#------------------------

import pandas as pd
import numpy as np
import h5py
import json

# Load trip_final data from json:
json_filepath='/trip_final.json' # Add the path to the trip_final json here.
with open(json_filepath) as json_data:
    trip_final = json.load(json_data) 	
# Load the burrough shapefiles:
json_filepath='/LIMADMIN.json' # Add the path to the LIMADMIN.json file here.
with open(json_filepath) as json_data_aronds:
    burrShapes = json.load(json_data_aronds) 

nBurroughs=len(burrShapes['features'])
for nB in range(0,nBurroughs):   
    burrough_array=[]
    burrough_array=np.asarray(burrShapes['features'][nB]['geometry']['coordinates'][0][0])

# Load the burrough names into a list, and correct the erroneous characters.
nBurroughs=len(burrShapes['features'])
burr_name_list=[]
for nB in range(0,nBurroughs):   
    burr_name_list.append(burrShapes['features'][nB]['properties']['NOM'])
    
    # Fix the ones with strange characters.
    if burr_name_list[nB] == 'RiviÃ¨re-des-Prairies-Pointe-aux-Trembles':
        burr_name_list[nB] = 'Rivière-des-Prairies-Pointe-aux-Trembles'
    if burr_name_list[nB] == 'MontrÃ©al-Nord':
        burr_name_list[nB] = 'Montréal-Nord'       
    if burr_name_list[nB] == "L'ÃŽle-Bizard-Sainte-GeneviÃ¨ve":
        burr_name_list[nB] = "L'Île-Bizard–Sainte-Geneviève"         
    if burr_name_list[nB] == 'CÃ´te-Saint-Luc':
        burr_name_list[nB] = 'Côte-Saint-Luc'           
    if burr_name_list[nB] == 'Saint-LÃ©onard':
        burr_name_list[nB] = 'Saint-Léonard'           
    if burr_name_list[nB] == 'MontrÃ©al-Ouest':
        burr_name_list[nB] = 'Montréal-Ouest'          
    if burr_name_list[nB] == "L'ÃŽle-Dorval":
        burr_name_list[nB] = "L'Île-Dorval"  
    if burr_name_list[nB] == 'CÃ´te-des-Neiges-Notre-Dame-de-GrÃ¢ce':
        burr_name_list[nB] = 'Côte-des-Neiges—Notre-Dame-de-Grâce'   
    if burr_name_list[nB] == 'MontrÃ©al-Est':
        burr_name_list[nB] = 'Montréal-Est'
    if burr_name_list[nB] == "Baie-d'UrfÃ©":
        burr_name_list[nB] = "Baie-d'Urfé"


	
# Load trip_final data from dictionary into numpy arrays
numIds=len(trip_final['features'])
avgSpeed=np.empty((numIds,1))
duration=np.empty((numIds,1))
ids=np.empty((numIds,1)) # Create an empty array
coords_if=np.empty((numIds,4)) # Create an empty array to hold initial and final coordinates

for i in range(0,numIds): # When choosing range for loop, don't need -1
    ids[i]=trip_final["features"][i]["properties"]["id_trip"]
    avgSpeed[i]=trip_final["features"][i]["properties"]["avg_speed"]
    duration[i]=trip_final["features"][i]["properties"]["duration"]
    
    if trip_final["features"][i]["geometry"] is not None:  # This is to catch the instances where there aren't any 'geometry' entries
        coords_if[i,0]=trip_final["features"][i]["geometry"]["coordinates"][0][0][0]
        coords_if[i,1]=trip_final["features"][i]["geometry"]["coordinates"][0][0][1]
        coords_if[i,2]=trip_final["features"][i]["geometry"]["coordinates"][0][-1][0]
        coords_if[i,3]=trip_final["features"][i]["geometry"]["coordinates"][0][-1][1]
    else:
        coords_if[i,:]=np.nan

		
		
# Load the categorical data, and clean up the text to be better understood		
numIds=len(trip_final['features'])
mode=[]
purpose=[]

for i in range(0,numIds):
    mode.append(trip_final["features"][i]["properties"]["mode"])
    purpose.append(trip_final["features"][i]["properties"]["purpose"])
    if mode[i]=="Ã€ pied":
        mode[i] = "pedestrian"
    if mode[i]=="VÃ©lo":
        mode[i] = "cyclist"
    if mode[i]=="Transport Collectif":
        mode[i] = "publicTransit"
    if mode[i]=="Autre combinaison":
        mode[i] = "otherCombo"
        
    if purpose[i]=="Retour Ã\xa0 la maison":
        purpose[i] = "toHome"
    if purpose[i]=="Travail":
        purpose[i] = "toWork"        
    if purpose[i]=="Loisir":
        purpose[i] = "leisure" 
    if purpose[i]=="Magasinage / Commission":
        purpose[i] = "errand" 
    if purpose[i]=="Repas / collation /cafÃ©":
        purpose[i] = "mealSnackCafe" 
    if purpose[i]=="Repas / collation /cafÃ©":
        purpose[i] = "foodDrink"        
    if purpose[i]=="DÃ©poser / Ramasser":
        purpose[i] = "childDropoffPickup" 
    if purpose[i]=="Ã‰ducation":
        purpose[i] = "school"        
    if purpose[i]=="SantÃ©":
        purpose[i] = "health"                       
  
