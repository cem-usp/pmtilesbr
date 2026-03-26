library(brandr)
library(checkmate)
library(cli)
library(geobr)
library(httr2)
library(magrittr)
library(mapgl)
library(pmtiles) # github.com/walkerke/pmtiles

plot_maplibre <- function(
  file,
  column,
  values = NULL,
  id = hash_md5(runif(1)),
  style = carto_style("voyager"),
  projection = "mercator",
  bounds = NULL,
  fill_color = NULL,
  tooltip = NULL,
  hover_options = list(
    fill_color = get_brand_color("gray-l50"),
    fill_opacity = 1
  ),
  line_width = 0.75,
  seed = 1998,
  ...
) {
  assert_string(file, pattern = "\\.pmtiles$")
  assert_string(column)
  assert_vector(values, null.ok = TRUE)
  assert_string(id)
  assert_string(style, pattern = "\\.json$")
  assert_choice(projection, c("mercator", "globe"))
  assert_numeric(bounds, len = 4, null.ok = TRUE)
  assert_multi_class(fill_color, c("character", "list"), null.ok = TRUE)
  assert_string(tooltip, null.ok = TRUE)
  assert_list(hover_options, null.ok = TRUE)
  assert_number(line_width, lower = 0, null.ok = TRUE)
  assert_int(seed)

  if (!is_online()) {
    cli_abort(
      paste0(
        "No internet connection detected. ",
        "Please check your connection and try again."
      )
    )
  }

  if (is.null(values) && is.null(fill_color)) {
    cli_abort(
      paste0(
        "{.strong {col_red('values')}} cannot be {.code NULL} when ",
        "{.strong {col_yellow('fill_color')}} is not provided."
      )
    )
  }

  pmtiles_metadata <-
    file |>
    pm_show(tilejson = TRUE)

  pmtiles_layer <-
    pmtiles_metadata |>
    extract2("vector_layers") |>
    extract2(1) |>
    extract2("id")

  if (is.null(bounds)) {
    bounds <-
      pmtiles_metadata |>
      extract2("bounds") |>
      unlist()
  }

  set.seed(seed)

  if (is.null(fill_color)) {
    fill_color <- match_expr(
      column = column,
      values = values,
      stops = c(
        get_brand_color("red"),
        get_brand_color("black"),
        get_brand_color("yellow")
      ) |>
        sample(
          size = values |> length(),
          replace = TRUE,
          prob = c(7, 1, 2)
        ),
      default = get_brand_color("gray")
    )
  }

  out <-
    maplibre(
      style = style,
      bounds = bounds,
      projection = projection,
      ...
    ) |>
    add_pmtiles_source(
      id = id,
      url = file,
      source_type = "vector"
    ) |>
    add_fill_layer(
      id = paste0(id, "_fill"),
      source = id,
      source_layer = pmtiles_layer,
      fill_color = fill_color,
      fill_opacity = 1,
      tooltip = tooltip,
      hover_options = hover_options
    ) |>
    add_navigation_control() |>
    add_screenshot_control() |>
    add_fullscreen_control() |>
    add_reset_control()

  if (!is.null(line_width)) {
    out <-
      out |>
      add_line_layer(
        id = paste0(id, "_line"),
        source = id,
        source_layer = pmtiles_layer,
        line_color = get_brand_color("white"),
        line_width = line_width
      )
  }

  out
}
