from flask import Flask, request, render_template      
#from flask import render_template
import numpy as np

import requests
from google.transit import gtfs_realtime_pb2

import json
import plotly 
import plotly.graph_objects as go
from plotly.subplots import make_subplots


class StmViz:
    def getBuses():

		'''
		Fetch the current bus position from the stm api url, 
		Parse the location and return as an array
		
		'''
	
        url = "https://api.stm.info/pub/od/gtfs-rt/ic/v1/vehiclePositions/"
        key = '<YOUR API KEY GOES HERE>' # Primary key for real-time visualization
  
        # Get the bus position data
        headers = {
        'apikey': key
        }
        response = requests.request("POST", url, headers=headers)
        
        
        feed = gtfs_realtime_pb2.FeedMessage()
        feed.ParseFromString(response.content)

        #Process the feed data
        
        entities = feed.entity
        
        locations = np.empty([len(entities),2])
        for i,entity in enumerate(entities):
            locations[i,0] = entity.vehicle.position.longitude
            locations[i,1] = entity.vehicle.position.latitude   
            
        return locations
        
        
    def create_map():
		
		'''
		Create a navigable plotly scatterplot on a map, which the bus locations plotted.
		
		'''
        locations = StmViz.getBuses()
    
        mapbox_access_token = 'pk.eyJ1IjoicXVvcnVtZXRyaXgiLCJhIjoiY2p5OHFzaHU3MDJjOTNocjFkcGI3czh1eSJ9.sy8pqCm5v-3Wcp36JLwCeA'
        
        fig = go.Figure(go.Scattermapbox(
                lat=locations[:,1],
                lon=locations[:,0],
                mode='markers',
                marker=go.scattermapbox.Marker(
                    size=5,
                    color='rgb(20, 20, 255)',
                    opacity=0.7
                ),

                hoverinfo='text',
                showlegend=False,
                name="Bus Positions"))#,

        fig.update_layout(
            hovermode='closest',
            mapbox=go.layout.Mapbox(
                accesstoken=mapbox_access_token,
                bearing=0,
                center=go.layout.mapbox.Center(
                    lat=45.52,
                    lon=-73.7
                ),
                pitch=0,
                zoom=8,
               
            )
        )

        graphJSON = json.dumps(fig, cls=plotly.utils.PlotlyJSONEncoder)

        return graphJSON

    
    
    
    def get_position_list():
    
        locations = StmViz.getBuses()
        position_list = json.dumps(locations, cls=NumpyEncoder)

        return position_list
    
    
    
    
class NumpyEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, np.ndarray):
            return obj.tolist()
        return json.JSONEncoder.default(self, obj)


