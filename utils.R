require(magrittr)

query_synapse_table <- function(query, row_data = F, ...){
    tbl <- query %>% 
        synapser::synTableQuery(includeRowIdAndRowVersion = row_data, ...) %>%
        {.$asDataFrame()} %>% 
        dplyr::as_tibble()
}