json.event do
  json.id @event.id
  json.name @event.name
  json.description @event.description
  json.location @event.location
  json.start_time @event.start_time
  json.end_time @event.end_time
end