import logging
import os
from netCDF4 import Dataset
import glob


# This is a helper iterator class that iterates over the data in a netCDF file.
class NetCDFItr:
    def __init__(self, dataDir, startMonth, startYear, endMonth, endYear):
        self.dataDir = dataDir
        self.startMonth = startMonth
        self.startYear = startYear
        self.endMonth = endMonth
        self.endYear = endYear
        # These are the iterator variables, with the year switching
        # when we need to open a new file
        self.curMonth = startMonth
        self.curYear = startYear
        self.curInputFile = None

    def __next__(self):
        if (
            self.curYear == self.endYear and self.curMonth > self.endMonth
        ) or self.curYear > self.endYear:
            # This data point would be outside our set, stop iterating
            raise StopIteration
        if self.curMonth == 12:
            # Move to a new year, open a new netCDF file
            self.curMonth = 1  # Reset the month to January
            self.curYear += 1
            # A curInputFile of None indicates we need to find a new input
            self.curInputFile = None
        if self.curInputFile is None:
            fileList = glob.glob(f"{self.dataDir}/*{self.curYear}.spec")
            if len(fileList) > 1:
                logging.error(
                    f"While reading data from {self.dataDir}, multiple files matched the required year {self.curYear}: {' '.join(fileList)}"
                )
            if len(fileList) < 1:
                logging.error(
                    f"While reading data from {self.dataDir}, no files matched the required year {self.curYear}"
                )

            self.curInputFile = Dataset(fileList[0], "r")
