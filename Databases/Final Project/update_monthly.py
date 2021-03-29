import csv
import pandas as pd
from datetime import datetime

if __name__ == "__main__":
	url = "https://covidtracking.com/data/download/all-states-history.csv"
	data = pd.read_csv(url)
	data = data[['date','state','death','positive','recovered']]
	us_state_abbrev = {
    'Alabama': 'AL',
    'Alaska': 'AK',
    'Arizona': 'AZ',
    'Arkansas': 'AR',
    'California': 'CA',
    'Colorado': 'CO',
    'Connecticut': 'CT',
    'Delaware': 'DE',
    'District of Columbia': 'DC',
    'Florida': 'FL',
    'Georgia': 'GA',
    'Hawaii': 'HI',
    'Idaho': 'ID',
    'Illinois': 'IL',
    'Indiana': 'IN',
    'Iowa': 'IA',
    'Kansas': 'KS',
    'Kentucky': 'KY',
    'Louisiana': 'LA',
    'Maine': 'ME',
    'Maryland': 'MD',
    'Massachusetts': 'MA',
    'Michigan': 'MI',
    'Minnesota': 'MN',
    'Mississippi': 'MS',
    'Missouri': 'MO',
    'Montana': 'MT',
    'Nebraska': 'NE',
    'Nevada': 'NV',
    'New Hampshire': 'NH',
    'New Jersey': 'NJ',
    'New Mexico': 'NM',
    'New York': 'NY',
    'North Carolina': 'NC',
    'North Dakota': 'ND',
    'Ohio': 'OH',
    'Oklahoma': 'OK',
    'Oregon': 'OR',
    'Pennsylvania': 'PA',
    'Rhode Island': 'RI',
    'South Carolina': 'SC',
    'South Dakota': 'SD',
    'Tennessee': 'TN',
    'Texas': 'TX',
    'Utah': 'UT',
    'Vermont': 'VT',
    'Virginia': 'VA',
    'Washington': 'WA',
    'West Virginia': 'WV',
    'Wisconsin': 'WI',
    'Wyoming': 'WY'
}
	abbrev_us_state = dict(map(reversed, us_state_abbrev.items()))
	data['month'] = pd.to_datetime(data['date'], format='%Y-%m-%d').dt.month
	data['Year'] = pd.to_datetime(data['date'], format='%Y-%m-%d').dt.year
	data['state'] = data['state'].map(abbrev_us_state)
	data = data.dropna(subset=['state'])
	today = datetime.today()
	year = today.year
	month = today.month
	data = data.loc[(data['month'] == month) & (data['Year'] == year)]
	data = data.groupby(['state']).mean().round(0)
	data['month'] = pd.to_datetime(data['month'], format='%m').dt.month_name()
	#rearrange the columns 
	cols = ['month','death','positive','recovered']
	data = data[cols]
	data = data.fillna(0)
	data.to_csv('cases_by_day.csv', index=False) 


