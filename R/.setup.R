# Load Packages -----

library(brandr)
library(colorspace)
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
    c("red", "white")
  ),
  "BRANDR_COLOR_DIVERGING" = get_brand_color(c(
    "red",
    "white",
    "yellow"
  )),
  "BRANDR_COLOR_QUALITATIVE" = get_brand_color(
    c(
      "red",
      "black",
      "yellow",
      "gray"
    )
  )
)

for (i in seq_along(brandr_options)) {
  options(brandr_options[i])
}

# Set `systemfonts` -----

clear_registry()

register_font(
  name = "nunito-sans-medium",
  plain = here("ttf", "nunitosans-variablefont-ytlcopszwdthwght.ttf"),
  italic = here("ttf", "nunitosans-italic-variablefont-ytlcopszwdthwght.ttf"),
  features = font_feature(wght = 500)
)

# Bold (weight 700)
register_font(
  name = "nunito-sans-bold",
  plain = here("ttf", "nunitosans-variablefont-ytlcopszwdthwght.ttf"),
  italic = here("ttf", "nunitosans-italic-variablefont-ytlcopszwdthwght.ttf"),
  features = font_feature(wght = 700)
)

# Black (weight 900)
register_font(
  name = "nunito-sans-black",
  plain = here("ttf", "nunitosans-variablefont-ytlcopszwdthwght.ttf"),
  italic = here("ttf", "nunitosans-italic-variablefont-ytlcopszwdthwght.ttf"),
  features = font_feature(wght = 900)
)

# registry_fonts()

# Set `ggplot2` -----

theme_set(
  theme_bw() +
    theme(
      text = element_text(
        color = get_brand_color("black"),
        family = "nunito-sans-medium",
        face = "plain"
      ),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      legend.frame = element_blank(),
      legend.ticks = element_line(color = "white")
    )
)
