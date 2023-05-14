import sqlite3
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
from dash import Dash, dcc, html, Input, Output
from tabulate import tabulate

database = 'C:\\FilmMeister\\FilmMeister.db'
excelsheet_name = 'C:\\FilmMeister\\Filmavonden.xlsx'
excelsheet_sheet = 'Mastersheet'

app = Dash(__name__)

# Connect to the SQLite database
db_conn = sqlite3.connect(database)
c = db_conn.cursor()

# Execute a query to retrieve the data you want to plot
df1 = pd.read_sql_query('''
    select 
          sum(dff.Aantal_Films) as 'Aantal Films'
        , ddm.Film_Meister as 'Film Meister'
    from dm_fact_filmavond dff
    join dm_dim_meister ddm 
        on dff.Dim_Meister_key = ddm.Dim_Meister_Key 
    group by ddm.Film_Meister;
    ''', con=db_conn)

df2 = pd.read_sql_query('''
    select 
          dff.Aantal_Films as 'Aantal Films'
        , ddm.Film_Meister as 'Film Meister'
        , ddf.Film_Jaar as 'Film Jaar'
    from dm_fact_filmavond dff
    join dm_dim_meister ddm 
        on dff.Dim_Meister_key = ddm.Dim_Meister_Key 
    join dm_dim_film ddf 
        on dff.Dim_Film_key = ddf.Dim_Film_Key;
    ''', con=db_conn)

df2['Film Jaar'] = df2['Film Jaar'].astype(int)
df2.head()

# ------------------------------------------------------------------------------
# App layout.
app.layout = html.Div([

    # Header.
    html.Div(
        html.H1("Web Application Filmmeister Dashboard",
                style={"text-align": "center", "background-color": "lightblue"})
    ),

    # Main.
    html.Div(
        children=[

            # Column 1. Control panel.
            html.Div(
                dcc.Checklist(
                    id="slct_meister",
                    options=[
                        {"label": "Berend", "value": "Berend"},
                        {"label": "Joris", "value": "Joris"},
                        {"label": "Jan", "value": "Jan"},
                        {"label": "Rick", "value": "Rick"},
                        {"label": "Democratisch", "value": "Democratisch"}
                    ],
                    value=["Berend"]
                ),
                style={"display": "inline-block", "width": "10%", "height": "100%", "background-color": "lightblue"}
            ),

            # Column 2. Graphs.
            html.Div(
                children=[
                    html.Div(dcc.Graph(id="graph1")),
                    html.Div(dcc.Graph(id="graph3")),
                ]
                , style={"display": "inline-block", "width": "50%", "background-color": "lightblue"}),

            # Column 3. Graphs.
            html.Div(
                children=[
                    html.Div(dcc.Graph(id="graph2")),
                    html.Div(dcc.Graph(id="graph4")),
                ]
                , style={"display": "inline-block", "width": "50%", 'height': "50%", "background-color": "lightblue"})
        ],
        style={"display": "flex", "height": "90%"}
    ),

    # Footer.
    html.Div(
        html.H2("Onderkant", style={"text-align": "right", "background-color": "lightblue"})
    )
])


# ------------------------------------------------------------------------------
# Connect the Plotly graphs with Dash Components
@app.callback(
    [Output(component_id='graph1', component_property='figure'),
     Output(component_id='graph2', component_property='figure'),
     Output(component_id='graph3', component_property='figure')],
    Input(component_id='slct_meister', component_property='value')
)
def update_graph(option_slctd):
    dff1 = df1.copy()
    dff1 = dff1[dff1['Film Meister'].isin(option_slctd)]

    # Plotly Express graph 1
    fig1 = px.bar(
        data_frame=dff1,
        x='Film Meister',
        y='Aantal Films'
    )
    fig1.update_layout(
        title_text="graph 1",
        title_xanchor="center",
        title_font=dict(size=24),
        title_x=0.5,
    )

    dff2 = df2.copy()
    dff2 = dff2[dff2['Film Meister'].isin(option_slctd)]

    # Plotly Express graph 2
    fig2 = px.bar(
        data_frame=dff2,
        x='Film Jaar',
        y='Aantal Films'
    )
    fig2.update_layout(
        title_text="graph 2",
        title_xanchor="center",
        title_font=dict(size=24),
        title_x=0.5,
    )

    # Plotly Express graph 3

    dff3 = df2.copy()
    dff3 = dff3[dff3['Film Meister'].isin(option_slctd)]
    # dff3 = dff3.groupby(['Film Meister', 'Film Jaar']).sum().reset_index()
    # print(tabulate(dff3, headers='keys', tablefmt='psql'))

    fig3 = px.treemap(
        data_frame=dff3,
        path=['Film Meister', 'Film Jaar'],
        values='Aantal Films'
    )
    fig3.update_layout(
        title_text="graph 3",
        title_xanchor="center",
        title_font=dict(size=24),
        title_x=0.5,
    )

    return fig1, fig2, fig3


# ------------------------------------------------------------------------------
if __name__ == '__main__':
    app.run_server(debug=True)
