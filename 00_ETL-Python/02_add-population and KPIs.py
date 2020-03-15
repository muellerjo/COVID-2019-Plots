#!/usr/bin/env python
# coding: utf-8

# In[2]:


#After the Union of the CSVs, we will add the population of the countries to the completed dataset

#First we load the dataset with the numbers of world population

import pandas as pd
import numpy as np

#Load the CSVs
covid_cases = pd.read_csv ('../01_ETLOutput-CSV/01-data-grouped.csv')
population = pd.read_csv ('../worldpopulation/data.csv')

#------------------------------------------------------------------------------------
#     ADDING DATA OF POPULATION
#------------------------------------------------------------------------------------

#Replace country names, because they er different in the population file
population["name"]= population["name"].replace('China', "Mainland China")
population["name"]= population["name"].replace('United States', "US")


#Merging both data
df = pd.merge(covid_cases, 
                  population[['name', 'pop2020']],
                  left_on='country',
                  right_on='name',
                  how='left')

print("Dataframe of merged Data:")
print(df.head())


#-----------------------------------------------------------------------------------
#Calculate KPIs
print("\n \n \n Calculating KPIs \n")
#-----------------------------------------------------------------------------------

df['PercentOfPopulationConfirmedDecimal'] = (df.Confirmed/(df.pop2020*1000))
df['PercentOfPopulationConfirmed'] = df.PercentOfPopulationConfirmedDecimal*100
#df['confirmed_per_Thousand'] = df.Confirmed/(df.pop2020)

df['MortalityDecimal'] = df.Deaths / (df.Confirmed)
df['MortalityPercent'] = df.MortalityDecimal*100

#df['% Death'] = (df.mortality_percent/(df.pop2020*1000))*100

df['active'] = df.Confirmed - (np.nan_to_num(df.Recovered))
df['PercentOfPopulationActiveDecimal'] = (df.Confirmed - (np.nan_to_num(df.Recovered)))/(df.pop2020*1000)
df['PercentOfPopulationActive'] = df.PercentOfPopulationConfirmedDecimal*100

df['PercentOfPopulationRecoveredDecimal'] = df.Recovered/(df.pop2020*1000)
df['PercentOfPopulationRecovered'] = df.PercentOfPopulationRecoveredDecimal*100

print("\n \n \n Dataframe of merged Data after calculation of KPIs: \n")
print(df.head())


#-----------------------------------------------------------------------------------
#       Save CSV
#-----------------------------------------------------------------------------------


#Save to csv-file
print("\n Saving to CSV.............................................................\n")
df.to_csv('../01_ETLOutput-CSV/02-data-grouped-population.csv')

df.head()


# In[ ]:




