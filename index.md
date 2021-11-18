## Welcome to PRESERVE

This will be a space where codesets can live to reduce the redundancy of defining new codesets for new studies

Codeset Name  | Description | Github Link
-----------------------------------------
Kidney Disease | Any kidney issues that would require dialysis | LINK


### Markdown

Markdown is a lightweight and easy-to-use syntax for styling your writing. It includes conventions for

```markdown
Syntax highlighted code block

# Header 1
## Header 2
### Header 3

- Bulleted
- List

1. Numbered
2. List

**Bold** and _Italic_ and `Code` text

[Link](url) and ![Image](src)
```

For more details see [GitHub Flavored Markdown](https://guides.github.com/features/mastering-markdown/).

# Previously developed PEDSnet codesets for PRESERVE

This repo contains previously-developed PEDSnet codesets which may be used as a starting point for codeset development for the PRESERVE project.

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
