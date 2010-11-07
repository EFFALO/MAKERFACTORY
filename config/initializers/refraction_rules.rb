Refraction.configure do |req|
  mf_host = 'makerfactory.com'

  if req.host != mf_host
    req.permanent! :host => mf_host
  end
end
