import numpy as np 
import pandas as pd
import matplotlib.pyplot as plt,mpld3
%matplotlib inline 

from shapely.geometry import Polygon,mapping 
import geopandas as gpd
import folium 
def state_style(state,function=False):
    """
    Returns the style for a state in a given year
    """
    
    state_results = result[state]
    
    #Set state colour
    if state_results['dem'] >= state_results['rep']:
        color = '#4f7bff' #blue
    else:
        color = '#ff5b4f' #red
    
    #Set state style
    if function == False:
        # Format for style_dictionary
        state_style = {
            'opacity': 1,
            'color': color,
        } 
    else:
        # Format for style_function
        state_style = {
             'fillOpacity': 1,
             'weight': 1,
             'fillColor': color,
             'color': '#000000'}    

    return state_style

def style_function(feature):
    """
    style_function used by the GeoJson folium function
    """

    state = feature['properties']['state_name']
    style = state_style(state,function=True)
    
    return style

def getFigure(state):
    """
    Plot COVID-19 trends from a given state
    """

    #Get number of cases
    months = ['February','March','April','May','June','July','August','September','October','November']
    pos = []
    death =[]
    for month in months:

        result = results1[state][month]
        pos.append(result['pos'])  
        death.append(result['death']) 

    #Plot number of cases    
    fig = plt.figure(figsize=(8,4))
    plt.plot(months,pos,label='Positive',color='#4f7bff')
    plt.plot(months,death,label='death',color='#ff5b4f')

    plt.title(state,size = 18)
    #plt.ticklabel_format(style='plain')
    plt.xlabel('Month',size =14)
    plt.ylabel('Cases',size =14)
    plt.legend(loc =0)

    #Add figure to iframe
    html = mpld3.fig_to_html(fig)
    iframe = folium.IFrame(html=html,width = 600, height = 300)

    return iframe

def highlight_style(feature): 
    """
    style_function for when choropleth button
    is highighted
    """
    return {'fillOpacity': 0.2,
         'weight': 1,
         'fillColor': '#000000',
         'color': '#000000'}
def us_state_visualization(db_user, db_pwd,db_name):
    #connect to database
    db_connection = connect_to_db("127.0.0.1", db_user, db_pwd, db_name)
    cur = db_connection.cursor()
    
    #read us shape to output our national graph 
    us_shape = gpd.read_file('States 21basic/geo_export_5a3c36b9-5725-48f7-932f-b261016d93ea.shp')
    us_shape = us_shape[['state_name','geometry']]
    
    cur.callproc("get_election_data")
    db_connection.commit()
    
    election = pd.read_sql("select * from result;", con=db_connection)
    states = set(election['state'])
    result = {}
    for state in states:
        dem = election[(election.Year == 2016) & (election.state == state)]['dem_votes'].values[0]
        rep = election[(election.Year == 2016) & (election.state == state)]['rep_votes'].values[0]
        #print(state,dem)
        result[state] = {'dem':dem, 'rep':rep}
    
    #plot the choropleth 
    m = folium.Map(location=[50.77500, -100],zoom_start=3)
    choropleth =folium.GeoJson(data= us_shape.to_json(),style_function=style_function)
    m.add_child(choropleth)
    
    #get COVID cases 
    cur.callproc("get_COVID_data")
    db_connection.commit()
    election = pd.read_sql("select * from result;", con=db_connection)
    states = set(cases['state'])
    months = set(cases['month'])
    results1 = {}
    for state in states:
        result1 = {}
        for month in months:
            positive = cases[(cases.month == month) & (cases.state == state)]['positive'].values
            if(positive.size == 0):
                pos = 0
            else:
                pos = positive[0]
            death = cases[(cases.month == month) & (cases.state == state)]['death'].values
            if(death.size == 0):
                death1 = 0
            else:
                death1 = death[0]
            result1[month] = {'pos':pos, 'death':death1}
    results1[state] = result1
    
    #plot choropleth button map
    m = folium.Map(location=[50.77500, -100],zoom_start=3)
    choropleth =folium.GeoJson(data= us_shape.to_json(),style_function=style_function)
    m.add_child(choropleth)
    
    #Create popup button for each state
    for i in range(len(us_shape)):
        geometry = us_shape.loc[i]['geometry']
        state_name = us_shape.loc[i]['state_name']
        popup = folium.Popup(getFigure(state_name),max_width=1000)
        state_marker = folium.GeoJson(data=mapping(geometry),highlight_function = highlight_style)
        state_marker.add_child(popup)
        m.add_child(state_marker)

    m.save("us_election_map2.html")

us_state_visualiation(#input user name )
