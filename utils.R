require(magrittr)

query_synapse_table <- function(query, row_data = F, ...){
    tbl <- query %>% 
        synapser::synTableQuery(includeRowIdAndRowVersion = row_data, ...) %>%
        {.$asDataFrame()} %>% 
        dplyr::as_tibble()
}

synapse_file_to_tbl <- function(id, delim = "\t", ...){
    tbl <- id %>% 
        synapser::synGet() %>%
        magrittr::use_series(path) %>%
        readr::read_delim(delim, ...)
}