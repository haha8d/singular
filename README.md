# SINGULAR

Single-cell RNA-seq Investigation of Rejuvenation Agents and Longevity - A cell rejuvenation atlas providing unified systems biology analysis of diverse rejuvenation strategies across multiple organs at single-cell resolution.

## The Project

Current rejuvenation strategies, which range from calorie restriction to in vivo partial reprogramming, only improve a few specific cellular processes. In addition, the molecular mechanisms underlying these approaches are largely unknown, which hinders the design of more holistic cellular rejuvenation strategies. To address this issue, we developed SINGULAR, a cell rejuvenation atlas that provides a unified systems biology analysis of diverse rejuvenation strategies across multiple organs at single-cell resolution. In particular, we leverage network biology approaches to characterize and compare the effects of each strategy at the level of intracellular signaling, cell-cell communication, and transcriptional regulation. As a result, we identified master regulators orchestrating the rejuvenation response and propose that targeting a combination of them leads to a more holistic improvement of dysregulated cellular processes.

<p align = "center">
  <img src="https://raw.githubusercontent.com/MohmedSoudy/datasharing/master/imgpsh-fullsize-anim.png" width="900px" height="600px"">
</p>

## Getting Started

To install and run the app, follow these steps:

### 1. Install R

Download and install R from [https://www.r-project.org/](https://www.r-project.org/)

### 2. Clone the repository

```bash
git clone https://github.com/haha8d/singular.git
cd singular
```

### 3. Install required R packages

Run the package installation script:

```r
source("install_packages.R")
```

This script will:
- Automatically set up a user library directory (avoiding permission issues)
- Use the Tsinghua University mirror for faster downloads in China
- Install all required packages:
  - CRAN packages: shiny, shinydashboard, dashboardthemes, shinycustomloader, shinyalert, shinyjs, ggplot2, ggpubr, DT, visNetwork, htmlwidgets, plyr
  - Bioconductor packages: circlize, ComplexHeatmap

### 4. Run the application

```r
source("app.R")
```

### Verify Package Installation

You can verify all packages are installed correctly by running:

```r
source("check_packages.R")
```

## The Team

**Principal Investigator: Prof. Dr. Antonio del Sol Mesa**
Computational Biology, Luxembourg Centre for Systems Biomedicine, University of Luxembourg
Email: antonio.delsol@uni.lu

**Sascha Jung, Ph.D.**
Computational Biology Lab, Bizkaia Science and Technology Park, building 801A, Derio (Bizkaia)
Email: sjung@cicbiogune.es

**Javier Arcos Hodar**
Computational Biology Lab, Bizkaia Science and Technology Park, building 801A, Derio (Bizkaia)
Email: jarcos@cicbiogune.es

**Sybille BARVAUX**
Computational Biology, Luxembourg Centre for Systems Biomedicine, University of Luxembourg
Email: sybille.barvaux@uni.lu

**Mohamed Soudy**
Computational Biology, Luxembourg Centre for Systems Biomedicine, University of Luxembourg
Email: mohamed.soudy@uni.lu

## Citations

- Ma, S. et al. Caloric Restriction Reprograms the Single-Cell Transcriptional Landscape of Rattus Norvegicus Aging. Cell 180, 984-1001.e22 (2020).
- Ma, S. et al. Heterochronic parabiosis induces stem cell revitalization and systemic rejuvenation across aged tissues. Cell Stem Cell 29, 990-1005.e10 (2022).
- Sun, S. et al. A single-cell transcriptomic atlas of exercise-induced anti-inflammatory and geroprotective effects across the body. The Innovation 4, 100380 (2023).
- Ximerakis, M. et al. Heterochronic parabiosis reprograms the mouse brain transcriptome by shifting aging signatures in multiple cell types. Nat Aging 3, 327–345 (2023).
- Roux, A. E. et al. Diverse partial reprogramming strategies restore youthful gene expression and transiently suppress cell identity. Cell Systems 13, 574-587.e11 (2022).
- Hishida, T. et al. In vivo partial cellular reprogramming enhances liver plasticity and regeneration. Cell Reports 39, 110730 (2022).
- Pálovics, R. et al. Molecular hallmarks of heterochronic parabiosis at single-cell resolution. Nature 603, 309–314 (2022).
- Dharmaratne, M., Kulkarni, A. S., Taherian Fard, A. & Mar, J. C. scShapes: a statistical framework for identifying distribution shapes in single-cell RNA-sequencing data. GigaScience 12, giac126 (2022).
- Choi, J. et al. Intestinal stem cell aging at single‐cell resolution: Transcriptional perturbations alter cell developmental trajectory reversed by gerotherapeutics. Aging Cell 22, e13802 (2023).

## Source Repository

This is a mirror of the original project hosted at:
https://gitlab.com/uniluxembourg/lcsb/cbg/singular/

## License

This project is based on original work by the Computational Biology team at Luxembourg Centre for Systems Biomedicine.
