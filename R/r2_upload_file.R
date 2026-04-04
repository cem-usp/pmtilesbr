library(aws.signature)
library(checkmate)
library(digest)
library(httr2)
library(mime)

#' @examples
#' r2_upload_file("path/to/file", "object/key")

r2_upload_file <- function(
  file,
  object_key,
  bucket_name = Sys.getenv("CLOUDFLARE_BUCKET_NAME"),
  account_id = Sys.getenv("CLOUDFLARE_ACCOUNT_ID"),
  access_key_id = Sys.getenv("CLOUDFLARE_ACCESS_KEY_ID"),
  secret_access_key = Sys.getenv("CLOUDFLARE_SECRET_ACCESS_KEY")
) {
  assert_string(file)
  assert_string(object_key)
  assert_string(bucket_name)
  assert_string(account_id)
  assert_string(access_key_id)
  assert_string(secret_access_key)

  file_content <-
    file |>
    readBin(
      what = "raw",
      n = file |> file.size()
    )

  content_type <- file |> guess_type()
  datetime <- Sys.time() |> format("%Y%m%dT%H%M%SZ", tz = "UTC")
  date <- datetime |> substr(1, 8)

  endpoint <- paste0(
    "https://",
    account_id,
    ".r2.cloudflarestorage.com/",
    bucket_name,
    "/",
    object_key
  )

  body_hash <-
    file_content |>
    digest(
      algo = "sha256",
      serialize = FALSE
    )

  headers <- list(
    "content-type" = content_type,
    "host" = account_id |> paste0(".r2.cloudflarestorage.com"),
    "x-amz-content-sha256" = body_hash,
    "x-amz-date" = datetime
  )

  sig <-
    datetime |>
    signature_v4_auth(
      region = "auto",
      service = "s3",
      verb = "PUT",
      action = paste0("/", bucket_name, "/", object_key),
      query_args = list(),
      canonical_headers = headers,
      request_body = file_content,
      key = access_key_id,
      secret = secret_access_key
    )

  endpoint |>
    request() |>
    req_method("PUT") |>
    req_headers(
      "Content-Type" = content_type,
      "x-amz-date" = datetime,
      "x-amz-content-sha256" = body_hash,
      "Authorization" = sig$SignatureHeader
    ) |>
    req_body_raw(file_content) |>
    req_perform()

  invisible()
}
