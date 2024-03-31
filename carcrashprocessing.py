import pandas
import pandas as pd
from transcript_reader import *
import numpy as np
import re

class ProcessGrades:
    def __init__(self):
        """Constructors for Process Grades object"""

        # Set grades list variable to list passed into object
        self.grades_list = None
        # Create empty list
        self.complete_myframe = []
        # Create variable for cleaned list
        self.cleaned = None
        self.futureList = []
        self.startWords = ["WEATHER", "TOTALS", "TYPE", "CLASS OF CITY", "ROAD SURFACE CONDITION"]
        self.startIndex = []
        self.grades_list_copy = None


    def complete_line_of_lists(self, line_of_list):
        """add line of list to the complete list """

        self.complete_myframe.append(line_of_list)

    def getFrame(self):
        """Returns a complete list"""
        return self.complete_myframe

    def contains_letter_followed_by_number(self, s):
        pattern = r'[a-zA-Z]\d'
        return bool(re.search(pattern, s))

    def process_classes(self, grades_list):

        self.grades_list = grades_list
        self.grades_list_copy = self.grades_list
        index_list = []
        index_list_two = []
        new_list = []
        print(f"this is the crash list {self.grades_list}")

        for item in self.grades_list:
            if "," in item:
                str(item).replace(",", "")
        print(f"this is no commas {self.grades_list}")



        print(f"this is the new list{new_list}")

        def slice_list(input_list):
            # Convert the list to a string
            list_str = ', '.join(map(str, input_list))

            cleaned_list = [s.replace(",", "") for s in input_list]
            print(f"i want to see {cleaned_list}")
            char_index = []
            digit_index = []
            index_list_test = []
            digit_index_test = []
            start_page_index = []
            words_index = []
            numbers = []

            for index in range(len(cleaned_list)):
                if not str(cleaned_list[index]).isnumeric():
                    words_index += [index]

            for index in words_index:
                if index + 1 not in words_index:
                    numbers += [index]
            print(f"this is numbers {numbers}")
            print(f"this is words index{words_index}")
            print(f"this is 38 {cleaned_list[52]}")

            for index in range(len(list_str)):
                for char in list_str[index]:
                    if str(char).isalpha():
                        char_index += [index]
                    if str(char).isnumeric():
                        digit_index += [index]
            print(f"this is char index {char_index}")
            print(f"this is digit index {digit_index}")
            for char in char_index:
                if char + 3 in digit_index:
                    index_list_test.append(char)

            print(f"this is a test {index_list_test}")
            for char in digit_index:
                if char + 3 in char_index:
                    digit_index_test.append(char)

            counter = 0
            while counter < len(numbers):
                if counter < len(numbers) - 1:
                    list_sliced = cleaned_list[numbers[counter]: numbers[counter + 1]]
                    counter += 1
                    print(f"this is a line {list_sliced}")



            # Regular expression patterns
            letter_followed_by_number = r'[a-zA-Z]\d'
            number_followed_by_letter = r'\d[a-zA-Z]'

            # Find the start and end indices for slicing
            start = re.search(letter_followed_by_number, list_str)
            print(f"this is start{start}")
            end = re.search(number_followed_by_letter, list_str)
            print(f"this is end {end}")

            if start and end:
                # Adjust end index to include the entire item
                end_index = end.end()
                while end_index < len(list_str) and list_str[end_index] != ',':
                    end_index += 1

                # Slice the string
                sliced_str = list_str[start.start():end_index]
                # Convert the sliced string back to a list
                sliced_list = sliced_str.split(', ')
                return sliced_list
            else:
                return []
        sliced_data = slice_list(self.grades_list)



