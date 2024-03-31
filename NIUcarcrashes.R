library(tidyverse)
library(readxl)
library(readr)

data <- read_csv("~/Downloads/NumberofCrashesbyAgeandSexofOperator_2024-03-05T16_26_40.csv")
data_time <- read_csv("~/Library/CloudStorage/OneDrive-NorthernIllinoisUniversity/Northern Star/carcash_story/ByTimeofDay_2024-03-05T16_26_14.csv")



data[2, 1] <- "5-9"
data[3, 1] <- "10-12"


# slice data from age 0 to 17
group_1 <- data %>%
  slice(1:8) 

# change the values for colum 1 rows 1 to 3
group_1[1,1] <- "1"
group_1[2,1] <- "2"
group_1[3,1] <- "3"

# make the column numeric 
group_1$`Age/Age Group` <- as.numeric(group_1$`Age/Age Group`)

# Make a new table with the new group summed 
group_1 <- group_1 %>%
  summarise(
    Age = "0-17",
    across(-Age/`Age/Age Group`, sum, na.rm = TRUE)
    )

# slice data from age 18 to 24
group_2 <- data %>%
  slice(9:13)

# change value of row 5 column 1 
group_2[5, 1] <- "5"

# make a new table with the new group summed 
group_2 <- group_2 %>%
  summarise(
    Age = "18-24",
    across(-Age/`Age/Age Group`, sum, na.rm = TRUE)
  )

# slice data from age 25 to 80 +, 5 year breaks 
group_3 <- data %>%
  slice(14:25)

# rename first column in group 3 table to Age 
group_3 <- group_3 %>%
  rename(Age = `Age/Age Group`)

# combine the tables 
data_new <- rbind(group_1, group_2, group_3)

# remove the not indexed column 
data_new <- data_new %>%
  select(-c(`Not Indexed`))

# save the table to a data frame 
write.csv(data_new, "age_frame.csv")

  
  
data_gender <- data_new %>%
  summarise(
    across(Male:Female, sum))

write.csv(data_gender, "gender_frame.csv")


# split times into segments between 12 am and 12pm and 1pm and 11pm 
# make a new variable for each segment named early and late
data_time %>% 
  mutate(new_var = case_when(
    `Time of Day` %in% c("12 AM", 
                         "1 AM", 
                         "2 AM",
                         "3 AM",
                         "4 AM",
                         "5 AM",
                         "6 AM",
                         "7 AM",
                         "8 AM",
                         "9 AM",
                         "10 AM",
                         "11 AM",
                         "12 PM") ~ "early",
    `Time of Day` %in% c("1 PM",
                         "2 PM",
                         "3 PM",
                         "4 PM",
                         "5 PM",
                         "6 PM",
                         "7 PM",
                         "8 PM",
                         "9 PM",
                         "10 PM",
                         "11 PM") ~ "late"
  )
  ) %>%
  group_by(new_var) %>%
  summarise(total = sum(Total))



# slice from 1 to 6
time_group1 <- data_time %>%
  slice(1:6)


# remove the letters from the first column 
time_group1$`Time of Day` <- gsub("[[:alpha:]]", "", time_group1$`Time of Day`)
# make first column into numeric
time_group1$`Time of Day` <- as.numeric(time_group1$`Time of Day`)

# Group the times and sum them
time_group1 <- time_group1 %>%
  summarise(Time = "12 AM - 5 AM",
            across(-Time, sum, na.rm = TRUE))


time_group_2 <- data_time %>%
  slice(7:12)


# remove the letters from the first column 
time_group_2$`Time of Day` <- gsub("[[:alpha:]]", "", time_group_2$`Time of Day`)
# make first column into numeric
time_group_2$`Time of Day` <- as.numeric(time_group_2$`Time of Day`)

# Group and sum
time_group_2 <- time_group_2 %>%
  summarise(Time = "6 AM - 11 AM", 
            across(-Time, sum, na.rm = TRUE))


time_group3 <- data_time %>%
  slice(13:18)

time_group3$`Time of Day` <- gsub("[[:alpha:]]", "", time_group3$`Time of Day`)
time_group3$`Time of Day` <- as.numeric(time_group3$`Time of Day`)

# Group and sum
time_group3 <- time_group3 %>%
  summarise(Time = "12 PM - 5 PM", 
            across(-Time, sum, na.rm = TRUE))


time_group4 <- data_time %>%
  slice(19:24)

time_group4$`Time of Day` <- gsub("[[:alpha:]]", "", time_group4$`Time of Day`)
time_group4$`Time of Day` <- as.numeric(time_group4$`Time of Day`)

time_group4 <- time_group4 %>%
  summarise(Time = "6 PM - 11 PM", 
            across(-Time, sum, na.rm = TRUE))


combined_time <- rbind(time_group1, time_group_2, time_group3, time_group4)

combined_time <- combined_time %>%
  select(-`Time of Day`)

write.csv(combined_time, "crashes_bytime.csv")




crashes_2013 <- read_excel("~/Library/CloudStorage/OneDrive-NorthernIllinoisUniversity/crashes_ages.xlsx")


crashes_2013 <- crashes_2013 %>%
  rename(col1 = `this is a line ['Male', '2', '0', '1', '1', '2', '0', '1', '1', '0', '0', '1', '16']`)

# Step 1: Remove 'this is a line'
crashes_2013$col1 <- gsub("this is a line ", "", crashes_2013$col1)

# Step 2: Separate into 12 columns by commas
crashes_2013 <- separate(crashes_2013, col1, into = paste0("col", 1:12), sep = ",", remove = FALSE)

# Step 3: Remove brackets
crashes_2013 <- crashes_2013 %>% mutate(across(everything(), ~ gsub("\\[|\\]", "", .)))

# Step 4: Remove quotation marks
crashes_2013 <- crashes_2013 %>% mutate(across(everything(), ~ gsub("\"", "", .)))

# Step 5: Rename columns
colnames(crashes_2013)[2:12] <- c("Total", "Fatal", "Injury", "Property Damage", "Total Vehicles", 
                          "Total Killed", "Total Injured", "A", "B", "C", "O")

crashes_2013 <- crashes_2013 %>% mutate(across(everything(), ~ gsub("\'", "", .)))


age_values <- c("16", "17", "18", "19", "20", "21", "22-24", "25-29", "30-34", 
                "35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65-69", 
                "70-74", "75-79", "80-84", "85-89", "Unknown")

# Repeat each age value twice and assign to the new column
crashes_2013$Age <- rep(age_values, each = 2)


# Step 2: Add a Gender column
crashes_2013$Gender <- rep(c("Male", "Female"), times = length(age_values))

# Step 3: Pivot to get Male and Female columns
data_wide <- crashes_2013 %>%
  pivot_wider(names_from = col1, values_from = Total)

data_wide$Female <- as.numeric(data_wide$Female)

data_wide$Male <- as.numeric(data_wide$Male)
data_wide$Stated <- as.numeric(data_wide$Stated)


consolidated_data <- data_wide %>%
  group_by(Age) %>%
  summarize(
    Female = sum(Female, na.rm = TRUE),
    Male = sum(Male, na.rm = TRUE),
    Not_Stated = sum(Stated, na.rm = TRUE),
    .groups = 'drop'
  )


consolidated_one <- consolidated_data %>%
  slice(1:2)

consolidated_one <- consolidated_one %>%
  summarise(Age = "0 - 17",
            across(-Age, sum, na.rm = TRUE))


consolidated_two <- consolidated_data %>%
  slice(3:7)

consolidated_two <- consolidated_two %>%
  summarise(Age = "18-24",
            across(-Age, sum, na.rm = TRUE))

consolidated_three <- consolidated_data %>%
  slice(8:21)


consolidated_all <- rbind(consolidated_one, consolidated_two, consolidated_three)


write.csv(consolidated_all, "crashesbyAge_2013.csv")
