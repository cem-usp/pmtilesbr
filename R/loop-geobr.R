# # To Do:
# - "read_municipality" with simplified = TRUE, year 2024 and each
#    municipality code.
# - Idem 2022
# - Implement other functions (e.g,`read_amazon`, `read_census_tract`).

# Load Packages -----

library(beepr)
library(cli)
library(dplyr)
library(geobr)
library(fs)
library(here)
library(orbis) # github.com/danielvartan/orbis
library(quarto)
library(stringr)

# Set Parameters -----

qmd_file <- here("qmd", "geobr.qmd")

fun <- "read_municipality"
simplified <- FALSE
min_zoom <- 2
max_zoom <- 10
h3jsr <- FALSE
res <- 9

# year <- 2024

# year <-
#   read_municipality(year = 0000) |>
#   try(silent = TRUE) |>
#   as.character() |>
#   str_extract_all("\\d{4}") |>
#   unlist() |>
#   as.integer() |>
#   sort()

year <- c(2021, 2023, 2025)

# code <- 53
# code <- brazil_municipality_code()
code <- "all"

# code <- c(
#   "all",
#   brazil_state_code() |>
#     unname() |>
#     sort()
# )

# code <- c(
#   # "all",
#   c(
#     2507507, # João Pessoa (PB)
#     3106200, # Belo Horizonte (MG)
#     3550308, # São Paulo (SP)
#     4314902, # Porto Alegre (RS)
#     1501402 # Belém (PA)
#   )
# )

# code <-
#   read_municipality(year = year) |>
#   arrange(1) |>
#   pull(1) # %>%
# c(all", .)

# code <-
#   here("pmtiles", "geobr", "read_municipality") |>
#   dir_ls(type = "file") |>
#   basename() |>
#   str_subset(paste0("year-", year)) |>
#   str_subset(paste0("simplified-", simplified)) |>
#   str_subset(paste0("min_zoom-", min_zoom)) |>
#   str_subset(paste0("max_zoom-", max_zoom)) |>
#   str_extract("\\d+") |>
#   as.integer() |>
#   unique() |>
#   sort() %>%
#   setdiff(code, .) |>
#   sort()

# length(code)

# Perform Loop -----

for (i in code) {
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
          code = i,
          year = j,
          simplified = simplified,
          min_zoom = min_zoom,
          max_zoom = max_zoom,
          h3jsr = h3jsr,
          res = res
        )
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
