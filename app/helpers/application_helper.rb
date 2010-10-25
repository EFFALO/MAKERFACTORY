# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # Block method that creates an area of the view that
  # is only rendered if the request is coming from an
  # anonymous user.
  def anonymous_only(&block)
    if !logged_in?
      block.call
    end
  end
  
  # Block method that creates an area of the view that
  # only renders if the request is coming from an
  # authenticated user.
  def authenticated_only(&block)
    if logged_in?
      block.call
    end
  end

  def format_time(time, format)
    if format == :datestamp
      time.strftime('%Y-%d-%m')
    elsif format == :human
      time.strftime("%B #{time.day.ordinalize}, %Y @ %H:%M")
    else
      raise "Don't know time format: #{format}"
    end
  end

  def link_to_block_if(conditions, url, &block)
    if conditions
      link_to(url, &block)
    else
      block.call
    end
  end
end
