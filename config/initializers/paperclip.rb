opts = {
  :storage => :s3,
  :s3_credentials => {
    :access_key_id => ENV['S3_KEY'],
    :secret_access_key => ENV['S3_SECRET']
  },
  :bucket => ENV['S3_BUCKET'],
  :path => "/:attachment/:id/:style.:extension",
}
ActiveRecord::Base::S3_OPTS = ENV['S3_BUCKET'] && opts

