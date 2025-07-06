#!/bin/bash

echo "🚀 Installing Python packages..."
python3 -m pip install --upgrade pip
python3 -m pip install pandas requests beautifulsoup4 dash plotly lxml

echo "✅ Done installing packages."

# ----------------------------------------------------------
# DATA COLLECTION (API) - Example SpaceX API call
# ----------------------------------------------------------

echo "🌐 Downloading SpaceX launch data via API..."

# Use curl to fetch SpaceX launches data
curl -s "https://api.spacexdata.com/v4/launches" -o launches_raw.json

echo "✅ SpaceX API data saved to launches_raw.json"

# ----------------------------------------------------------
# OPTIONAL - DATA SCRAPING (e.g. Wikipedia backup)
# ----------------------------------------------------------

echo "🌐 Scraping backup data from Wikipedia (example)..."

python3 <<EOF
import requests
from bs4 import BeautifulSoup
import pandas as pd

# Example scrape: SpaceX launches table from Wikipedia
url = "https://en.wikipedia.org/wiki/List_of_Falcon_9_and_Falcon_Heavy_launches"
response = requests.get(url)
soup = BeautifulSoup(response.content, "lxml")

# Find first table
table = soup.find("table", {"class": "wikitable"})
if table:
    df_html = pd.read_html(str(table))[0]
    df_html.to_csv("wikipedia_spacex_launches.csv", index=False)
    print("✅ Scraped Wikipedia table saved to wikipedia_spacex_launches.csv")
else:
    print("⚠️ No table found in page.")

EOF

# ----------------------------------------------------------
# DATA WRANGLING
# ----------------------------------------------------------

echo "🛠️ Starting data wrangling..."

python3 <<EOF
import pandas as pd
import json

# Load SpaceX API JSON
with open("launches_raw.json") as f:
    launches_data = json.load(f)

# Convert JSON to DataFrame
df = pd.json_normalize(launches_data)

# Keep relevant columns
columns_needed = [
    "name",
    "date_utc",
    "rocket",
    "payloads",
    "success",
    "details"
]
df = df[columns_needed]

# Parse dates
df["date_utc"] = pd.to_datetime(df["date_utc"])

# Handle nulls
df["details"] = df["details"].fillna("No details")

# Save cleaned data
df.to_csv("spacex_cleaned_data.csv", index=False)
print("✅ Cleaned SpaceX API data saved to spacex_cleaned_data.csv")

EOF

# ----------------------------------------------------------
# DASHBOARD LAUNCH
# ----------------------------------------------------------

echo "🚀 Launching Plotly Dash dashboard..."

# Create a simple Dash app
cat <<PYTHONCODE > spacex_dash_app.py
import pandas as pd
from dash import Dash, dcc, html, Input, Output
import plotly.express as px

# Load cleaned data
df = pd.read_csv("spacex_cleaned_data.csv")

app = Dash(__name__)

app.layout = html.Div([
    html.H1("SpaceX Launch Dashboard"),
    dcc.Dropdown(
        id='launch-dropdown',
        options=[{'label': name, 'value': name} for name in df['name'].unique()],
        placeholder="Select a launch mission"
    ),
    dcc.Graph(id='launch-chart')
])

@app.callback(
    Output('launch-chart', 'figure'),
    Input('launch-dropdown', 'value')
)
def update_chart(selected_launch):
    if selected_launch:
        filtered = df[df['name'] == selected_launch]
    else:
        filtered = df
    fig = px.scatter(filtered, x='date_utc', y='success', hover_data=['details'])
    return fig

if __name__ == "__main__":
    app.run_server(debug=True, port=8050)
PYTHONCODE

# Run the Dash app
python3 spacex_dash_app.py

echo "✅ Dashboard running at http://127.0.0.1:8050/"
