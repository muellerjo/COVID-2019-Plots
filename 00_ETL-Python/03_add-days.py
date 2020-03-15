#!/usr/bin/env python
# coding: utf-8

# In[2]:


#!/usr/bin/env python3
import io
import pandas as pd

#--------------------------------------------------------------------------------------------
# ETL-Process
#--------------------------------------------------------------------------------------------

DATA = pd.read_csv ('../01_ETLOutput-CSV/02-data-grouped-population.csv', parse_dates=True)
#transform the date from csv from object to datetime
DATA['date'] = DATA['date'].astype('datetime64')

#--------------------------------------------------------------------------------------------
# DAYS SINCE PAT 1
#--------------------------------------------------------------------------------------------

#Method for adding days to the datasets
def add_days(dataframe):
    print("add_days started")
    dates = dataframe.index.get_level_values(1)
    return dataframe.assign(days1=dates - dates[0] + pd.Timedelta(days=1))

#Sex indexes and sort by country and date
df = DATA.set_index(["country", "date"]).sort_index()

#Nummerize since Day 1
df_pat1 = df[df["Confirmed"] > 0].groupby(level=0).apply(add_days)
#remove the word 'day' from days
df_pat1['days1'] = df_pat1['days1'].dt.days
#Write to csv
df_pat1.to_csv('../01_ETLOutput-CSV/03_complete-data-pop-days1.csv')

#--------------------------------------------------------------------------------------------
# DAYS SINCE PAT 100
#--------------------------------------------------------------------------------------------

def add_days100(dataframe):
    print("add_days100 started")
    dates = dataframe.index.get_level_values(1)
    return dataframe.assign(days100=dates - dates[0] + pd.Timedelta(days=1))

#Nummerize since Day 1
df_pat100 = df[df["Confirmed"] >= 100].groupby(level=0).apply(add_days100)
#remove the word 'day' from days
df_pat100['days100'] = df_pat100['days100'].dt.days
#Write to csv
df_pat100.to_csv('../01_ETLOutput-CSV/03_complete-data-pop-days100.csv')


print(df_pat1.head())
print(df_pat100.head())


# In[ ]:




