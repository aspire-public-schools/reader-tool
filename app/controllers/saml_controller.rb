class SamlController < ApplicationController
  begin
    require 'dotenv'
    Dotenv.load
  rescue LoadError
  end

  def index
    request = OneLogin::RubySaml::Authrequest.new
    redirect_to(request.create(saml_settings))
  end

  def create
    response = OneLogin::RubySaml::Response.new(params[:SAMLResponse])
    response.settings = saml_settings
    if response.is_valid? && reader = Reader.find_by_email(response.name_id)
      session[:current_reader_id] = reader.id
      redirect_to observations_path
    else
      redirect_to root_path, flash: {error: "Godzilla didn't like your e-mail"}
    end
  end

  def saml_settings

    settings = OneLogin::RubySaml::Settings.new

    settings.assertion_consumer_service_url = "http://localhost:3000/saml"
    settings.issuer                         = "https://app.onelogin.com/saml/metadata/365951"
    settings.idp_sso_target_url             = "https://app.onelogin.com/saml/signon/365951"
    settings.idp_cert_fingerprint           = ENV['ONELOGIN_FINGERPRINT']
    settings.name_identifier_format         = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"

    settings.authn_context = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"

    settings
  end

  def metadata
    settings = Account.get_saml_settings
    meta = OneLogin::RubySaml::Metadata.new
    render :xml => meta.generate(settings)
  end

end

#   root to: 'readers#index'

#   namespace :admin do
#     get '', to: 'dashboard#index', as: '/'
#     resources :readers
#     resources :observations
#     put 'observations_updates', to: 'observations#update'
#   end

#   resources :readers, only: [:index, :create, :update, :new]
#   resources :sessions, only: [:create, :destroy]
#   resources :observations do
#     resources :domains do
#       resources :indicators do
#        resources :evidences do
#           get :score, on: :collection
#         end
#       end
#     end
#   end

# match 'admin/readers/:id' => 'admin/readers#edit'

#   match '/logout', to: 'sessions#destroy', via: 'delete'

#   get 'login' => 'readers#index', as: 'login'
# end
