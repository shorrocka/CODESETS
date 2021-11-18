#' This is revised approach to identifying kidney biopsy that has been developed
#' through comparison to chart review data for the MPGN project
#' Currently under development
#' Kidney biopsy is identified through one of the following approaches:
#' 
#' - Procedure code for kidney biopsy
#' - Procedure code associated with biopsy (renal not specified), accompanied by source value string search for kidney/renal/kidney biopsy ICD code or kidney finding condition code on same date
#' - Condition code for kidney biopsy
#' - Condition code for biopsy result (renal not specified), accompanied by kidney finding condition code on same date
#' - String search for kidney/renal biopsy in visit source value
#'
#' @param cohort Cohort for which kidney biopsies should be identified
#' @param kidney_biopsy_proc_codeset Procedure codeset for kidney biopsy
#' @param biopsy_proc_codeset Procedure codeset for biopsy-associated procedures  (renal not specified)
#' @param kidney_biopsy_cond_codeset Condition codeset for kidney biopsy
#' @param kidney_finding_cond_codeset Condition codeset for kidney finding (biopsy not specified)
#' @param biopsy_result_cond_codeset Condition codeset for biopsy result (renal not specified)
#' @param procedure_table Procedure table, defaults to CDM table
#' @param condition_table Condition table, defaults to CDM table
#' @param visit_table Visit table, defaults to CDM table
#'
#' @return Table with person_id, occurrence_id, concept_id, biopsy_date,
#' source_value, table_name and approach for each kidney biopsy identified (note
#' that the same kidney biopsy may be identified through multiple approaches)
#' - occurrence_id, concept_id, and source_value are from table specified in
#' table_name field
#' - approach provides information about approach used to identify kidney biopsy
#'
get_kidney_biopsy <- function(cohort,
                              kidney_biopsy_proc_codeset,
                              biopsy_proc_codeset,
                              kidney_biopsy_cond_codeset,
                              kidney_finding_cond_codeset,
                              biopsy_result_cond_codeset,
                              procedure_table = cdm_tbl("procedure_occurrence"),
                              condition_table = cdm_tbl("condition_occurrence"),
                              visit_table = cdm_tbl("visit_occurrence")) {
  
  cohort <- cohort %>% distinct(person_id)
  
  kidney_biopsy_proc_results <-
    kidney_biopsy_proc(
      cohort = cohort,
      kidney_biopsy_proc_codeset = kidney_biopsy_proc_codeset,
      biopsy_proc_codeset = biopsy_proc_codeset,
      procedure_table = procedure_table
    )
  
  kidney_biopsy_cond_results <-
    kidney_biopsy_cond(
      cohort = cohort,
      kidney_biopsy_cond_codeset = kidney_biopsy_cond_codeset,
      kidney_finding_cond_codeset = kidney_finding_cond_codeset,
      biopsy_result_cond_codeset = biopsy_result_cond_codeset,
      condition_table = condition_table
    )
  
  kidney_biopsy_cond_proc_results <- kidney_biopsy_cond_proc(
    cohort = cohort,
    biopsy_proc_codeset = biopsy_proc_codeset,
    kidney_finding_cond_codeset = kidney_finding_cond_codeset,
    procedure_table = procedure_table,
    condition_table = condition_table
  )
  
  kidney_biopsy_visit_result <- kidney_biopsy_visit(cohort = cohort,
                                                    visit_table = visit_table)
  
  kidney_biopsy_proc_results %>%
    union(kidney_biopsy_cond_results) %>%
    union(kidney_biopsy_cond_proc_results) %>%
    union(kidney_biopsy_visit_result) %>%
    add_site() %>%
    arrange(site, person_id, biopsy_date, table_name)
}

#' Identify kidney biopsy via procedure table and condition table
#' Procedure for biospy-associated procedure accompanied by kidney finding on
#' same date
#'
#' @param cohort Cohort for which kidney biopsies should be identified
#' @param biopsy_proc_codeset Procedure codeset for biopsy-associated procedures  (renal not specified)
#' @param kidney_finding_cond_codeset Condition codeset for kidney finding (biopsy not specified)
#' @param procedure_table Procedure table, defaults to CDM table
#' @param condition_table Condition table, defaults to CDM table
#'
#' @return Table with person_id, occurrence_id, concept_id, concept_name,
#' biopsy_date, source_value, table_name and approach for each identified
#' kidney biopsy
#'
kidney_biopsy_cond_proc <- function(cohort,
                                    biopsy_proc_codeset,
                                    kidney_finding_cond_codeset,
                                    procedure_table,
                                    condition_table) {
  biopsy_proc_codeset_vector <-
    biopsy_proc_codeset %>% select(concept_id) %>% pull()
  kidney_finding_cond_codeset_vector <-
    kidney_finding_cond_codeset %>% select(concept_id) %>% pull()

  kidney_finding_cohort_conds <- condition_table %>%
    filter(
      condition_concept_id %in% kidney_finding_cond_codeset_vector
    ) %>%
    inner_join(cohort, by = "person_id") %>%
    select(
      person_id,
      condition_occurrence_id,
      condition_concept_id,
      condition_concept_name,
      condition_start_date,
      condition_source_value
    ) %>%
    compute_new(name = "kidney_finding_cohort_conds")
  
  biopsy_cohort_procs <- procedure_table %>%
    filter(
      procedure_concept_id %in% biopsy_proc_codeset_vector
    ) %>%
    inner_join(cohort, by = "person_id") %>%
    select(
      person_id,
      procedure_occurrence_id,
      procedure_concept_id,
      procedure_concept_name,
      procedure_date,
      procedure_source_value
    ) %>%
    compute_new(name = "biopsy_cohort_procs")
  
  kidney_biopsy_cond_proc <- kidney_finding_cohort_conds %>%
    inner_join(
      biopsy_cohort_procs,
      by = c("person_id",
             "condition_start_date" = "procedure_date"),
      suffix = c("_kf", "_b")
    ) %>%
    rename(
      occurrence_id = procedure_occurrence_id,
      concept_id = procedure_concept_id,
      concept_name = procedure_concept_name,
      biopsy_date = condition_start_date,
      source_value = procedure_source_value
    ) %>%
    select(person_id,
           occurrence_id,
           concept_id,
           concept_name,
           biopsy_date,
           source_value) %>%
    mutate(table_name = as.character("procedure"),
           approach = as.character("cond_proc")) %>%
    compute_new(name = "kidney_biopsy_cond_proc")
  
}

#' Identify kidney biopsy via procedure table
#' Either procedure code for kidney biopsy or procedure for biospy-associated
#' procedure accompanied by string search for renal/kidney/kidney biopsy ICD code
#' 
#' @param cohort Cohort for which kidney biopsies should be identified
#' @param kidney_biopsy_proc_codeset Procedure codeset for kidney biopsy
#' @param biopsy_proc_codeset Procedure codeset for biopsy-associated procedures  (renal not specified)
#' @param procedure_table Procedure table, defaults to CDM table
#'
#' @return Table with person_id, occurrence_id, concept_id, concept_name,
#' biopsy_date, source_value, table_name and approach for each identified
#' kidney biopsy
#'
kidney_biopsy_proc <- function(cohort,
                               kidney_biopsy_proc_codeset,
                               biopsy_proc_codeset,
                               procedure_table) {
  kidney_biopsy_proc_codeset_vector <-
    kidney_biopsy_proc_codeset %>% select(concept_id) %>% pull()
  biopsy_proc_codeset_vector <-
    biopsy_proc_codeset %>% select(concept_id) %>% pull()

  procedure_table_cohort <- procedure_table%>%
    inner_join(cohort, by = "person_id") %>%
    compute_new(name = "cohort_procs")
  
  kidney_biopsy_cohort_procs <- procedure_table_cohort %>%
    filter(
      procedure_concept_id %in% kidney_biopsy_proc_codeset_vector
    ) %>%
    select(
      person_id,
      procedure_occurrence_id,
      procedure_concept_id,
      procedure_concept_name,
      procedure_date,
      procedure_source_value
    ) %>%
    compute_new(name = "kidney_biopsy_cohort_procs")
  
  biopsy_cohort_procs <- procedure_table_cohort %>%
    filter(
      procedure_concept_id %in% biopsy_proc_codeset_vector
    ) %>%
    filter(
      (!str_detect(tolower(procedure_source_value), "adrenal")) &
        (
          str_detect(tolower(procedure_source_value), "kidney") |
            str_detect(tolower(procedure_source_value), "renal") |
            str_detect(tolower(procedure_source_value), "50200") |
            str_detect(tolower(procedure_source_value), "55.23")
        )
    ) %>%
    select(
      person_id,
      procedure_occurrence_id,
      procedure_concept_id,
      procedure_concept_name,
      procedure_date,
      procedure_source_value
    ) %>%
    compute_new(name = "biopsy_cohort_procs")
  
  kidney_biopsy_cohort_procs %>%
    union(biopsy_cohort_procs) %>%
    rename(
      occurrence_id = procedure_occurrence_id,
      concept_id = procedure_concept_id,
      concept_name = procedure_concept_name,
      biopsy_date = procedure_date,
      source_value = procedure_source_value
    ) %>%
    select(person_id,
           occurrence_id,
           concept_id,
           concept_name,
           biopsy_date,
           source_value) %>%
    mutate(table_name = as.character("procedure"),
           approach = as.character("procedure")) %>% 
    compute_new(name = "kidney_biopsy_proc")
  
}

#' Identify kidney biopsy via condition table
#' Either condition code for kidney biopsy or kidney finding and biopsy result
#' on same date
#'
#' @param cohort Cohort for which kidney biopsies should be identified
#' @param kidney_biopsy_cond_codeset Condition codeset for kidney biopsy
#' @param kidney_finding_cond_codeset Condition codeset for kidney finding (biopsy not specified)
#' @param biopsy_result_cond_codeset Condition codeset for biopsy result (renal not specified)
#' @param condition_table Condition table
#'
#' @return Table with person_id, occurrence_id, concept_id, concept_name,
#' biopsy_date, source_value, table_name and approach for each identified
#' kidney biopsy
#'
kidney_biopsy_cond <- function(cohort,
                               kidney_biopsy_cond_codeset,
                               kidney_finding_cond_codeset,
                               biopsy_result_cond_codeset,
                               condition_table) {
  kidney_biopsy_cond_codeset_vector <-
    kidney_biopsy_cond_codeset %>% select(concept_id) %>% pull()
  kidney_finding_cond_codeset_vector <-
    kidney_finding_cond_codeset %>% select(concept_id) %>% pull()
  biopsy_result_cond_codeset_vector <-
    biopsy_result_cond_codeset %>% select(concept_id) %>% pull()

  condition_table_cohort <- condition_table %>%
    inner_join(cohort, by = "person_id") %>%
    compute_new(name = "cohort_conds")
  
  kidney_biopsy_cohort_conds <- condition_table_cohort %>%
    filter(
      condition_concept_id %in% kidney_biopsy_cond_codeset_vector
    ) %>%
    rename(
      occurrence_id = condition_occurrence_id,
      concept_id = condition_concept_id,
      concept_name = condition_concept_name,
      biopsy_date = condition_start_date,
      source_value = condition_source_value
    ) %>%
    select(person_id,
           occurrence_id,
           concept_id,
           concept_name,
           biopsy_date,
           source_value) %>%
    compute_new(name = "kidney_biopsy_cohort_conds")
  
  kidney_finding_cohort_conds <- condition_table_cohort %>%
    filter(
      condition_concept_id %in% kidney_finding_cond_codeset_vector
    ) %>%
    select(
      person_id,
      condition_occurrence_id,
      condition_concept_id,
      condition_concept_name,
      condition_start_date,
      condition_source_value
    ) %>%
    compute_new(name = "kidney_finding_cohort_conds")
  
  biopsy_result_cohort_conds <- condition_table_cohort %>%
    filter(
      condition_concept_id %in% biopsy_result_cond_codeset_vector
    ) %>%
    select(
      person_id,
      condition_occurrence_id,
      condition_concept_id,
      condition_concept_name,
      condition_start_date,
      condition_source_value
    ) %>%
    compute_new(name = "biopsy_result_cohort_conds")
  
  kidney_finding_cohort_conds %>%
    inner_join(
      biopsy_result_cohort_conds,
      by = c("person_id",
             "condition_start_date"),
      suffix = c("_kf", "_br")
    ) %>%
    rename(
      occurrence_id = condition_occurrence_id_br,
      concept_id = condition_concept_id_br,
      concept_name = condition_concept_name_br,
      biopsy_date = condition_start_date,
      source_value = condition_source_value_br,
    ) %>%
    select(person_id,
           occurrence_id,
           concept_id,
           concept_name,
           biopsy_date,
           source_value) %>%
    union(kidney_biopsy_cohort_conds) %>%
    mutate(table_name = as.character("condition"),
           approach = as.character("condition")) %>% 
    compute_new(name = "kidney_biopsy_cond")
  
}

#' Identify kidney biopsy via string search of visit source values

#' @param cohort Cohort for which kidney biopsies should be identified
#' @param visit_table Visit table
#'
#' @return Table with person_id, occurrence_id, concept_id, concept_name,
#' biopsy_date, source_value, table_name and approach for each identified
#' kidney biopsy
#'
kidney_biopsy_visit <- function(cohort,
                                visit_table) {

  biopsy_cohort_visits <- visit_table %>%
    inner_join(cohort, by = "person_id") %>%
    filter(
      str_detect(tolower(visit_source_value), "biops") &
        (!str_detect(tolower(visit_source_value), "adrenal")) &
        (
          str_detect(tolower(visit_source_value), "kidney") |
            str_detect(tolower(visit_source_value), "renal")
        )
    ) %>%
    rename(
      occurrence_id = visit_occurrence_id,
      concept_id = visit_concept_id,
      concept_name = visit_concept_name,
      biopsy_date = visit_start_date,
      source_value = visit_source_value
    ) %>%
    select(person_id,
           occurrence_id,
           concept_id,
           concept_name,
           biopsy_date,
           source_value) %>%
    mutate(table_name = as.character("visit"),
           approach = as.character("visit"))
  
}

