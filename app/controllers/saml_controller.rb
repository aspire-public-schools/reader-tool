class SamlController < ApplicationController
  def init
    request = OneLogin::RubySaml::Authrequest.new
    redirect_to(request.create(saml_settings))
  end

  def consume
    response = OneLogin::RubySaml::Response.new(params[:SAMLResponse])
    response.settings = saml_settings

    if response.is_valid? && reader = current_account.users.find_by_email(response.name_id)
      authorize_success(reader)
    else
      authorize_failure(reader)
    end
  end

  def saml_settings

    settings = OneLogin::RubySaml::Settings.new

    settings.assertion_consumer_service_url = "aspirereader.herokuapp.com"
    settings.issuer                         = "https://app.onelogin.com/saml/metadata/365951"
    settings.idp_sso_target_url             = "https://app.onelogin.com/saml/signon/365951"
    settings.name_identifier_format         = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"

    settings.authn_context = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"

    settings
  end


