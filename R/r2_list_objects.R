library(aws.signature)
library(checkmate)
library(digest)
library(httr2)
library(xml2)

#' @examples
#' r2_list_objects("folder/")

r2_list_objects <- function(
  prefix,
  bucket_name = Sys.getenv("CLOUDFLARE_BUCKET_NAME"),
  account_id = Sys.getenv("CLOUDFLARE_ACCOUNT_ID"),
  access_key_id = Sys.getenv("CLOUDFLARE_ACCESS_KEY_ID"),
  secret_access_key = Sys.getenv("CLOUDFLARE_SECRET_ACCESS_KEY"),
  continuation_token = NULL
) {
  assert_string(prefix)
  assert_string(bucket_name)
  assert_string(account_id)
  assert_string(access_key_id)
  assert_string(secret_access_key)
  assert_string(continuation_token, null.ok = TRUE)

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
    "x-amz-content-sha256" = digest("", algo = "sha256", serialize = FALSE),
    "x-amz-date" = datetime
  )

  sig <-
    datetime |>
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

  resp <-
    endpoint |>
    request() |>
    req_method("GET") |>
    req_url_query(!!!query_args) |>
    req_headers(
      "x-amz-date" = datetime,
      "x-amz-content-sha256" = digest("", algo = "sha256", serialize = FALSE),
      "Authorization" = sig$SignatureHeader
    ) |>
    req_perform()

  resp |> resp_body_xml()
}
