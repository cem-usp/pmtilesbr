# Load Packages -----

library(beepr)
library(cli)
library(dplyr)
library(geobr)
library(glue)
library(fs)
library(groomr) # github.com/danielvartan/groomr
library(here)
library(magrittr)
library(stringr)

# Set Parameters -----

qmd_file <- here("qmd", "geobr.qmd")

simplified <- FALSE
min_zoom <- 2
max_zoom <- 10
h3jsr <- FALSE
res <- 9

year <- 2020

# year <-
#   read_state(year = 0000) |>
#   try(silent = TRUE) |>
#   as.character() |>
#   str_extract_all("\\d{4}") |>
#   unlist() |>
#   as.integer() |>
#   sort()

# code <- 2507507
# code <- brazil_municipality_code()
# code <- double_quote("all")

# code <- c(
#   double_quote("all"),
#   brazil_state_code() |>
#     unname() |>
#     sort()
# )

code <- c(
  # double_quote("all"),
  c(
    2507507, # João Pessoa (PB)
    3106200, # Belo Horizonte (MG)
    3550308, # São Paulo (SP)
    4314902, # Porto Alegre (RS)
    1501402 # Belém (PA)
  )
)

# code <-
#   read_municipality(year = year) |>
#   arrange(1) |>
#   pull(1) # %>%
# # c(double_quote("all"), .)

# code <-
#   here("pmtiles", "geobr", "read_municipality") |>
#   dir_ls(type = "file") |>
#   basename() |>
#   str_subset(paste0("year-", year)) |>
#   str_extract("\\d+") |>
#   as.integer() |>
#   unique() |>
#   sort() %>%
#   setdiff(code, .) |>
#   sort()

# length(code)

# Replace Fixed Values -----

parameters <- list(
  simplified = list(
    pattern = "^simplified <- (TRUE|FALSE)$",
    replacement = paste0("simplified <- ", simplified)
  ),
  min_zoom = list(
    pattern = "^min_zoom <- \\d+$",
    replacement = paste0("min_zoom <- ", min_zoom)
  ),
  max_zoom = list(
    pattern = "^max_zoom <- \\d+$",
    replacement = paste0("max_zoom <- ", max_zoom)
  ),
  h3jsr = list(
    pattern = "^h3jsr <- (TRUE|FALSE)$",
    replacement = paste0("h3jsr <- ", h3jsr)
  ),
  res = list(
    pattern = "^res <- \\d+$",
    replacement = paste0("res <- ", res)
  )
)

for (i in parameters) {
  replace_in_file(
    file = qmd_file,
    pattern = i$pattern,
    replacement = i$replacement
  )
}

# Perform Loop -----

for (i in code) {
  for (j in year) {
    cli_progress_step(
      paste0(
        "Processing code ",
        i,
        " for year ",
        j
      )
    )

    replace_in_file(
      file = qmd_file,
      pattern = "^code <- \\d+$|^code <- \"all\"$|^code <- all$",
      replacement = paste0("code <- ", i)
    )

    replace_in_file(
      file = qmd_file,
      pattern = "^year <- \\d{4}$",
      replacement = paste0("year <- ", j)
    )

    system2(
      command = "quarto",
      args = c(
        "render",
        qmd_file,
        "--output -"
      ),
      stdout = NULL
    ) |>
      invisible()

    gc()

    cli_progress_done()
  }
}

cli_progress_step("Finishing up")

cli_progress_done()

cli_alert_success("All done!")

beep(2)
