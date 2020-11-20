# beta_suppression

This code uses FieldTrip and non-negative matrix factorization (NMF) to classify iEEG beta-band suppression pre-speech onset from the Mocha dataset collected in the Chang Lab at UCSF. The abstract associated with the work is available [here](https://drive.google.com/file/d/1g8srSLMTZcVEutMiJRKC0VzDy5CpXvXI/view?usp=sharing), with the accompanying figure available [here](https://drive.google.com/file/d/1OZy1C1xQRhmwyYRs56poyB-GGA7vZcAM/view?usp=sharing), upon request.

## Getting Started

This code uses Matlab 2019b and the Bioinformatics Toolbox version 4.13.

## Data

Data collected from the Mocha dataset is available on UCSF Box: [link](https://ucsf.box.com/s/r1u0i2cwdm90f20htki1wnktid0wx2t0).   
You will first need to request access from me. Upload the dataset into the **data** directory to implement this code.

## Analysis + figures

All raw data are cleaned and figures are generated using ```EC118_main.m``` and output in the **plots** directory. You can comment and uncomment the figures you want to run.

## Notes

* To practice your Matlab programming: 
  * Modify the configuration parameters in ```fun_cfg.m```
  * Code your own functions in place of ```fun_trialTimings.m```, ```fun_preprocessing.m```, or ```fun_plotNNMFclusters.m```
* There is a bug in plot 5, this is will be resolved shortly. 

## License
This software is open source and under an MIT license.
