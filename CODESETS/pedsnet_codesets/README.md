# Previously developed PEDSnet codesets for PRESERVE

This repo contains previously-developed PEDSnet codesets which may be used as a starting point for codeset development for the PRESERVE project. Please consult the following Confluence page: [PRESERVE codesets](https://reslnpedsnops01.research.chop.edu/confluence/display/PRESERVE/PRESERVE+codesets) for additional information.

## Condition

-   SNOMED codes will need to be mapped to ICD9 and ICD10

| Codeset name | Description |  Project | Development date (approx) | Level of curation |
|--------------|-------------|---------|---------------------------|-------------------|
[glomerular_disease](condition/glomerular_disease.csv) | Glomerular disease codeset with flags for nephrotic/nephritic syndrome dx codes and dx codes which require special logic in the glomerular disease cohort algorithm | FSGS | 2021-03 | Reviewed by Michelle Denburg | Mapping to ICD9 and ICD10, checks for completeness |
[glean_phenotype](condition/cohort_glean.R) | Updated version of original GLEAN algorithm for identifying a cohort of patients with glomerular disease | FSGS | 2021-03 | | Code review, modifications for PCORnet CDM
[cancer](condition/cana_cancer_dx_iccc.csv) | Malignancy (except basal cell carcinoma, squamous cell carcinoma in situ of the skin, or cervical carcinoma in situ)  | Cana | ? | | Review for updates, modifications for PCORnet CDM
[cough](condition/cough_dx.csv) | Cough | COVID19 | 2020-04 | | Review for updates, modifications for PCORnet CDM
[hypertension](condition/htn_dx.csv) | Hypertension | Lupus | 2021-04 | | Review for updates, modifications for PCORnet CDM
[PMCA](condition/pmca_icd10xwalk.csv) | PMCA | | PMCA | ? | | Review for updates, expand to ICD9?
[alopecia](condition/alopecia_areta.csv) | Alopecia | Alopecia | 2021-02 | Unknown - check with Mitch
[prematurity](condition/premature.csv) | Prematurity dx codes - can be used in combination with gestational age to determine prematurity | Dicerna | 2021-03 | Created by Levon
[asthma](condition/asthma_codes.csv) | Asthma diagnosis list | Asthma Phenotype Project | 2019 | Unknown

## Demographic

| Codeset name | Description |  Project | Development date (approx) | Level of curation |
|--------------|-------------|---------|---------------------------|-------------------|
[gestational_age](demographic/gestational_age.csv) | Gestational age | PRESERVE | 2021-08 | | |
[birth_weight](demographic/birth_weight.csv) | Birth weight | PRESERVE | 2021-08 | | |

## Drug

| Codeset name | Description |  Project | Development date (approx) | Level of curation |
|--------------|-------------|---------|---------------------------|-------------------|
[ace_inhibitors](drug/ace_inhibitors.csv) | ACE inhibitors |MPGN | 2019-11 |  
[arbs](drug/arbs.csv) | Angiotensin Receptor Blockers | MPGN | 2019-11 |  
[ccbs](drug/ccb_codes.csv) | Calcium channel blockers (Includes combos with other anti-hypertension meds. Does not include perhexiline, which is used for angina, as per investigator's review) | HSP | 2020-05 | Created by Levon
[RAAS](drug/raas_codes.csv) | RAAS inhibitors - includes ACE inhibitors, ARBs, and direct renin inhibitors | HSP | 2020-05 | Currently under review
[beta_blockers](drug/beta_blockers.csv) | Beta blockers | HSP | 2021-03 | Created by Levon, reviewed by study team
[thiazides](drug/diuretics_thiazides.csv) | Descendants with an ingredient of hydrochlorothiazide, chlorothiazide, and chlorthalidone | Dicerna | 2021-05 | Created by Levon
[chemo_snippet](drug/chemo_snippet.txt) | SQL snippet used to identify Cancer chemotherapies | Oncology work | 2021 | Developed by Ashley and Charles

## Measurement

| Codeset name | Description |  Project | Development date (approx) | Level of curation |
|--------------|-------------|---------|---------------------------|-------------------|
[height](measurement/height.csv) | Height | CDC Freedman | 2019-09 | | |
[weight](measurement/weight.csv) | Height | CDC Freedman | 2019-09 | | |
[urine_protein_qual](measurement/urine_protein_qual.csv) | Qualitative/semi-quantitative urine protein measurements | GLEAN | 2020-08 | | |
[urine_protein_quant](measurement/urine_protein_qual.csv) | Quantitative urine protein measurements | GLEAN | 2020-08 | | |
[urine_creatinine](measurement/urine_creatinine.csv) | Urine creatinine measurements | GLEAN | 2020-08 | | |
[upcr](measurement/upcr.csv) | Directly-reported urine protein to creatinine ratios | GLEAN | 2020-08 | | |
[bp_systolic](measurement/bp_systolic.csv) | Systolic BP measurements from BP function | HSP | 2021 | | |
[bp_diastolic](measurement/bp_diastolic.csv) | Diastolic BP measurements from BP function | HSP | 2021 | | |
[serum_creatinine](measurement/serum_creatinine.csv) | Serum creatinine measurements | MPGN | 2019-11 | | |
[urine_blood](measurement/urine_blood_codeset.csv) | Urine blood measurements | HSP | 2021 | | |

## Procedure

| Codeset name | Description |  Project | Development date (approx) | Level of curation |
|--------------|-------------|---------|---------------------------|-------------------|
[dialysis](procedure/dialysis.csv) | Kidney dialysis | MPGN/HSP | 2020-05 | | Decide on approach for dialysis
[dialysis_bayer](procedure/dialysis_bayer.csv) | Kidney dialysis: Codes which captured non-kidney dialysis catheterization removed | Bayer | 2020-04  | | Decide on approach for dialysis
[dialysis_broad](procedure/dialysis_broad.csv) | Broad kidney dialysis. Flag for chronic. For chronic dialysis: 1 chronic dialysis code or 2 non-chronic dialysis codes separated by 90 days.| GLEAN | 2020-07 |   | Decide on approach for dialysis
[dialysis_narrow](procedure/dialysis_narrow.csv) | Narrow kidney dialysis. Flag for chronic. For chronic dialysis: 1 chronic dialysis code or 2 non-chronic dialysis codes separated by 90 days. | GLEAN | 2020-07 |  | Decide on approach for dialysis
[kidney_transplant](procedure/kidney_transplant.csv) | Kidney transplant | MPGN | 2019-11 | | Decide on approach for transplant
[kidney_transplant_broad](procedure/kidney_transplant_broad.csv) | Kidney transplant, containing both condition and procedure codes | HSP/FSGS | 2021-03 | | Decide on approach for transplant
[kidney_transplant_function](procedure/cohort_kidney_transplant.csv) | function for kidney transplant, using both condition and procedure codes | HSP/FSGS | 2021-03 | | Decide on approach for transplant
[kidney_biopsy](procedure/kidney_biopsy.csv) | Kidney biopsy. If `sv_search_req` = 1, code must be accompanied by string "renal" or "kidney" in `procedure_source_value`. | Bayer | 2020-04 | 

### Broad approach to kidney biopsy

<details>
  <summary>Click to expand!</summary>
This method for identifying kidney biopsy that has been developed through comparison to chart review data for the MPGN project. This approach is broad (i.e. sensitivity maximized with potential costs to specificity). Further revisions will be made to refine the approach (increase specificity without losing sensitivity).

As this method for identifying kidney biopsy includes procedures, conditions, and visits it is organized in a separate directory [kidney_biopsy]. Kidney biopsy is identified through one of the following approaches:

* Procedure code for kidney biopsy
* Procedure code associated with biopsy (renal not specified), accompanied by source value string search for kidney/renal/kidney biopsy ICD code or kidney finding condition code on same date
* Condition code for kidney biopsy
* Condition code for biopsy result (renal not specified), accompanied by kidney finding condition code on same date
* String search for kidney/renal biopsy in visit source value

Note that the same biopsy can be identified through multiple paths, so it is necessary to count the distinct patients or counts within a specified period of time (e.g. year).

| Codeset name | Description |  Project | Development date (approx) | Level of curation |
|--------------|-------------|---------|---------------------------|-------------------|
[kidney_biopsy.R](procedure/kidney_biopsy/kidney_biopsy.R) | Function for current combined approach to kidney biopsy | MPGN | 2020-05 |  |
[kidney_biopsy_proc](procedure/kidney_biopsy/kidney_biopsy_proc.csv) | Procedure codeset for kidney biopsy | MPGN | 2020-05 |  |
[biopsy_proc](procedure/kidney_biopsy/biopsy_proc.csv) | Procedure codeset for biopsy-associated procedures (renal not specified) | MPGN | 2020-05 |  |
[kidney_biopsy_cond](procedure/kidney_biopsy/kidney_biopsy_cond.csv) | Condition codeset for kidney biopsy | MPGN | 2020-05 |  |
[kidney_finding_cond](procedure/kidney_biopsy/kidney_finding_cond.csv) | Condition codeset for kidney finding (biopsy not specified) | MPGN | 2020-05 |  |
[biopsy_result_cond](procedure/kidney_biopsy/biopsy_result_cond.csv) | Condition codeset for biopsy result (renal not specified) | MPGN | 2020-05 ||
</details>

## Visit Related

| Codeset name | Description |  Project | Development date (approx) | Level of curation |
|--------------|-------------|---------|---------------------------|-------------------|
[nephrology](visit_related/nephrology.csv) | Nephrology care_site or provider specialty | Lupus | 2020-03 | |
[in_person](visit_related/in_person.csv) | Inpatient, outpatient (excl. non-physician), emergency visits | NA | 2021-03 | | 
[in_person_exp](visit_related/in_person_exp.csv) | Inpatient, outpatient, emergency, telehealth, observation visits (PEDSnet inclusion criteria for in-person) | NA | 2021-03 | | 
[cardiology](visit_related/cardiology.csv) | Cardiology specialty codes | Dicerna | 2021-02 | |
[urology](visit_related/urology.csv) | Urology specialty codes | Dicerna | 2021-02 | |



