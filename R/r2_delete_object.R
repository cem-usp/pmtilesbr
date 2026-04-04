library(aws.signature)
library(checkmate)
library(digest)
library(httr2)

#' @examples
#' r2_delete_object("geobr/file.pmtiles")

r2_delete_object <- function(
  object_key,
  bucket_name = Sys.getenv("CLOUDFLARE_BUCKET_NAME"),
  account_id = Sys.getenv("CLOUDFLARE_ACCOUNT_ID"),
  access_key_id = Sys.getenv("CLOUDFLARE_ACCESS_KEY_ID"),
  secret_access_key = Sys.getenv("CLOUDFLARE_SECRET_ACCESS_KEY")
) {
  assert_string(object_key)
  assert_string(bucket_name)
  assert_string(account_id)
  assert_string(access_key_id)
  assert_string(secret_access_key)

  datetime <- Sys.time() |> format("%Y%m%dT%H%M%SZ", tz = "UTC")

  endpoint <- paste0(
    "https://",
    account_id,
    ".r2.cloudflarestorage.com/",
    bucket_name,
    "/",
    object_key
  )

  headers <- list(
    "host" = paste0(account_id, ".r2.cloudflarestorage.com"),
    "x-amz-content-sha256" = digest("", algo = "sha256", serialize = FALSE),
    "x-amz-date" = datetime
  )

  sig <- datetime |>
    signature_v4_auth(
      region = "auto",
      service = "s3",
      verb = "DELETE",
      action = paste0("/", bucket_name, "/", object_key),
      query_args = list(),
      canonical_headers = headers,
      request_body = "",
      key = access_key_id,
      secret = secret_access_key
    )

  endpoint |>
    request() |>
    req_method("DELETE") |>
    req_headers(
      "x-amz-date" = datetime,
      "x-amz-content-sha256" = digest("", algo = "sha256", serialize = FALSE),
      "Authorization" = sig$SignatureHeader
    ) |>
    req_perform()

  invisible()
}
