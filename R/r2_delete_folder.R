library(aws.signature)
library(checkmate)
library(digest)
library(here)
library(httr2)
library(xml2)

here("R", "r2_delete_object.R") |> source()
here("R", "r2_list_objects.R") |> source()

#' @examples
#' r2_delete_folder("folder/")

r2_delete_folder <- function(
  prefix,
  bucket_name = Sys.getenv("CLOUDFLARE_BUCKET_NAME"),
  account_id = Sys.getenv("CLOUDFLARE_ACCOUNT_ID"),
  access_key_id = Sys.getenv("CLOUDFLARE_ACCESS_KEY_ID"),
  secret_access_key = Sys.getenv("CLOUDFLARE_SECRET_ACCESS_KEY")
) {
  assert_string(prefix)
  assert_string(bucket_name)
  assert_string(account_id)
  assert_string(access_key_id)
  assert_string(secret_access_key)

  if (!grepl("/$", prefix)) {
    prefix <- paste0(prefix, "/")
  }

  continuation_token <- NULL

  repeat {
    xml_resp <- r2_list_objects(
      prefix = prefix,
      bucket_name = bucket_name,
      account_id = account_id,
      access_key_id = access_key_id,
      secret_access_key = secret_access_key,
      continuation_token = continuation_token
    )

    keys <-
      xml_resp |>
      xml_find_all(".//d1:Key", xml_ns(xml_resp)) |>
      xml_text()

    for (key in keys) {
      message("Deleting: ", key)
      r2_delete_object(
        object_key = key,
        bucket_name = bucket_name,
        account_id = account_id,
        access_key_id = access_key_id,
        secret_access_key = secret_access_key
      )
    }

    is_truncated <-
      xml_resp |>
      xml_find_first(".//d1:IsTruncated", xml_ns(xml_resp)) |>
      xml_text()

    if (!identical(is_truncated, "true")) {
      break
    }

    continuation_token <-
      xml_resp |>
      xml_find_first(".//d1:NextContinuationToken", xml_ns(xml_resp)) |>
      xml_text()
  }

  invisible()
}

r2_list_objects <- function(
  prefix,
  bucket_name = Sys.getenv("CLOUDFLARE_BUCKET_NAME"),
  account_id = Sys.getenv("CLOUDFLARE_ACCOUNT_ID"),
  access_key_id = Sys.getenv("CLOUDFLARE_ACCESS_KEY_ID"),
  secret_access_key = Sys.getenv("CLOUDFLARE_SECRET_ACCESS_KEY"),
  continuation_token = NULL
) {
  datetime <- Sys.time() |> format("%Y%m%dT%H%M%SZ", tz = "UTC")

  query_args <- list(
    "list-type" = "2",
    "prefix" = prefix
  )

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

  resp <- endpoint |>
    request() |>
    req_method("GET") |>
    req_url_query(!!!query_args) |>
    req_headers(
      "x-amz-date" = datetime,
      "x-amz-content-sha256" = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
      "Authorization" = sig$SignatureHeader
    ) |>
    req_perform()

  resp |> resp_body_xml()
}
