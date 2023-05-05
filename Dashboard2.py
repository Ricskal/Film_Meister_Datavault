import sqlite3
import pandas as pd
import plotly.express as px  # (version 4.7.0 or higher)
import plotly.graph_objects as go
from dash import Dash, dcc, html, Input, Output  # pip install dash (version 2.0.0 or higher)

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

    html.H1("Web Application Filmmeister Dashboard v0.069420", style={'text-align': 'center'}),

    dcc.Dropdown(id="slct_meister",
                 options=[
                     {"label": "Berend", "value": 'Berend'},
                     {"label": "Joris", "value": 'Joris'},
                     {"label": "Jan", "value": 'Jan'},
                     {"label": "Rick", "value": 'Rick'},
                     {"label": "Democratisch", "value": 'Democratisch'}],
                 multi=False,
                 value='Rick',
                 style={'width': "40%"}
                 ),

    html.Div(id='output_container'),
    html.Br(),

    dcc.Graph(id='my_bee_map')

])


# ------------------------------------------------------------------------------
# Connect the Plotly graphs with Dash Components
@app.callback(
    [Output(component_id='output_container', component_property='children'),
     Output(component_id='my_bee_map', component_property='figure')],
    [Input(component_id='slct_meister', component_property='value')]
)
def update_graph(option_slctd):
    print(option_slctd)
    print(type(option_slctd))

    container = "The meister chosen by user was: {}".format(option_slctd)

    dff = df.copy()
    dff = dff[dff['Film Meister'] == option_slctd]

    # Plotly Express
    fig = px.bar(
        data_frame=dff,
        x='Film Meister',
        y='Aantal Films'
    )
    # fig = px.choropleth(
    #     data_frame=dff,
    #     locationmode='USA-states',
    #     locations='state_code',
    #     scope="usa",
    #     color='Pct of Colonies Impacted',
    #     hover_data=['State', 'Pct of Colonies Impacted'],
    #     color_continuous_scale=px.colors.sequential.YlOrRd,
    #     labels={'Pct of Colonies Impacted': '% of Bee Colonies'},
    #     template='plotly_dark'
    # )

    # Plotly Graph Objects (GO)
    # fig = go.Figure(
    #     data=[go.Choropleth(
    #         locationmode='USA-states',
    #         locations=dff['state_code'],
    #         z=dff["Pct of Colonies Impacted"].astype(float),
    #         colorscale='Reds',
    #     )]
    # )
    #
    # fig.update_layout(
    #     title_text="Bees Affected by Mites in the USA",
    #     title_xanchor="center",
    #     title_font=dict(size=24),
    #     title_x=0.5,
    #     geo=dict(scope='usa'),
    # )

    return container, fig


# ------------------------------------------------------------------------------
if __name__ == '__main__':
    app.run_server(debug=True)
