import pandas as pd
import streamlit as st
import altair as alt

df = pd.DataFrame({
    'x': [1, 2, 3, 4, 5],
    'y': [10, 20, 30, 40, 50]
})

chart = alt.Chart(df).mark_line().encode(
    x='x',
    y='y'
).interactive()

st.altair_chart(chart, use_container_width=True)