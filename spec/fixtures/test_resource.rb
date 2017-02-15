class TestResource < Webmachine::Resource
  def content_types_provided
    [['text/plain', :to_text]]
  end

  def to_text
    response.set_cookie 'TEST', 'VALUE'
    'OK'
  end
end
