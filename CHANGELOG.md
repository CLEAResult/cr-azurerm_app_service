[Unreleased]

[v1.5.1] - 2020-02-25

Add DOTNETCORE as valid value for supported_fx

[v1.5.0] - 2020-01-13

Better container support for linux web apps

    - Variable descriptions clarify valid container and non-container values for `fx` 
    - Setting the `fx` variable to `compose` or `kube` triggers base64 encode of `fx_version` variable
    - Set default value for storage_accounts variable 
    - Add ip_restrictions support in site_config
