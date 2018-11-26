# create two data.frames: df_customer and df_account


# =======================================================
# =======================================================
# create df_customer

vct_cust_no_a <- c("0010", "0015", "0020", "0030", 
                   "0040", "0050", "0060", "0070")

vct_names_a <- c("andrew", "andrew", "mark", "ellen", 
                 "cathy", "megan", "colin", "trung")

vct_b_date_a <- c(1980, 1970, 1985, 1990, 1987, 1978, 1992, 1990)

vct_gender <- c("m", "m", "m", "f", "f", "f", "m", "m")

vct_address <- c("north", "south", "north", "south", 
                 "north", "south", "north", "north")

df_customer <- data.frame(cust_no = vct_cust_no_a, name = vct_names_a, 
                          birthdate = vct_b_date_a, gender = vct_gender, 
                          address = vct_address, row.names = NULL)

# =======================================================
# =======================================================

# create df_account
vct_acct_no <- c("A", "B", "C", "D", "E","F", 
                 "G", "H", "I", "J", "K", "L", "M", "N")

vct_cust_no_b <- c("0030", "0040", "0030", "0050", "0060", 
                   "0010", "0060", "0060", "0020", 
                   "0040", "0050", "0020", "0030", "0015")

vct_type <- c("loan", "savings", "savings", "savings", "loan", 
              "loan", "credit_card", "savings", 
              "credit_card", "term_deposit", 
              "loan", "savings", "credit_card", "savings")


vct_balance <- c(400, 80, 200, 400, 90, 200, 
                 120, 40, 50, 200, 300, 300, 50, 20)

vct_name <- c("ellen", "cathy", "ellen", "megan", "colin", 
              "andrew", "colin", "colin", "mark", "cathy", 
              "megan", "mark", "ellen", "andrew")

vct_b_date_b <- c(1990, 1987, 1990, 1978, 1992, 
                  1980, 1992, 1992, 1985, 1987, 
                  1978, 1985, 1990, 1970)

df_account <- data.frame(account_no = vct_acct_no, 
                         cust_num = vct_cust_no_b, 
                         type = vct_type, 
                         balance = vct_balance, 
                         name = vct_name, birthdate = vct_b_date_b, 
                         row.names = NULL)

# =======================================================
# =======================================================
# =======================================================
# =======================================================
