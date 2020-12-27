# frozen_string_literal: true

if @user.present?
  json.status "OK"
else
  json.status "NG"
  json.error_message @error_message
end
