ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  :us => '%m/%d/%y',
  :us_with_time => '%m/%d/%y, %l:%M %p',
  :short_with_time => '%e %B %Y, %l:%M %p',
  :short_day => '%e %B %Y',
  :long_day => '%A, %e %B %Y',
  :short_time => '%l:%M %p'
)

Date::DATE_FORMATS[:human] = "%B %e, %Y"
