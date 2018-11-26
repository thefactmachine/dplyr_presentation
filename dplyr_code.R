

# ===================================

# clear the decks; load in libaries

rm(list=ls())
library(dplyr)
library(tidyr)
library(broom)
library(tibble)
options(stringsAsFactors = FALSE)



# ===================================
# ===============================================

# Thema der Präsentation
# 80% of Data Science work is data manipulation
# Probably higher proportion.
# dplyr is most downloaded R package....
# dplyr manipulates tabular data....
# therefore, lets learn dplyr...
# dplyr part of tidy verse 
# dplyr Vs data.table
# data.table is faster Vs dplyr has more
# readable syntax as close to SQL....
# dplyr cheet sheet..part of R Studio
# cheet sheets.
# example data set to demonstate
# list of bank customers and their
# accounts (1 to many relationship)
# 1 customer has (typically) many
# accounts. 

# =======================================================
# =======================================================
# create the data.frames: df_account and df_customer
source("create_data_frames.R")
# delete everything except the data.frames...
rm(list = ls()[!ls() %in% c("df_account", "df_customer")])


# save the data to disk
write.csv(df_account, 
          file = "output_data/df_account.csv", 
          row.names = FALSE)

write.csv(df_customer, 
          file = "output_data/df_customer.csv", 
          row.names = FALSE)

# =======================================================
# =======================================================


#001 - Magrittr "." operator

# replace "a" with "*" in the name column
# syntax without magrittr
gsub("a", "*", df_customer$name)


# syntax with magrittr
#(using the "." if not the first argument)
df_customer$name %>% gsub("a", "*", .)


# following are equivalent
paste(df_customer$name, "_suffix")
df_customer$name %>% paste("_suffix")


# ===================================

# 0001a - Magrittr "." Coercion of a
# single column data.frame to
# a vector

df_customer %>% .$name

# ===================================

# 002 - Basic verb & magrittr revision
dplyr::select(df_customer, name, birthdate)

df_customer %>% dplyr::select(birthdate, name) 


# ===================================
# 003 Similar to SQL but order of operations
# is not as restrictive.....

df_customer %>%
  dplyr::select(name, birthdate) %>% 
  arrange(birthdate)


df_customer %>%
  arrange(birthdate) %>%
  dplyr::select(name, birthdate) 



# ===================================

# 004 Adding a column ... mutate
# add an age column (current year = 2018)
# fsort by age in descending order



df_customer %>%
  mutate(age = 2018 - birthdate) %>%
  arrange(desc(age))




# ===================================

# 005 Aggregation (all rows)
df_customer %>%
  summarise(av_birth_date = mean(birthdate))



# ===================================

# 005 Aggregation (by groups)

# first example uses built in function

df_customer %>%
  mutate(age = 2018 - birthdate) %>%
  group_by(gender) %>%
  summarise(av_age = mean(age)) 

# folloiwing is equivalent but

# calculates the mean manually
df_customer %>%
  group_by(gender) %>%
  summarise(count = n(),
  total = sum(2018 - birthdate),
  av_age = total / count) %>%
  arrange(av_age)



# ===================================

# 006 Cooercion to tibble
# some dplyr functions automatically
# cooerce to a tibble.  A tibble is
# almost the same as a data.frame but
# has some better print functions for
# large data sets
# (i.e. only prints first 10 rows)

# to tibble and back to data.frame()

df_customer %>%
  tibble::as_tibble() %>%
  as.data.frame()



# ===================================

# 007 Joining two tables (inner join)
# using a single column

df_customer %>%
  inner_join(df_account, by = c("cust_no" = "cust_num")) 





# ===================================

# 008 Deselecting columns

# all columns except "name" and "birtdate"
df_customer %>% select(-c(name, birthdate)) %>%
  inner_join(df_account, by = c("cust_no" = "cust_num"))

# 009 what customers do not have accounts
df_customer %>% 
  anti_join(df_account, 
            by = c("name" = "name", 
                   "birthdate" = "birthdate"))



# ===================================

# 010 selecting distinct rows
# following two statements are equivalent

df_account %>% distinct(name, birthdate)


df_account %>% select(name, birthdate) %>% distinct() 

# ===================================

# 011 joining with multiple columns
df_customer %>% 
  inner_join(df_account, 
  by = c("name" = "name", "birthdate" = "birthdate" ))



# ===================================

# 012 filtering using expression
# Who are the northern boys?
# following two statements are equivalent

df_customer %>% filter(address == "north" & gender == "m")

df_customer %>% filter(address == "north") %>% filter(gender == "m")

# ===================================

# 013 filtering using vectors
# What is the total balance for:
# cathy, mark & megan



df_account %>%
  filter(name %in% c("cathy", "mark", "megan")) %>%
  summarise(total_balance = sum(balance))


# total for everybody else
df_account %>%
  filter(!name %in% c("cathy", "mark", "megan")) %>%
  summarise(total_balance = sum(balance))



# ===================================

# 013 Slicing operations
# for each customer...what is the account
# with the highest value
# following two are equivalent

# get the highest
df_account %>% 
  group_by(cust_num) %>% 
  arrange(balance) %>% 
  slice(n())


# get the lowest
df_account %>% 
  group_by(cust_num) %>%
  arrange(desc(balance)) %>% 
  slice(1)



# ===================================

# 014 Advanced slicing
# for customers with three or more
# accounts...
# list the smallest and largest highest account
# balances

df_account %>% group_by(cust_num) %>%
  filter(n() >= 3) %>%
  arrange(balance) %>% 
  slice(c(1, n())) 


# ===================================
# 014 Advanced Group Operations
# get all accounts for any customer
# with a loan account

df_account %>% 
  group_by(cust_num) %>%
  filter(any(type == "loan")) %>%
  arrange(cust_num) 

# ===================================
# 015 Renaming columns
df_customer %>% 
  select(name, birthdate) %>%
  rename(new_name = name, new_birthdate = birthdate)



# ===================================
# 016 long to wide using tidyr
library(tidyr)
df_account_wide <- 
  df_account %>%
  mutate(uniq_name = paste0(name, "_", birthdate)) %>%
  select(uniq_name, type, balance) %>%
  tidyr::spread(key = type, value = balance, fill = 0) 
  


df_account_wide

# ===================================

# 017 wide to long using tidyr
# just show first 10 rows at random
# use set.seed to make repeatable

set.seed(123)
df_account_wide %>%
tidyr::gather(key = type,  value = value, -uniq_name) %>%
sample_n(10)


# ***************

# non-standard evaluation .... good for interactive
# use...saves you typing....

# Standard Evaluation ends with "_"
# i.e select_ vs select

# ===================================
# 018 standard evaluation (using .dots)
# 18.a set up some data



# =========================================
# =========================================
# =========================================


# non-standard evaluation .... good for interactive
# use...saves you typing....
# Standard Evaluation ends with "_"
# i.e select_ vs select


# 
df_customer %>% select(name, birthdate)

df_customer %>% select_("name", "birthdate")



lst_names <-  c("name", "birthdate") %>% lapply(as.name)

df_customer %>% select_(.dots = lst_names)

# =========================================================
# =========================================================
# =========================================================

df_data <- df_customer %>%
  select(-c(name, birthdate)) %>%
  inner_join(df_account, by = c("cust_no" = "cust_num"))


# 18.c how to use .dots in a function
fn_demo_dots <- function(...) {
  # use the ellipis argument to create a list
  lst_group_by <- list(...) %>% lapply(as.name)
  
  # now apply this list to group_by_
  df_data %>% group_by_(.dots = lst_group_by) %>%
    summarise(total = sum(balance))
}


# 18.d apply the function
fn_demo_dots("address", "gender") 


# 18.e apply it again.
fn_demo_dots("type")

# ===================================
# ===================================

library(lazyeval)

fn_filter_account <- function(df, str_type) {
  filter_condition <- lazyeval::interp(~x == y, x = as.name("type"), y = str_type)
  df_rtn <- df %>% filter_(filter_condition)
  return(df_rtn)
}

fn_filter_account(df_account, "loan") %>% 
write.csv(file = "output_data/filter_by_loan.csv", row.names = FALSE)


# ===================================
#19 Conditional summarisation...
# apply mean, median to all numeric variables


df_data %>% group_by(type) %>%
  summarise_if(is.numeric, funs(mean,median))
# ===================================

# 20 using do
# what if we want more than 1 row
# back from each group....
# see here:
# http://stat545.com/block023_dplyr-do.html


# 20.a first two rows of each group
df_data %>%
  group_by(type) %>%
  do(head(., 2)) %>%
  write.csv(file = "output_data/do_head.csv", row.names = FALSE)


# fit a linear model to each group
df_models <- df_data %>%
  group_by(type) %>%
  do(mod = lm(balance ~ birthdate, data = .))


# problem is how to extract the results

df_models 


library(broom)
# broom::glance always returns a one row data.frame
models %>% broom::glance(mod)  %>%
  write.csv(file = "output_data/glance_output.csv", row.names = FALSE)
  
# broom::tidy returns multiple rows per group
models %>% broom::tidy(mod)  %>%
  write.csv(file = "output_data/tidy_output.csv", row.names = FALSE)





# ================================================
# ================================================
# ================================================