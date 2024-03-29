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

create_entity_tbl <- function(id, ...){
    tbl <- id %>% 
        synapser::synGetChildren() %>% 
        synapser::as.list() %>% 
        purrr::map(as.data.frame) %>% 
        purrr::map(dplyr::as_tibble) %>% 
        purrr::map(dplyr::mutate_if, is.factor, as.character) %>% 
        dplyr::bind_rows()
}

add_annotations_to_tbl <- function(tbl, id_col = "id", ...){
    tbl %>% 
        dplyr::rename(id = id_col) %>% 
        dplyr::mutate(annotations = purrr::map(
            id, 
            create_annotation_tbl, 
            ...
        )) %>% 
        tidyr::unnest("annotations")
}

create_annotation_tbl <- function(id, ...){
    id %>% 
        synapser::synGetAnnotations(...) %>% 
        purrr::flatten() %>% 
        dplyr::as_tibble()
}
