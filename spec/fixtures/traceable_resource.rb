class TraceableResource < Webmachine::Resource
  def trace?
    true
  end

  def to_html
    "<html><head><title>Hi</title><body><p>html_hi</p></body></html>"
  end
end
