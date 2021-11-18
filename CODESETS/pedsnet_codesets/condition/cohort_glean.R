#' Identify glomerular disease cohort
#' 
#' Identify glomerular disease cohort
#' 2 broad pathways into the cohort:
#' -- 2 or more glomerular inclusion diagnoses on different dates
#' -- 1 or more glomerular inclusion diagnosis AND 1 or more kidney biopsy which is not post-transplant
#' 2 glomerular inclusion diagnosis groups had special requirements:
#' -- "other_code_req" inclusion diagnoses alone are not sufficient for a patient to meet the computational phenotype:
#' these codes are only included if they have 1 or more other glomerular inclusion diagnoses
#' (i.e. NOT from "other_code_req" list) on a different date or if they have 1 or more kidney biopsy which is not post-transplant
#' -- "neph_req" diagnoses are only included for the algorithm if associated with a nephrology visit
#'
#' @param condition_tbl Condition table
#' @param procedure_tbl Procedure table
#' @param provider_tbl Provider table
#' @param care_site_tbl Care site table
#' @param visit_tbl Visit table
#' @param age_ub_years Age upper bound
#' @param min_date_cutoff Date before which visits are excluded
#' @param max_date_cutoff Date after which visits are excluded
#' @param kidney_transplant_proc_codeset Kidney transplant procedure codeset
#' @param kidney_biopsy_proc_codeset Kidney biopsy procedure codeset
#' @param biopsy_proc_codeset Biopsy procedure codeset
#' @param glomerular_disease_codeset Glomerular disease codeset
#' @param other_code_req_vctr Vector of codes for which another more specific 
#' code is required
#' @param neph_req_vctr Vector of codes for which the diagnosis must be associated
#' with a nephrology specialty visit
#' @param problem_list_vctr Vector of problem list codes (not currently used)
#' @param nephrology_spec_codeset Nephrology specialty codeset
#' 
get_glean_cohort <- function(condition_tbl = cdm_tbl("condition_occurrence"),
                             procedure_tbl = cdm_tbl("procedure_occurrence"),
                             provider_tbl = cdm_tbl("provider"),
                             care_site_tbl = cdm_tbl("care_site"),
                             visit_tbl = cdm_tbl("visit_occurrence"),
                             age_ub_years = 30L,
                             min_date_cutoff = as.Date("2009-01-01"),
                             max_date_cutoff = as.Date("2021-01-01"),
                             kidney_transplant_proc_codeset,
                             kidney_biopsy_proc_codeset,
                             biopsy_proc_codeset,
                             glomerular_disease_codeset,
                             other_code_req_vctr = c(261071),
                             neph_req_vctr = c(435308, 259070),
                             problem_list_vctr = c(38000245, 2000000089, 2000000090, 2000000091),
                             nephrology_spec_codeset) {
  
  # create vctr for glomerular disease codeset
  glomerular_disease_vctr <- glomerular_disease_codeset %>% 
    select(concept_id) %>% 
    pull()
  
  # get all glomerular disease conditions prior to age 30
  glomerular_disease_conds_raw <- condition_tbl %>%
    filter(
      condition_concept_id %in% glomerular_disease_vctr,
      condition_start_age_in_months < age_ub_years * 12,
      condition_start_date >= min_date_cutoff,
      condition_start_date <= max_date_cutoff
    ) %>%
    compute_new(name = "glomerular_disease_conds")
  
  # get all glomerular disease conditions, with exception of codes which require a nephrology visit
  non_neph_req_glomerular_disease_conds <- glomerular_disease_conds_raw %>%
    filter(!condition_concept_id %in% neph_req_vctr) %>% 
    compute_new(name = "non_neph_req_glomerular_disease_conds")
  
  # get conditions with nephrology care_site or provider for associated visit_occurrence_id
  nephrology_provider_visits <- visit_tbl %>%
    inner_join(
      select(
        glomerular_disease_conds_raw,
        visit_occurrence_id
      ),
      by = "visit_occurrence_id"
    ) %>%
    get_spec_cdm_tbl(
      cdm_tbl = .,
      provider_tbl = provider_tbl,
      care_site_tbl = care_site_tbl,
      spec_codeset = nephrology_spec_codeset
    ) %>%
    distinct(visit_occurrence_id) %>%
    compute_new(name = "nephrology_provider_visits")
  
  # get table of conditions with nephrology specialty for codes which require a nephrology visit
  neph_req_conds <- glomerular_disease_conds_raw %>%
    filter(condition_concept_id %in% neph_req_vctr) %>%
    inner_join(nephrology_provider_visits, by = "visit_occurrence_id") %>%
    compute_new(name = "neph_req_conds")
  
  # combine all glomerular disease conditions for codes which don't require nephrology specialty
  # and those with nephrology specialty, for those that do require nephrology specialty
  glomerular_disease_conds <- non_neph_req_glomerular_disease_conds %>%
    dplyr::union(neph_req_conds) %>%
    mutate(problem_list = condition_type_concept_id %in% problem_list_vctr) %>% 
    compute_new(name = "glomerular_disease_conds")
  
  # restrict to patients who have 2 or more glomerular disease codes on different days of service
  glean_two_codes <- glomerular_disease_conds %>%
    group_by(person_id, site) %>%
    summarize(n_glomerular_dx_dates = n_distinct(condition_start_date),
              n_glomerular_dx = n_distinct(condition_occurrence_id),
              n_distinct_glomerular_dx = n_distinct(condition_concept_id)) %>%
    ungroup() %>%
    filter(n_glomerular_dx_dates >= 2) %>%
    mutate(entry = "two_codes") %>%
    distinct(person_id, site, entry, n_glomerular_dx,
             n_distinct_glomerular_dx, n_glomerular_dx_dates) %>%
    compute_new(name = "glean_two_codes")
  
  # get patients 1 or more glomerular inclusion diagnosis
  glean_one_code <- glomerular_disease_conds %>%
    group_by(person_id, site) %>%
    summarize(n_glomerular_dx_dates = n_distinct(condition_start_date),
              n_glomerular_dx = n_distinct(condition_occurrence_id),
              n_distinct_glomerular_dx = n_distinct(condition_concept_id)) %>%
    ungroup() %>%
    filter(n_glomerular_dx_dates >= 1) %>%
    distinct(person_id, site, n_glomerular_dx,
             n_distinct_glomerular_dx, n_glomerular_dx_dates) %>%
    compute_new(name = "glean_one_code")
  
  # get patients 1 or more glomerular inclusion diagnosis and kidney
  # biopsy which is not post-transplant
  glean_one_code_w_biopsy <-
    get_kidney_biopsy_not_pt(
      cohort = glean_one_code,
      procedure_tbl = procedure_tbl,
      kidney_transplant_proc_codeset = kidney_transplant_proc_codeset,
      kidney_biopsy_proc_codeset = kidney_biopsy_proc_codeset,
      biopsy_proc_codeset = biopsy_proc_codeset,
      age_ub_years = age_ub_years
    ) %>%
    filter(min_biopsy_date >= min_date_cutoff,
           min_biopsy_date <= max_date_cutoff) %>%
    mutate(entry = "one_code_w_biopsy") %>%
    distinct(person_id, site, entry, n_glomerular_dx_dates) %>%
    compute_new(name = "glean_one_code_w_biopsy")
  
  # get patients who only have codes which require the presence of another more specific code
  other_code_req_two_codes <- glomerular_disease_conds %>%
    filter(condition_concept_id %in% other_code_req_vctr) %>%
    group_by(person_id, site) %>%
    summarize(n_other_code_req_dx_dates = n_distinct(condition_start_date),
              n_other_code_req_dx = n_distinct(condition_occurrence_id),
              n_distinct_other_code_req_dx = n_distinct(condition_concept_id)) %>%
    ungroup() %>%
    inner_join(glean_two_codes, by = "person_id") %>%
    filter(n_distinct_other_code_req_dx == n_distinct_glomerular_dx) %>%
    compute_new(name = "other_code_req_two_codes")
  
  # get patients who meet criteria via two codes
  glean_patients_two_codes <- glean_two_codes %>%
    anti_join(other_code_req_two_codes, by = "person_id") %>%
    compute_new(name = "glean_patients_two_codes")
  
  # get patients who meet criteria via biopsy
  glean_patients_one_code_w_biopsy <- glean_one_code_w_biopsy %>% 
    anti_join(glean_patients_two_codes, by = "person_id")
  
  # get final glomerular disease codeset
  glean_patients <- glean_patients_two_codes %>%
    dplyr::union(glean_patients_one_code_w_biopsy) %>%
    compute_new(name = "glean_patients")
  
}

#' Get kidney transplants which are not post-transplant
#'
#' @param cohort Cohort
#' @param procedure_tbl Procedure CDM table
#' @param kidney_transplant_proc_codeset Kidney transplant procedure codeset
#' @param kidney_biopsy_proc_codeset Kidney biopsy procedure codeset
#' @param biopsy_proc_codeset Biopsy procedure codeset
#' @param age_ub_years Age upper bound
#'
#'
get_kidney_biopsy_not_pt <-
  function(cohort,
           procedure_tbl = cdm_tbl("procedure_occurrence"),
           kidney_transplant_proc_codeset,
           kidney_biopsy_proc_codeset,
           biopsy_proc_codeset,
           age_ub_years) {
    
    # get earliest kidney transplant before age 30
    glean_transplant <-
      get_procedures(
        provided_cohort = cohort,
        procedure_codeset = kidney_transplant_proc_codeset,
        procedure_tbl = procedure_tbl
      ) %>%
      filter(procedure_age_in_months < 12 * age_ub_years) %>%
      group_by(person_id) %>%
      summarize(min_transplant_date = min(procedure_date, na.rm = TRUE)) %>%
      ungroup() %>%
      compute_new(name = "glean_transplant")
    
    # get earliest kidney biopsy before age 30
    glean_biopsy <- kidney_biopsy_proc(
      cohort = cohort,
      kidney_biopsy_proc_codeset = kidney_biopsy_proc_codeset,
      biopsy_proc_codeset = biopsy_proc_codeset,
      procedure_tbl = procedure_tbl %>%
        filter(procedure_age_in_months < 12 * age_ub_years)
    ) %>%
      group_by(person_id) %>%
      summarize(min_biopsy_date = min(biopsy_date, na.rm = TRUE)) %>%
      ungroup() %>%
      compute_new(name = "glean_biopsy")
    
    # patients with one glomerular disease code and a kidney biopsy which is not
    # post-transplant
    glean_one_code_w_biopsy <- cohort %>%
      inner_join(glean_biopsy, by = "person_id") %>%
      left_join(glean_transplant, by = "person_id") %>%
      filter(is.na(min_transplant_date) |
               min_biopsy_date < min_transplant_date)
  }

#' Identify kidney biopsy via procedure table
#' Either procedure code for kidney biopsy or procedure for biospy-associated
#' procedure accompanied by string search for renal/kidney/kidney biopsy code
#' 
#' @param cohort Cohort for which kidney biopsies should be identified
#' @param kidney_biopsy_proc_codeset Procedure codeset for kidney biopsy
#' @param biopsy_proc_codeset Procedure codeset for biopsy-associated procedures  (renal not specified)
#' @param procedure_tbl Procedure table, defaults to CDM table
#'
#' @return Table with person_id, occurrence_id, concept_id, concept_name,
#' biopsy_date, source_value, table_name and approach for each identified
#' kidney biopsy
#'
kidney_biopsy_proc <- function(cohort,
                               kidney_biopsy_proc_codeset,
                               biopsy_proc_codeset,
                               procedure_tbl) {
  kidney_biopsy_proc_codeset_vector <-
    kidney_biopsy_proc_codeset %>% select(concept_id) %>% pull()
  biopsy_proc_codeset_vector <-
    biopsy_proc_codeset %>% select(concept_id) %>% pull()

  kidney_biopsy_cohort_procs <- procedure_tbl %>%
    filter(
      procedure_concept_id %in% kidney_biopsy_proc_codeset_vector
    ) %>%
    inner_join(distinct(cohort, person_id), by = "person_id") %>% 
    select(
      person_id,
      procedure_occurrence_id,
      procedure_concept_id,
      procedure_concept_name,
      procedure_date,
      procedure_source_value
    ) %>%
    compute_new(name = "kidney_biopsy_cohort_procs")
  
  biopsy_cohort_procs <- procedure_tbl %>%
    filter(
      procedure_concept_id %in% biopsy_proc_codeset_vector
    ) %>%
    inner_join(distinct(cohort, person_id), by = "person_id") %>%
    mutate(psv_lower = tolower(procedure_source_value)) %>% 
    filter(
      (!str_detect(psv_lower, "adrenal")) &
        (
          str_detect(psv_lower, "kidney") |
            str_detect(psv_lower, "renal") |
            str_detect(psv_lower, "50200") |
            str_detect(psv_lower, "50205") |
            str_detect(psv_lower, "55.23") |
            str_detect(psv_lower, "55.24")
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