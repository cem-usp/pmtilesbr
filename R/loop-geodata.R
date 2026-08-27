# # To Do:
# - "world" with different resolutions.

# Load Packages -----

library(beepr)
library(cli)
library(fs)
library(geodata)
library(here)
library(ISOcodes)
library(magrittr)
library(orbis) # github.com/danielvartan/orbis
library(quarto)
library(stringr)

# Set Parameters -----

qmd_file <- here("qmd", "geodata.qmd")

raw_data_dir <- here("data-raw")

fun <- "world" # "gadm" | "world"
level <- 0 # 0-1 (gadm()) | 0 (world())
version <- "latest"
resolution <- 3 # 1-2 (gadm()) | 1-5 (world())
min_zoom <- 0
max_zoom <- 10
h3jsr <- FALSE
res <- 9

# https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3

country <- "BRA"

# country <-
#   country_names(format = "alpha 3") |>
#   str_subset("ATA|HKG|MAC", negate = TRUE) |>
#   unname() # %>%
# # magrittr::extract(seq(133, length(.)))

# fmt: skip
# country <- c(
#   "ABW", "ALA", "AND", "ARM", "BHS", "GUM", "IMN", "LIE", "SGP", "TUV"
# )

# length(country)

# Perform Loop -----

for (i in country) {
  cli_progress_step(
    paste0("Processing country code ", i)
  )

  if (fun == "gadm") {
    test <-
      i |>
      gadm(
        level = level,
        path = raw_data_dir,
        version = version,
        resolution = resolution
      )
  } else if (fun == "world") {
    test <-
      world(
        resolution = resolution,
        level = level,
        path = raw_data_dir,
        version = version
      )
  }

  if (is.null(test)) {
    next
  }

  qmd_file |>
    quarto_render(
      execute_params = list(
        fun = fun,
        country = i,
        level = level,
        version = version,
        resolution = resolution,
        min_zoom = min_zoom,
        max_zoom = max_zoom,
        h3jsr = h3jsr,
        res = res
      )
    )

  gc()

  cli_progress_done()
}

# Finishing Up -----

cli_progress_step("Finishing up")

qmd_file |> path_ext_set("html") |> file_delete()
qmd_file |> path_ext_remove() |> paste0("_files") |> dir_delete()

cli_progress_done()

cli_alert_success("All done!")

beep(2)
