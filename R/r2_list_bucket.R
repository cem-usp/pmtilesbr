library(aws.signature)
library(checkmate)
library(here)
library(httr2)
library(xml2)
library(yaml)

#' @examples
#' r2_list_bucket()

r2_list_bucket <- function(
  output_file = here("pmtiles.yaml"),
  bucket_name = Sys.getenv("CLOUDFLARE_BUCKET_NAME"),
  account_id = Sys.getenv("CLOUDFLARE_ACCOUNT_ID"),
  access_key_id = Sys.getenv("CLOUDFLARE_ACCESS_KEY_ID"),
  secret_access_key = Sys.getenv("CLOUDFLARE_SECRET_ACCESS_KEY")
) {
  assert_string(output_file)
  assert_string(bucket_name)
  assert_string(account_id)
  assert_string(access_key_id)
  assert_string(secret_access_key)

  all_objects <- list()
  continuation_token <- NULL

  repeat {
    datetime <- Sys.time() |> format("%Y%m%dT%H%M%SZ", tz = "UTC")

    query_args <- list("list-type" = "2")

    if (!is.null(continuation_token)) {
      query_args[["continuation-token"]] <- continuation_token
    }

    headers <- list(
      "host" = paste0(account_id, ".r2.cloudflarestorage.com"),
      "x-amz-content-sha256" = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
      "x-amz-date" = datetime
    )

    sig <- datetime |>
      signature_v4_auth(
        region = "auto",
        service = "s3",
        verb = "GET",
        action = paste0("/", bucket_name),
        query_args = query_args,
        canonical_headers = headers,
        request_body = "",
        key = access_key_id,
        secret = secret_access_key
      )

    endpoint <- paste0(
      "https://",
      account_id,
      ".r2.cloudflarestorage.com/",
      bucket_name
    )

    xml_resp <- endpoint |>
      request() |>
      req_method("GET") |>
      req_url_query(!!!query_args) |>
      req_headers(
        "x-amz-date" = datetime,
        "x-amz-content-sha256" = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
        "Authorization" = sig$SignatureHeader
      ) |>
      req_perform() |>
      resp_body_xml()

    ns <- xml_resp |> xml_ns()

    objects <-
      xml_resp |>
      xml_find_all(".//d1:Contents", ns) |>
      lapply(function(node) {
        list(
          key = node |> xml_find_first("d1:Key", ns) |> xml_text(),
          size = node |>
            xml_find_first("d1:Size", ns) |>
            xml_text() |>
            as.integer(),
          size_mb = node |>
            xml_find_first("d1:Size", ns) |>
            xml_text() |>
            as.numeric() |>
            (\(x) round(x / 1024^2, 3))(),
          last_modified = node |>
            xml_find_first("d1:LastModified", ns) |>
            xml_text()
        )
      })

    all_objects <- c(all_objects, objects)

    is_truncated <-
      xml_resp |>
      xml_find_first(".//d1:IsTruncated", ns) |>
      xml_text()

    if (!identical(is_truncated, "true")) {
      break
    }

    continuation_token <-
      xml_resp |>
      xml_find_first(".//d1:NextContinuationToken", ns) |>
      xml_text()
  }

  output <- list(
    project = bucket_name,
    base_url = "https://tiles.pmtiles.com.br/",
    generated_at = Sys.time() |> format("%Y-%m-%dT%H:%M:%SZ", tz = "UTC"),
    object_count = length(all_objects),
    objects = all_objects
  )

  output |> write_yaml(output_file)

  message(length(all_objects), " objects listed in: ", output_file)

  invisible(all_objects)
}
