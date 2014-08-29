json.array!(@frames) do |frame|
  json.extract! frame, :id, :try1, :try2integer, :number
  json.url frame_url(frame, format: :json)
end
