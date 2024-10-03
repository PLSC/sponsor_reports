# load packages
library(medqip.connect)

# point to correct environ
renviron_path <- paste(getwd(), "/.Renviron", sep="")
readRenviron(renviron_path)

# details of table to fetch
SCHEMA = "derived_tables"
TABLE = "simpl2_evaluations"
N = 10

# get the table
response_df = redshift_get_table(SCHEMA, TABLE, n=N)
response_df
