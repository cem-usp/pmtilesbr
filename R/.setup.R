# Load Packages -----

library(brandr)
library(downlit)
library(ggplot2)
library(here)
library(knitr)
library(magrittr)
library(ragg)
library(systemfonts)
library(xml2)

# Set General Options -----

options(
  dplyr.print_min = 6,
  dplyr.print_max = 6,
  pillar.max_footer_lines = 2,
  pillar.min_chars = 15,
  scipen = 10,
  digits = 10,
  stringr.view_n = 6,
  pillar.bold = TRUE,
  width = 77 # 80 - 3 for #> comment
)

# Set `knitr`` -----

clean_cache() |> suppressWarnings()

opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  root.dir = here(),
  dev = "ragg_png"
)

# Set `brandr` -----

options(BRANDR_BRAND_YML = here("_brand.yml"))

brandr_options <- list(
  "BRANDR_COLOR_SEQUENTIAL" = get_brand_color(
    c("blue", "white")
  ),
  "BRANDR_COLOR_DIVERGING" = get_brand_color(c(
    "comp-blue-3",
    "white",
    "comp-blue-6"
  )),
  "BRANDR_COLOR_QUALITATIVE" = get_brand_color(
    c(
      "square-blue-green",
      "square-blue-orange",
      "square-blue-blue",
      "square-blue-purple",
      "gray",
      "black"
    )
  )
)

for (i in seq_along(brandr_options)) {
  options(brandr_options[i])
}

# Set `systemfonts` -----

clear_registry()

register_font(
  name = "montserrat",
  plain = here("ttf", "montserrat-regular.ttf"),
  bold = here("ttf", "montserrat-black.ttf"),
  italic = here("ttf", "montserrat-italic.ttf"),
  bolditalic = here("ttf", "montserrat-bolditalic.ttf")
)

# registry_fonts()

# Set `ggplot2` -----

theme_set(
  theme_bw() +
    theme(
      text = element_text(
        color = get_brand_color("black"),
        family = "montserrat",
        face = "plain"
      ),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      legend.frame = element_blank(),
      legend.ticks = element_line(color = "white")
    )
)
