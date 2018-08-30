module Response
  def json_response(response_hash, status = :ok)
    render(json: response_hash, status: status)
  end
end
