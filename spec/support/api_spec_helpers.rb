module ApiSpecHelpers
  def json_response
    MultiJson.load(response.body).with_indifferent_access
  end
end
