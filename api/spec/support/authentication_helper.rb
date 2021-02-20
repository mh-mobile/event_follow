# frozen_string_literal: true

module AuthenticationHelper
  def setup_jwt_authentication
    jwt = JSON.parse(File.read(file_fixture("jwt.json")))
    @token = jwt["jwt_token"]
    @certificate = JSON.parse(File.read(file_fixture("certificates.json")))
    @project_ids = ["firebase-id-token"]
  end

  def authenticate(token: @token)
    @headers ||= {}
    @headers["Authorization"] = "Bearer #{token}"
    @headers
  end

  def stub_firebase_id_token
    allow_any_instance_of(FirebaseIdToken::Certificates).to receive(:local_certs).and_return(@certificate)
    allow_any_instance_of(FirebaseIdToken::Configuration).to receive(:project_ids).and_return(@project_ids)
  end

  def stub_twitter_reuest
    allow_any_instance_of(TwitterRequest).to receive(:verify_credentials).and_return(verify_credentials)
  end
end
