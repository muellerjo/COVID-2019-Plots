#!/usr/bin/env python
# coding: utf-8

# In[16]:


import pandas as pd
import glob
import datetime
import os
import sqlite3

#Define path, where I cloned the csv files from Johns Hopkins Github Repository
path = '..\..\Clone-Data-COVID-19\csse_covid_19_data\csse_covid_19_daily_reports' # use your path
all_files = glob.glob(path + "/*.csv")

#Creating empty list
li = []

#print(all_files)
print("List of found data: \n")
for filename in all_files:
    datas= filename.lstrip(path)
    print(datas)

for filename in all_files:
    df = pd.read_csv(filename, index_col=None, header=0)
    #get date out of filename
    date = filename.rstrip('.csv').lstrip(path)
    #Convert date format
    date2=datetime.datetime.strptime(date, '%m-%d-%Y').strftime('%Y-%m-%d')
    #print(date2)
    #write date to Dataframe
    df['date']=date2
    li.append(df)


#Write list do dataframe
frame = pd.concat(li, axis=0, ignore_index=True)

#Rename Columns
frame=frame.rename(columns={'Country/Region':'country','Province/State':'province'})

print("\n Previe of dataset.............................................................\n")
print(frame.head())

#Save to csv-file
print("\n Saving to CSV.............................................................\n")
frame.to_csv('../01_ETLOutput-CSV/01_data.csv')

#The same as plot
print(frame.groupby(['date'])["Confirmed",'Deaths','Recovered'].sum().plot())


#Lets look at the sum of Confirmed, Deaths and Recovered per date
frame_grouped = frame.groupby(['date','country'])["Confirmed",'Deaths','Recovered'].sum()
print(frame_grouped)
frame_grouped.to_csv('../01_ETLOutput-CSV/01-data-grouped.csv')
