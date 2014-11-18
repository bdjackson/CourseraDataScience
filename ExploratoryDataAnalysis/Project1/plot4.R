# This file is just a wrapper around the main script. All the work is done in
# MakeSamplePlots.R. This is generally considered good coding practice as it
# allows for easy code maintainability, and code reuse.
#
# This code assumse the data file has been downloaded from the web (see the
# README for instructions).
# 
# In order to create plot4, one can simply call:
#     source('plot4.R')
#
# Please see MakeSamplePlots.R for the functions that actually do work
# ===========================================================================

source('MakeSamplePlots.R')
CreatePlot4()
