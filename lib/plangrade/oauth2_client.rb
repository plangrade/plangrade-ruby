require 'oauth2-client'

module Plangrade
  class OAuth2Client < OAuth2Client::Client

    SITE_URL       = 'https://plangrade.com'
    TOKEN_PATH     = '/oauth/token'
    AUTHORIZE_PATH = '/oauth/authorize'

    def initialize(client_id, client_secret, opts={})
      site_url = opts.delete(:site_url) || SITE_URL
      opts[:token_path]     ||= TOKEN_PATH
      opts[:authorize_path] ||= AUTHORIZE_PATH
      super(site_url, client_id, client_secret, opts)
      yield self if block_given?
      self
    end

    # Generates the Plangrade URL that the user will be redirected to in order to
    # authorize your application
    #
    # @see http://docs.plangrade.com/#request-authorization
    #
    # @opts [Hash] additional parameters to be include in URL eg. scope, state, etc
    #
    # >> client = Plangrade::OAuth2Client.new('ETSIGVSxmgZitijWZr0G6w', '4bJZY38TCBB9q8IpkeualA2lZsPhOSclkkSKw3RXuE')
    # >> client.webclient_authorization_url({
    #      :redirect_uri => 'http://localhost:3000/auth/plangrade/callback',
    #    })
    # >> https://plangrade.com/oauth/authorize/?client_id={client_id}&
    #    redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fauth%2F%2Fplangrade%2Fcallback&response_type=token
    #
    def webclient_authorization_url(opts={})
      implicit.token_url(opts)
    end

    # Generates the Plangrade URL that the user will be redirected to in order to
    # authorize your application
    #
    # @see http://docs.plangrade.com/#request-authorization
    #
    # @opts [Hash] additional parameters to be include in URL eg. scope, state, etc
    #
    # >> client = Plangrade::OAuth2Client.new('ETSIGVSxmgZitijWZr0G6w', '4bJZY38TCBB9q8IpkeualA2lZsPhOSclkkSKw3RXuE')
    # >> client.webserver_authorization_url({
    #      :redirect_uri => 'http://localhost:3000/auth/plangrade/callback',
    #    })
    # >> https://plangrade.com/oauth/authorize/?client_id={client_id}&
    #    redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fauth%2Fplangrade%2Fcallback&response_type=code
    #
    def webserver_authorization_url(opts={})
      opts[:scope] = normalize_scope(opts[:scope]) if opts[:scope]
      authorization_code.authorization_url(opts)
    end

    # Makes a request to Plangrade server that will swap your authorization code for an access
    # token
    #
    # @see http://docs.plangrade.com/#finish-authorization
    #
    # @opts [Hash] may include redirect uri and other query parameters
    #
    # >> client = PlangradeClient.new(config)
    # >> client.access_token_from_authorization_code('G3Y6jU3a', {
    #      :redirect_uri => 'http://localhost:3000/auth/plangrade/callback',
    #    })
    #
    # POST /oauth2/access_token HTTP/1.1
    # Host: www.plangrade.com
    # Content-Type: application/x-www-form-urlencoded

    #  client_id={client_id}&code=G3Y6jU3a&grant_type=authorization_code&
    #  redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fauth%2Fplangrade%2Fcallback&client_secret={client_secret}
    def access_token_from_authorization_code(code, opts={})
      opts[:authenticate] ||= :body
      authorization_code.get_token(code, opts)
    end
  end
end