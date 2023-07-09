# Improving communication of cancer survival statistics

This is documentation related to a special issue on survival, and 
a following article accepted for publication in BJC.

Both use flexible parametric relative survival models to estimate
various survival measures.

## Cancer in Norway 2021. Special issue

**Cancer survival in Norway 1965–2021: Extending standard reporting to improve
communication of survival statistics**

TÅ Myklebust, B Aagnes, Y Nilssen, ALV Johansson, MJ Rutherford, TML Andersson, PC Lambert,
B Møller, PW Dickman. *[Cancer survival in Norway 1965–2021: Extending standard reporting to improve
communication of survival statistics. Oslo: Cancer Registry of Norway, 2022.](https://www.kreftregisteret.no/globalassets/cancer-in-norway/2021/cin2021si_202206072217.pdf)*

Specific questions on details of this Special Issue may be sent to <CIN2021survival@kreftregisteret.no>

## British Journal of Cancer 2023

**Improving communication of cancer survival statistics – Feasibility of implementing model-based algorithms in routine publications**

Accepted for publication in British Journal of Cancer.

*Tor Åge Myklebust, Bjarte Aagnes, Yngvar Nilssen, Mark Rutherford, Paul C Lambert, Therese ML Andersson, Anna LV Johansson, Paul W Dickman, Bjørn Møller
[Improving communication of cancer survival statistics – Feasibility of implementing model-based algorithms in routine publications](TBA)*

Corresponding author: Tor Åge Myklebust <tamy@kreftregisteret.no>
 
## Source code

Source code for the special issue report is available at <https://github.com/CancerRegistryOfNorway/cancer-survival-measures>   

## Example code

The Stata code used in the special issue and BJC article used the Stata program stpm2. 
Below is a small example using [stpm3](https://pclambert.net/software/stpm3/relative_survival_models/). The new program simplify predictions.

:::{dropdown} stpm3 code example
:::{literalinclude} stpm3_code_example.do
:language: stata
:::

## Synthetic data 

The original data are not available due to privacy legislation. Syntethic example data will be added autumn 2023.






