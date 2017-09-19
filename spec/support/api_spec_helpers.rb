module ApiSpecHelpers
  def json_response
    parsed = MultiJson.load(response.body)
    if parsed.respond_to?(:with_indifferent_access)
      parsed.with_indifferent_access
    else
      parsed
    end
  end
end
