# fields of the cred:
# .body.raw["cc_secret"]
# .body.raw["cc_token"]
# .body.raw["organization_id"]
data "cycloid_credential" "clever_cloud" {
  # infer it from the context later
  canonical = "clevercloud"
}