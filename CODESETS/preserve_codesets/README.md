# PCORNET CDM codesets for PRESERVE

This repo contains codesets for the PCORNET CDM for the PRESERVE project. We include what PCORNET terms valuesets in our codesets. Please consult the following Confluence page: [PRESERVE codesets](https://reslnpedsnops01.research.chop.edu/confluence/display/PRESERVE/PRESERVE%7Ccodesets) for additional information.

## Condition

Notes on usage:

-   Tables: DIAGNOSIS, CONDITION (?)

-   Join the `concept_code` column and the `pcornet_vocabulary_id` column in the codeset to the `DX` column and `DX_TYPE` column in the DIAGNOSIS table, respectively

Codeset structure:

| concept_id | concept_code | concept_name | vocabulary_id | pcornet_vocabulary_id |
|------------|--------------|--------------|---------------|-----------------------|
|            |              |              |               |                       |

where `pcornet_vocabulary_id` is an acceptable value according to the supported values in the `VALUESET_ITEM` column below:

| FIELD_NAME | VALUESET_ITEM (pcornet_vocabulary_id) | VALUESET_ITEM_DESCRIPTOR |
|------------|---------------------------------------|--------------------------|
| DX_TYPE    | 09                                    | 09=ICD-9-CM              |
| DX_TYPE    | 10                                    | 10=ICD-10-CM             |
| DX_TYPE    | 11                                    | 11=ICD-11-CM             |
| DX_TYPE    | SM                                    | SM=SNOMED CT             |

Codesets and valuesets:

| Name           | Codeset link                                   | Description                                         | Vocabularies                   | SQL link                                             |
|----------------|------------------------------------------------|-----------------------------------------------------|--------------------------------|------------------------------------------------------|
| ckd_stage23_dx | [ckd_stage23_dx](condition/ckd_stage23_dx.csv) | Diagnoses for chronic kidney disease stages 2 and 3 | ICD10, ICD10CM, ICD9CM, SNOMED | [ckd_stage23_dx.sql](sql_queries/ckd_stage23_dx.sql) |
| kidney_transplant_dx | [kidney_transplant_dx](condition/kidney_transplant_dx.csv) | Kidney transplant diagnosis codes | ICD10, ICD10CM, ICD9CM, SNOMED | [kidney_transplant_dx.sql](sql_queries/kidney_transplant_dx.sql) |
| kidney_dialysis_dx | [kidney_dialysis_dx](condition/kidney_dialysis_dx.csv) | Kidney dialysis diagnosis codes | ICD10, ICD10CM, ICD9CM, SNOMED | [kidney_dialysis_dx.sql](sql_queries/kidney_dialysis_dx.sql) |

## Demographic

Notes on usage:

-   Tables: DEMOGRAPHIC

-   Select the FIELD_NAME from the TABLE_NAME specified in the valueset

Codeset structure:

For fields, use the following fields from the PCORNET CDM specifications:

| TABLE_NAME | FIELD_NAME | RDBMS_DATA_TYPE | SAS_DATA_TYPE | DATA_FORMAT | REPLICATED_FIELD | UNIT_OF_MEASURE | VALUESET | FIELD_DEFINITION |
|------------|------------|-----------------|---------------|-------------|------------------|-----------------|----------|------------------|
|            |            |                 |               |             |                  |                 |          |                  |

Codesets and valuesets:

| Name | Codeset link | Description | Vocabularies | SQL link |
|------|--------------|-------------|--------------|----------|
|      |              |             |              |          |

## Drug

Notes on usage:

-   **Tables:** MED_ADMIN (administrations), PRESCRIBING

-   **For administrations:** Join the `concept_code` column and the `pcornet_vocabulary_id` column in the codeset to the `MEDADMIN_CODE` column and `MEDADMIN_TYPE` column in the MED_ADMIN table, respectively

-   **For prescriptions:** Join the `concept_code` column in the codeset to the `RXNORM_CUI` column in the PRESCRIBING table

Codeset structure:

| concept_id | concept_code | concept_name | vocabulary_id | ingredient | pcornet_vocabulary_id |
|------------|--------------|--------------|---------------|------------|-----------------------|
|            |              |              |               |            |                       |

where `pcornet_vocabulary_id` is an acceptable value according to the supported values in the `VALUESET_ITEM` column below:

| FIELD_NAME    | VALUESET_ITEM (pcornet_vocabulary_id) | VALUESET_ITEM_DESCRIPTOR |
|---------------|---------------------------------------|--------------------------|
| MEDADMIN_TYPE | ND                                    | ND=NDC                   |
| MEDADMIN_TYPE | RX                                    | RX=RXNORM                |

Codesets and valuesets:

| Name | Codeset link | Description | Vocabularies | SQL link |
|------|--------------|-------------|--------------|----------|
| ace_inhibitor_rx | [ace_inhibitor_rx](drug/ace_inhibitor_rx.csv) | Medication codeset for the following ingredients: Benazepril, Captopril, Enalapril, Fosinopril, Lisinopril, Moexipril, Periondopril, Quinapril,Ramipril, Trandolapril | NDC, RxNorm, RxNorm Extension | [ace_inhibitor_rx.sql](sql_queries/ace_inhibitor_rx.sql) |
| arb_rx | [arb_rx](drug/arb_rx.csv) | Medication codeset for the following ingredients: Azilsartan, Candesartan,Eprosartan,Irbesartan,Losartan,Olmesartan,Telmisartan,   Valsartan | NDC, RxNorm, RxNorm Extension | [arb_rx.sql](sql_queries/arb_rx.sql) |
| bb_rx | [bb_rx](drug/bb_rx.csv) | Medication codeset for the following ingredients:, Acebutolol, Atenolol, Betaxolol,Bisoprolol, Carteolol, Carvediol, Labetalol, Metoprolol, Nadolol, Nebivolol, Penbutolol, Pindolol, Propanolol, Sotalol, Timolol | NDC, RxNorm, RxNorm Extension | [bb_rx.sql](sql_queries/bb_rx.sql) |
| ccb_rx | [ccb_rx](drug/ccb_rx.csv) | Medication codeset for the following ingredients: Amlodipine, Diltiazem, Felodipine, Isradipine, Nicardipine, Nifedipine, Nisoldipine ,Verapamil | NDC, RxNorm, RxNorm Extension | [ccb_rx.sql](sql_queries/ccb_rx.sql) |
| loop_diuretic_rx | [loop_diuretic_rx](drug/loop_diuretic_rx.csv) | Medication codeset for the following ingredients: Furosemide, Bumetanide, Ethacrynic acid, Torsemide | NDC, RxNorm, RxNorm Extension | [loop_diuretic_rx.sql](sql_queries/loop_diuretic_rx.sql) |
| thiazide_rx | [thiazide_rx](drug/thiazide_rx.csv) | Medication codeset for the following ingredients: Chlorothiazide, Chlorthalidone, Hydrochlorothiazide, Indapamide, Metolazone | NDC, RxNorm, RxNorm Extension | [thiazide_rx.sql](sql_queries/thiazide_rx.sql) |


## Measurement

Notes on usage:

-   **Tables:** LAB_RESULT_CM, OBS_CLIN, VITAL

-   **For fields (e.g. in VITAL)**: select the FIELD_NAME from the TABLE_NAME specified in the valueset

-   **For lab results:** Join the `concept_code` column in the codeset to the `LAB_LOINC` column in the LAB_RESULT_CDM table

Codeset structure:

| concept_id | concept_code | concept_name | vocabulary_id | pcornet_vocabulary_id |
|------------|--------------|--------------|---------------|-----------------------|
|            |              |              |               |                       |

where `pcornet_vocabulary_id` should always be LC for LOINC

For fields, use the following fields from the PCORNET CDM specifications:

|            |            |                 |               |             |                  |                 |          |                  |
|------------|------------|-----------------|---------------|-------------|------------------|-----------------|----------|------------------|
| TABLE_NAME | FIELD_NAME | RDBMS_DATA_TYPE | SAS_DATA_TYPE | DATA_FORMAT | REPLICATED_FIELD | UNIT_OF_MEASURE | VALUESET | FIELD_DEFINITION |

Codesets and valuesets:

| Name                             | Codeset link                                             | Description                   | Vocabularies | SQL link                                                 |
|----------------------------------|----------------------------------------------------------|-------------------------------|--------------|----------------------------------------------------------|
| Height (field)                   | [ht_field](measurement/ht_field.csv)                     | Field of VITAL table          | NA           | NA                                                       |
| Weight (field)                   | [wt_field](measurement/wt_field.csv)                     | Field of VITAL table          | NA           | NA                                                       |
| Original BMI (field)             | [original_bmi_field](measurement/original_bmi_field.csv) | Field of VITAL table          | NA           | NA                                                       |
| Systolic Blood Pressure (field)  | [systolic_field](measurement/systolic_field.csv)         | Field of VITAL table          | NA           | NA                                                       |
| Diastolic Blood Pressure (field) | [diastolic_field](measurement/diastolic_field.csv)       | Field of VITAL table          | NA           | NA                                                       |
| Serum creatinine                 | [serum_creatinine](measurement/serum_creatinine.csv)     | Serum creatinine measurements | LOINC        | [serum_creatinine.sql](sql_queries/serum_creatinine.sql) |
| Serum cystatin | [serum_cystatin](measurement/serum_cystatin.csv) | Serum cystatin measurements | LOINC | [serum_cystatin.sql](sql_queries/serum_cystatin.sql) |
| Urine creatinine | [urine_creatinine](measurement/urine_creatinine.csv) | Urine creatinine measurements | LOINC | [urine_creatinine.sql](sql_queries/urine_creatinine.sql)
| Urine protein (qualitative) | [urine_protein_qual](measurement/urine_protein_qual.csv) | Urine protein qualitative | LOINC | [urine_protein_qual.sql](sql_queries/urine_protein_qual.sql) |
| Urine protein (quantitative) | [urine_protein_quant](measurement/urine_protein_quant.csv) | Urine protein quantitative | LOINC | [urine_protein_quant.sql](sql_queries/urine_protein_quant.sql) |
upcr | [upcr](measurement/upcr.csv) | Urine protein to creatinine ratio | LOINC | [upcr.sql](sql_queries/upcr.sql)

## Procedure

Notes on usage:

-   **Tables:** PROCEDURES

-   Join the `concept_code` column and the `pcornet_vocabulary_id` column in the codeset to the `PX` column and `PX_TYPE` column in the PROCEDURES table, respectively

Codeset structure:

| concept_id | concept_code | concept_name | vocabulary_id | pcornet_vocabulary_id |
|------------|--------------|--------------|---------------|-----------------------|
|            |              |              |               |                       |

where `pcornet_vocabulary_id` is an acceptable value according to supported vocabularies in the `VALUESET_ITEM` column below:

| FIELD_NAME | VALUESET_ITEM (pcornet_vocabulary_id) | VALUESET_ITEM_DESCRIPTOR |
|------------|---------------------------------------|--------------------------|
| PX_TYPE    | 09                                    | 09 = ICD-9-CM            |
| PX_TYPE    | 10                                    | 10 = ICD-10-PCS          |
| PX_TYPE    | 11                                    | 11 = ICD-11-PCS          |
| PX_TYPE    | CH                                    | CH = CPT or HCPCS        |
| PX_TYPE    | LC                                    | LC = LOINC               |
| PX_TYPE    | ND                                    | ND = NDC                 |
| PX_TYPE    | RE                                    | RE = Revenue             |

Codesets and valuesets:

| Name | Codeset link | Description | Vocabularies | SQL link |
|------|--------------|-------------|--------------|----------|
| kidney_transplant_px | [kidney_transplant_px](procedure/kidney_transplant_px.csv) | Kidney transplant procedure codes | CPT4, HCPCS, ICD10PCS, ICD9Proc, SNOMED | [kidney_transplant_px.sql](sql_queries/kidney_transplant_px.sql) |
| kidney_dialysis_px | [kidney_dialysis_px](procedure/kidney_dialysis_px.csv) | Kidney dialysis procedure codes | CPT4, HCPCS, ICD10PCS, ICD9Proc, SNOMED | [kidney_dialysis_px.sql](sql_queries/kidney_dialysis_px.sql) |


## Visit Related

Notes on usage:

-   Tables: ENCOUNTER

-   Join the `VALUESET_ITEM` in the codeset to the field specified in the `FIELD_NAME` column of the codeset in the ENCOUNTER table

Codeset structure:

For valuesets, use the following fields from the PCORNET CDM

| TABLE_NAME | FIELD_NAME | VALUESET_ITEM | VALUESET_ITEM_DESCRIPTOR |
|------------|------------|---------------|--------------------------|
|            |            |               |                          |

Codesets and valuesets:

| Name                  | Codeset link                                               | Description                                | Vocabularies      | SQL link |
|-----------------------|------------------------------------------------------------|--------------------------------------------|-------------------|----------|
| Nephrology provider   | [nephrology_spec_prov](visit/nephrology_spec_prov.csv)     | Nephrology provider                        | PCORNET Value Set |          |
| Cardiology facility   | [cardiology_spec_fac](visit/cardiology_spec_fac.csv)       | Cardiology facility                        | PCORNET Value Set |          |
| Cardiology provider   | [cardiology_spec_prov](visit/cardiology_spec_prov.csv)     | Cardiology provider                        | PCORNET Value Set |          |
| Oncology facility     | [oncology_spec_fac](visit/oncology_spec_fac.csv)           | Oncology facility                          | PCORNET Value Set |          |
| Oncology provider     | [oncology_spec_prov](visit/oncology_spec_prov.csv)         | Oncology provider                          | PCORNET Value Set |          |
| Primary care facility | [primary_care_spec_fac](visit/primary_care_spec_fac.csv)   | Oncology facility                          | PCORNET Value Set |          |
| Primary care provider | [primary_care_spec_prov](visit/primary_care_spec_prov.csv) | Primary care provider                      | PCORNET Value Set |          |
| Urology facility      | [urology_spec_fac](visit/urology_spec_fac.csv)             | Urology facility                           | PCORNET Value Set |          |
| Urology provider      | [urology_spec_prov](visit/urology_spec_prov.csv)           | Urology provider                           | PCORNET Value Set |          |
| Emergency Visits      | [emergency_visits](visit/emergency_visits.csv)             | Emergency and Emergency-\>Inpatient Visits | PCORnet Value Set |          |
| Outpatient Visits     | [outpatient_visits](visit/outpatient_visits.csv)           | Outpatient Visits                          | PCORnet Value Set |          |
| Inpatient Visits      | [inpatient_visits](visit/inpatient_visits.csv)             | Inpatient and Emergency-\>Inpatient Visits | PCORnet Value Set |          |
