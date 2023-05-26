**This is a draft under revision. Do not cite or quote.**

# Purpose
Documentation of code used for generating results underlying the graphs presented in 

TÅ Myklebust, B Aagnes, Y Nilssen, ALV Johansson, MJ Rutherford, TML Andersson, PC Lambert,
B Møller, PW Dickman. [Cancer survival in Norway 1965–2021: Extending standard reporting to improve
communication of survival statistics. Oslo: Cancer Registry of Norway, 2022.](https://www.kreftregisteret.no/globalassets/cancer-in-norway/2021/cin2021si_202206072217.pdf)

Specific questions on details of this Special Issue may be sent to CIN2021survival@kreftregisteret.no

# Description

## Introduction
Cancer in Norway Special Issue 2021 focuses on calculating and presenting a range of different measures that are useful for improving communication of cancer patient survival. This work uses flexible parametric relative survival models, which are estimated for 23 different cancer sites. 

For each cancer site model selection is done by iterating a pre-specified list of models and choosing the first model that converges on the relevant data. Missing data on cancer stage was imputed by multiple imputation.

Measures are then predicted from the chosen models.

For more detailed description of methods see [*Statistical analyses* page S10](https://www.kreftregisteret.no/globalassets/cancer-in-norway/2021/cin2021si_202206072217.pdf) 

## Organisation of project

[master.do](/dofiles/master.do)

### Command files are organised depending on their purpose: 

* data preparation [/dofiles/data_prep](/dofiles/data_prep)
* estimation  [/dofiles/estimation](/dofiles/estimation)
* prediction   [/dofiles/prediction](/dofiles/prediction)

### Result files

[/results](/results)

## Validation
To validate that the code reproduces the results used in CIN Special Issue 2021 we compare result datasets from different runs of code... 

## Dependencies 

* all code dependecies are included in [/ado](/ado)
* dependencies asserts will be added
* real data : cancer data and life-tables must be provied by user
* test data: will be included?

## *Embarrassingly parallel* computing of predictions

The code *split-apply-combine* **on the local machine** by starting one Stata sessions per group. Starting
a new Stata session is restricted to avoid exhausting computer resources (the project was ran on a server with 24 processors and 32G RAM). 

see [parallell_sessions.do](/dofiles/prediction/parallell_sessions.do)

## Reproducability

The original patient data is not available due to privacy legislation.

For identical data the code will reproduce results exactly depending on:
1. Setting the same seed at start of analysis.
1. Sorting order of observations: 
    1. Using stable sort, because sorting is randomized for tied values. Especially, for any *bysort* command *[catvars]* and *(sortvars)* should identify the observations. 
    1. Before *mi impute* the sort order of *observations* must be identical between repeated analysis because the same sequence of random numbers will potentially correspond to different observations during the computation of imputed values. 
1. When using *rcsgen* with the option *orthog* the returned variables must be recast from double to float due to rounding errors. (This reflect the functionallity of the *rcsgen* version 1.5.9 13FEB2022 used in the analysis.)




 