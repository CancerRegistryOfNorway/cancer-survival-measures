# Purpose
Documentation of code used for generating results underlying the graphs presented in 

TÅ Myklebust, B Aagnes, Y Nilssen, ALV Johansson, MJ Rutherford, TML Andersson, PC Lambert,
B Møller, PW Dickman. [Cancer survival in Norway 1965–2021: Extending standard reporting to improve
communication of survival statistics. Oslo: Cancer Registry of Norway, 2022.](https://www.kreftregisteret.no/globalassets/cancer-in-norway/2021/cin2021si_202206072217.pdf)

Specific questions on details of this Special Issue may be sent to CIN2021survival@kreftregisteret.no

# Description

## Introduction
Cancer in Norway Special Issue 2021 focuses on calculating and presenting a range of different measures that are useful for improving communication of cancer patient survival. This work uses flexible parametric relative survival models, which are estimated for 23 different cancer sites. 

For each cancer site model selection is done by iterating down a pre-specified list of models and choosing the first model that converges on the relevant data. 

Measures are then predicted from the chosen models.

For more detailed description of methods see [*Statistical analyses* page S10](https://www.kreftregisteret.no/globalassets/cancer-in-norway/2021/cin2021si_202206072217.pdf) 

## Organisation of project

https://gitlab.kreftregisteret.no/tamy/cancer-survival-measures/-/blob/master/dofiles/master.do

### Command files are organised depending on their purpose: 

* data preparation
* estimation
* prediction


### Result files

https://gitlab.kreftregisteret.no/tamy/cancer-survival-measures/-/tree/master/results


## Validation
To validate that the code reproduces the results used in CIN Special Issue 2021 we compare result datasets from different runs of code... 

## Dependencies 

see https://gitlab.kreftregisteret.no/tamy/cancer-survival-measures/-/tree/master/ado

## [Embarrassingly Parallel](https://en.wikipedia.org/wiki/Embarrassingly_parallel) computing of predictions

The code will split jobs and start as many Stata sessions on the local machine as possible restricted by available system resources

see https://gitlab.kreftregisteret.no/tamy/cancer-survival-measures/-/blob/master/dofiles/prediction/parallell_sessions.do



