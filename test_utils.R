library(testthat)
source("utils.R")
context("utils.R")

PROJECT_ID <- "syn20555514"
FOLDER1_ID <- "syn20555515" 

synapser::synLogin()

test_that("query_synapse_table", {
    res1 <- query_synapse_table("select * from syn20555521")
    res2 <- query_synapse_table("select * from syn20555521", row_data = T)
    expect_true(tibble::is_tibble(res1))
    expect_true(tibble::is_tibble(res2))
    expect_false(any(
        c("ROW_ID", "ROW_VERSION", "ROW_ETAG") %in% colnames(res1)
    ))
    expect_true(all(
        c("ROW_ID", "ROW_VERSION", "ROW_ETAG") %in% colnames(res2)
    ))
})

test_that("synapse_file_to_tbl", {
    res1 <- synapse_file_to_tbl("syn20555525")
    res2 <- synapse_file_to_tbl("syn20555519", delim = ",")
    expect_true(tibble::is_tibble(res1))
    expect_true(tibble::is_tibble(res2))
})