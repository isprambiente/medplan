Rails.application.config.middleware.use OmniAuth::Builder do
  provider :openid_connect, {
    name:               ENV.fetch("OIDC_NAME", "oidc").to_sym,
    issuer:             ENV.fetch("OIDC_ISSUER", "issuer"),
    client_auth_method: "basic",
    scope:              ENV.fetch("OIDC_SCOPE", "openid name uid email").split,
    response_type:      :code,
    discovery:          true,
    client_options: {
      identifier:       ENV.fetch("OIDC_CLIENT_ID", "asset-manager"),
      secret:           ENV.fetch("OIDC_CLIENT_SECRET", "changeme"),
      redirect_uri:     ENV.fetch("OIDC_REDIRECT_URI", "/auth/oidc/callback")
    }
  }
end
