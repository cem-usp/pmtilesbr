# PMTilesBR <a href = "https://github.com/cem-usp/pmtilesbr"><img src = "images/logo.svg" align="right" width="120" /></a>

<!-- badges: start -->
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![DOI Badge](https://img.shields.io/badge/doi-10.5281/zenodo.19157888-1284C5.svg)](https://doi.org/10.5281/zenodo.19157888)
[![FAIR checklist badge](https://img.shields.io/badge/fairsoftwarechecklist.net--00a7d9.png)](https://fairsoftwarechecklist.net/v0.2?f=21&a=32113&i=32311&r=123)
[![fair-software.eu](https://img.shields.io/badge/fair--software.eu-%E2%97%8F%20%E2%97%8F%20%E2%97%8F%20%E2%97%8F%20%E2%97%8B-yellow)](https://fair-software.eu)
[![License: GPLv3](https://img.shields.io/badge/license-GPLv3-bd0000.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/license-CC_BY--NC--SA_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-sa/4.0/)
[![Contributor Covenant 3.0 code of conduct badge](https://img.shields.io/badge/Contributor%20Covenant-3.0-4baaaa.svg)](https://www.contributor-covenant.org/version/3/0/code_of_conduct/)
<!-- badges: end -->

## Overview

This repository hosts the source files for the [PMTilesBR](https://pmtiles.com.br) project, which provides [PMTiles](https://docs.protomaps.com/pmtiles/) files for spatial visualization and analysis in Brazil.

[PMTiles](https://docs.protomaps.com/pmtiles/) is a format for storing and serving tiled geospatial data. It is designed to be efficient, scalable, and easy to use, making it ideal for web applications and data visualization.

Learn more at: [pmtiles.com.br](https://pmtiles.com.br)

> If you find this project useful, please consider giving it a star! &nbsp; [![GitHub Repository Stars](https://img.shields.io/github/stars/cem-usp/pmtilesbr)](https://github.com/cem-usp/pmtilesbr)

[![Brazil Municipality Boundaries](images/mapgl-brazil-municipalities.png)](https://pmtiles.com.br)

## Why Use PMTiles?

When working with complex geometries in web mapping applications like [Mapbox](https://www.mapbox.com/), [MapLibre](https://maplibre.org/), and [Leaflet](https://leafletjs.com/), performance can become [a real problem](https://walker-data.com/posts/pmtiles-texas-blocks/). Shapes with many vertices make rendering slow, bloat file sizes, and generally make life harder. [PMTiles](https://docs.protomaps.com/pmtiles/) addresses this by letting you serve precompiled tiles directly from the web, rather than bundling them into your application.

## Usage

You can find detailed instructions and examples on how to use PMTilesBR in the project [website](https://pmtiles.com.br).

The PMTiles files are processed using the [Quarto](https://quarto.org/) publishing system, along with the [tippecanoe](https://github.com/felt/tippecanoe) tool and the [R](https://www.r-project.org/) programming language. To ensure consistent results, the [`renv`](https://rstudio.github.io/renv/) package is used to manage and restore the R environment.

After installing the dependencies mentioned above, follow these steps to render the files:

1. **Clone** this repository to your local machine.
2. **Open** the project in your preferred [IDE](https://en.wikipedia.org/wiki/Integrated_development_environment).
3. **Install package dependencies** by running [`renv::restore()`](https://rstudio.github.io/renv/reference/restore.html) in the R console.
4. **Open** the Quarto notebooks in the [`qmd`](qmd) directory and run the code as described .

To reproduce the website examples, see the [index.qmd](index.qmd) notebook.

## Website

The project website files can be found in the [`docs`](docs) folder. It is made with the [Quarto](https://quarto.org/) publishing system and hosted on [Cloudflare](https://www.cloudflare.com/), with automatic deployment on every commit.

To render it, you must first meet all the requirements listed in the [Usage](#usage) section. After all dependencies are installed, render the website by running the following command in your terminal from the root directory of the project:

```bash
quarto render
```

## Contributing

[![](https://img.shields.io/badge/Contributor%20Covenant-3.0-4baaaa.svg)](https://www.contributor-covenant.org/version/3/0/code_of_conduct/)

Contributions are always welcome! Whether you want to report bugs, suggest new features, or help improve the code or documentation, your input makes a difference.

Before opening a new issue, please check the [issues tab](https://github.com/cem-usp/pmtilesbr/issues) to see if your topic has already been reported.

## Citation

[![DOI Badge](https://img.shields.io/badge/doi-10.5281/zenodo.19157888-1284C5.svg)](https://doi.org/10.5281/zenodo.19157888)

> [!NOTE]
> When using this data, you must also cite the original data sources.

To cite this work, please use the following format:

Vartanian, D., Fernandes, C. N., & Giannotti, M. A. (2026). *PMTilesBR: Tiled geospatial data for Brazil* \[Computer software\]. Center for Metropolitan Studies, University of São Paulo. <https://doi.org/10.5281/zenodo.19157888>

A BibLaTeX entry for LaTeX users is:

```latex
@software{vartanian2026,
  title = {PMTilesBR: Tiled geospatial data for Brazil},
  author = {{Daniel Vartanian} and {Camila Nastari Fernandes} and {Mariana Abrantes Giannotti}},
  year = {2026},
  address = {São Paulo},
  institution = {Center for Metropolitan Studies, University of São Paulo},
  langid = {en},
  doi = {https://doi.org/10.5281/zenodo.19157888}
}
```

## License

[![License: GPLv3](https://img.shields.io/badge/license-GPLv3-bd0000.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/license-CC_BY--NC--SA_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-sa/4.0/)

> [!NOTE]
> The original data sources may be subject to their own licensing terms and conditions.

The code in this repository is licensed under the [GNU General Public License Version 3](https://www.gnu.org/licenses/gpl-3.0). All PMTiles files are released under the [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-nc-sa/4.0/) license.

```
Copyright (C) 2026 Center for Metropolitan Studies

The code in this repository is free software: you can redistribute it and/or
modify it under the terms of the GNU General Public License as published by the
Free Software Foundation, either version 3 of the License, or (at your option)
any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see <https://www.gnu.org/licenses/>.
```

## Acknowledgments

<table>
  <tr>
    <td width="30%" align="center" valign="center">
        <a href="https://centrodametropole.fflch.usp.br"><img src="images/cem-icon.svg" width="190em"/></a>
    </td>
    <td width="70%" valign="center">
      This work was developed with support from the Center for Metropolitan Studies (<a href="https://centrodametropole.fflch.usp.br">CEM</a>) based at the School of Philosophy, Letters and Human Sciences (<a href="https://www.fflch.usp.br/">FFLCH</a>) of the University of São Paulo (<a href="https://usp.br">USP</a>) and at the Brazilian Center for Analysis and Planning (<a href="https://cebrap.org.br/">CEBRAP</a>).
    </td>
  </tr>
</table>

<table>
  <tr>
    <td width="30%" align="center" valign="center">
      <a href="https://fapesp.br/"><img src="images/fapesp-logo.svg" width="160em"/></a>
    </td>
    <td width="70%" valign="center">
      This work was financed, in part, by the São Paulo Research Foundation (<a href="https://fapesp.br/">FAPESP</a>), Brazil. Process Number <a href="https://bv.fapesp.br/en/bolsas/231507/geospatial-data-science-applied-to-food-policies/">2025/17879-2</a>.
    </td>
  </tr>
</table>
