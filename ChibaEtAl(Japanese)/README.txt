# Chiba et al. (Japanese)

This directory contains data and analysis scripts associated with Chiba et al.'s Japanese folk-song dataset for the ManyVoices3 project.

## Directory structure

```text
ChibaEtAl(Japanese)
├── !ChibaEtAlMV3.R
├── Confirmatory analysis/
│   ├── data/
│   │   ├── Annotation/
│   │   ├── IOI3++/
│   │   ├── pitch delete zero4+++/
│   │   └── pitch processed4/
│   └── figures/
├── LanguageFamily(Japanese).xlsx
├── plot_acoustic features(chiba).R
├── plot_cohend(chiba).R
├── plot_CollaboratorMap(chiba).R
└── plot_irr(chiba).R
```

## Contents

### Annotation

Praat TextGrid annotation files used for segmentation and extraction of timing information.

### IOI3++

Contains inter-onset interval (IOI) data and MATLAB scripts for effect-size estimation.

Key files:

* `*_IOI.csv`: participant-level IOI measurements
* `effectsize_IOI.m`: effect size analysis
* `pb_effectsize.m`
* `exactCI.m`

### pitch delete zero4+++

Pitch tracks after removal of zero-valued f0 observations.

### pitch processed4

Processed pitch-feature data used for confirmatory analyses.

Key files:

* `*_f0_processed.csv`
* `effectsize_f0.m`
* `effectsize_f0stab.m`
* `pb_effectsize.m`
* `exactCI.m`

### figures

Output figures generated from the analysis scripts.

## Reproducing figures

### Acoustic features

Run:

```r
plot_acoustic features(chiba).R
```

Output:

```text
Confirmatory analysis/figures/combined_plot_acoustic features.png
```

### Effect sizes

Run the MATLAB scripts in:

```text
Confirmatory analysis/data/IOI3++
Confirmatory analysis/data/pitch processed4
```

Then run:

```r
plot_cohend(chiba).R
```

### Collaborator map

Run:

```r
plot_CollaboratorMap(chiba).R
```

### Inter-rater reliability

Run:

```r
plot_irr(chiba).R
```

## Notes

### File paths

Several scripts contain local file paths. Users may need to modify paths according to their local directory structure before execution.

### MATLAB dependencies

Effect-size analyses require MATLAB and the accompanying functions:

* `pb_effectsize.m`
* `exactCI.m`

These functions should remain in the same directory as the analysis scripts.

### Output files

Generated figures are saved to the `Confirmatory analysis/figures/` directory. Existing files with identical names may be overwritten.

## Citation

If you use these data or scripts, please cite the corresponding Chiba et al. publication.
