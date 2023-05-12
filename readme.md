# Purpose
Documentation of code used for generating results underlying the graphs presented in Cancer In Norway Special Issue 2021 (https://www.kreftregisteret.no/globalassets/cancer-in-norway/2021/cin2021si_202206072217.pdf).

# Description

## Introduction
Cancer in Norway Special Issue 2021 focuses on calculating and presenting a range of different measures that are useful for improving communication of cancer patient survival. This work uses flexible parametric relative survival models, which are estimated for 23 different cancer sites. 

For each cancer site model selection is done by iterating down a pre-specified list of models and choosing the first model that converges on the relevant data. 

Measures are then predicted from the chosen models.

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

## Parallel computing of predictions

The code will split jobs and start new Stata sessions if available system resources

see https://gitlab.kreftregisteret.no/tamy/cancer-survival-measures/-/blob/master/dofiles/prediction/parallell_sessions.do



