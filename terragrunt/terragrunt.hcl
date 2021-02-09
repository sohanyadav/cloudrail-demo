locals {
  cloudrail_api_key = get_env("CLOUDRAIL_API_KEY", "")
}

terraform {
  after_hook "cloudrail_after_hook" {
    commands     = ["plan"]

    # Run Cloudrail as a docker container. Note that the plan outfile is hardcoded here.
    # We're running Cloudrail in CI mode, where you also need to supply information about the
    # build ID and the URL directly to the build. We put in some generic values for now, please replace them.
    execute      = [
      "docker", 
      "run", 
      "--rm", 
      "-v", "${get_env("PWD", "")}:/data", 
      "indeni/cloudrail-cli", 
      "run", 
      "-d", ".",
      "--tf-plan", "plan.out",
      "--origin", "ci",
      "--build-link", "https://somelink",
      "--execution-source-identifier", "build-id",
      "--api-key", "${local.cloudrail_api_key}",
      "--auto-approve"
      ]
  }
}