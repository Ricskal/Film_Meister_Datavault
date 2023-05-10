import sqlite3
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
from dash import Dash, dcc, html, Input, Output

database = 'C:\\FilmMeister\\FilmMeister.db'
excelsheet_name = 'C:\\FilmMeister\\Filmavonden.xlsx'
excelsheet_sheet = 'Mastersheet'

app = Dash(__name__)

# Connect to the SQLite database
db_conn = sqlite3.connect(database)
c = db_conn.cursor()

# Execute a query to retrieve the data you want to plot
df = pd.read_sql_query('''
    select 
          sum(dff.Aantal_Films) as 'Aantal Films'
        , ddm.Film_Meister as 'Film Meister'
    from dm_fact_filmavond dff
    join dm_dim_meister ddm 
        on dff.Dim_Meister_key = ddm.Dim_Meister_Key 
    group by ddm.Film_Meister;
    ''', con=db_conn)

print(df)

# ------------------------------------------------------------------------------
# App layout
app.layout = html.Div([

    # Header
    html.Div(
        html.H1("Web Application Filmmeister Dashboard v0.069420", style={'text-align': 'center', 'height': '100%'})),

    # Main
    html.Div(
        children=[
            # Column 1. Control panel
            html.Div(

                dcc.Checklist(id="slct_meister",
                       options=[
                           {"label": "Berend", "value": 'Berend'},
                           {"label": "Joris", "value": 'Joris'},
                           {"label": "Jan", "value": 'Jan'},
                           {"label": "Rick", "value": 'Rick'},
                           {"label": "Democratisch", "value": 'Democratisch'}],
                       value=['Berend'])

                , "Column 1, Control panel", style={'display': 'inline-block', 'width': '20%'}),

            # Column 2
            html.Div(
                [
                    html.Div("Column 2 row 1", style={'hight': '50%'}),
                    html.Div("Column 2 row 2", style={'hight': '50%'})
                ], style={'display': 'inline-block', 'width': '40%'}),

            # Column 3
            html.Div(
                [
                    html.Div("Column 3 row 1", style={'hight': '50%'}),
                    html.Div("Column 3 row 2", style={'hight': '50%'})
                ], style={'display': 'inline-block', 'width': '40%'}),
        ], style={'height': '10%'}),

    # Footer
    html.Div(html.H2("Onderkant", style={'text-align': 'right', 'height': '10%'})),

])




dcc.Graph(id='my_bee_map')


# ------------------------------------------------------------------------------
# Connect the Plotly graphs with Dash Components
@app.callback(
    Output(component_id='my_bee_map', component_property='figure'),
    Input(component_id='slct_meister', component_property='value')
)
def update_graph(option_slctd):
    dff = df.copy()
    dff = dff[dff['Film Meister'].isin(option_slctd)]

    # Plotly Express
    fig = px.bar(
        data_frame=dff,
        x='Film Meister',
        y='Aantal Films'
    )
    fig.update_layout(
        title_text="Bees Affected by Mites in the USA",
        title_xanchor="center",
        title_font=dict(size=24),
        title_x=0.5,
        geo=dict(scope='usa'),
    )

    return fig


# ------------------------------------------------------------------------------
if __name__ == '__main__':
    app.run_server(debug=True)
