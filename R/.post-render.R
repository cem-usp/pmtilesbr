# Load Packages -----

library(beepr)
library(fs)
library(here)

# Add `og-image.png` to `./docs/images` -----

file <- here("docs", "images", "og-image.png")

if (!file_exists(file)) {
  here("images", "og-image.png") |>
    file_copy(
      new_path = file,
      overwrite = TRUE
    )
}

# Check If the Script Ran Successfully -----

beep(1)

Sys.sleep(3)
