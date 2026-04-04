# Load Packages -----

library(beepr)
library(cli)
library(fs)
library(here)
library(ISOcodes)
library(orbis) # github.com/danielvartan/orbis
library(quarto)

# Set Parameters -----

qmd_file <- here("qmd", "geodata.qmd")

fun <- "gadm" # "gadm" | "world"
level <- 0 # 0-1 (gadm()) | 0 (world())
version <- "latest"
resolution <- 1 # 1-2 (gadm()) | 1-5 (world())
simplified <- TRUE
min_zoom <- 2
max_zoom <- 10
h3jsr <- FALSE
res <- 9

country <- "BRA"

# country <-
#   country_names(format = "alpha 3") |>
#   unname()

# length(country_choices)

# Perform Loop -----

for (i in country) {
  if (i != "all") {
    i <- i |> as.integer()
  }

  for (j in year) {
    cli_progress_step(
      paste0("Processing code ", i, " for year ", j)
    )

    qmd_file |>
      quarto_render(
        execute_params = list(
          fun = fun,
          country = i,
          year = j,
          simplified = simplified,
          min_zoom = min_zoom,
          max_zoom = max_zoom,
          h3jsr = h3jsr,
          res = res
        )
        # quarto_args = c("--output", "-")
      )

    gc()

    cli_progress_done()
  }
}

# Finishing Up -----

cli_progress_step("Finishing up")

qmd_file |> path_ext_set("html") |> file_delete()
qmd_file |> path_ext_remove() |> paste0("_files") |> dir_delete()

cli_progress_done()

cli_alert_success("All done!")

beep(2)
