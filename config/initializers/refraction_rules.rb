Refraction.configure do |req|
  mf_host = 'makerfactory.com'
  mf_staging = 'staging.makerfactory.com'

  if((req.host != mf_staging) && (req.host != mf_host))
    req.permanent! :host => mf_host
  end
end if defined?(Refraction)
