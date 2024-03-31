from PyPDF2 import *
import pandas
import pandas as pd
import numpy as np
#from processing import *
from carcrashprocessing import *

class read_pdf:

    def __init__(self, pdf_data="DeKalb 2013.pdf"):
        self.reader = PdfReader(pdf_data)
        self.num_pages = self.reader.getNumPages()
        self.process = None
        self.complete_myframe = []
        self.extracted_text = None
        self.full_list = []
        self.list_to_process = []
        self.startIndex = []
        self.startWords = ["WEATHER", "TOTALS", "TYPE"]
        self.list_to_send = []


    def updateProcess(self, process):
        """Sets the self.process variable to the list pass through parameter"""
        self.process = process
        self.con = True


    def pdf_read(self):
        """Reads a pdf file"""

        # Iterates through each page in the pdf
        for page_num in range(0, self.num_pages):

            # Stores text extracted from the file to the page variable
            page = (self.reader.pages[page_num]).extractText(Tj_sep=" ", TJ_sep="\n")

            # Splits the text from the page variable into a group of lists and stores it in the extracted_text variable
            self.extracted_text = page.split()
            for num in range(0, len(self.extracted_text)):
                self.full_list.append(self.extracted_text[num])
        for item in range(0, len(self.full_list)):
            if self.full_list[item] in self.startWords:
                self.startIndex.append(item)

        for item2 in range(0, len(self.startIndex)):
            if item2 < len(self.startIndex) - 1:
                process = self.full_list[self.startIndex[item2]: self.startIndex[item2 + 1]]
                for num1 in range(0, len(process)):
                    self.list_to_send.append(process[num1])
            if item2 == len(self.startIndex) - 1:
                process = self.full_list[self.startIndex[item2]:]
                for num1 in range(0, len(process)):
                    self.list_to_send.append(process[num1])

    def getList(self):
        return self.list_to_process

    def create_List(self, process):
        self.list_to_process.append(process)


if __name__ == '__main__':
    crashdata = "DeKalb 2013.pdf"
    # Instantiate read pdf object and pass the transcript
    r = read_pdf(crashdata)
    # Call the pdf read function with r object
    r.pdf_read()
    p = ProcessGrades()
    p.process_classes(r.list_to_send)
    #   # set frame variable to the list called from getFrame function
    frame = p.getFrame()
