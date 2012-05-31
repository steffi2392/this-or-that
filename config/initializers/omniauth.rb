Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, "389450951093631", "39546178307aae315353100300077729"
end