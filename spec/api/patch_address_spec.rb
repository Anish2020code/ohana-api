require 'rails_helper'

describe 'PATCH address' do
  before(:each) do
    @loc = create(:location)
    @address = @loc.address
    @token = ENV['ADMIN_APP_TOKEN']
    @attrs = { street: 'foo', city: 'bar', state: 'CA', zip: '90210' }
  end

  describe 'PATCH /locations/:location_id/address/:id' do
    it 'returns 200 when validations pass' do
      patch(
        api_endpoint(path: "/locations/#{@loc.id}/address/#{@address.id}"),
        @attrs,
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response).to have_http_status(200)
    end

    it 'returns the updated address when validations pass' do
      patch(
        api_endpoint(path: "/locations/#{@loc.id}/address/#{@address.id}"),
        @attrs,
        'HTTP_X_API_TOKEN' => @token
      )
      expect(json['city']).to eq 'bar'
    end

    it "updates the location's address" do
      patch(
        api_endpoint(path: "/locations/#{@loc.id}/address/#{@address.id}"),
        @attrs,
        'HTTP_X_API_TOKEN' => @token
      )
      get api_endpoint(path: "/locations/#{@loc.id}")
      expect(json['address']['street']).to eq 'foo'
    end

    it "doesn't add a new address" do
      patch(
        api_endpoint(path: "/locations/#{@loc.id}/address/#{@address.id}"),
        @attrs,
        'HTTP_X_API_TOKEN' => @token
      )
      expect(Address.count).to eq(1)
    end

    it 'requires a valid address id' do
      patch(
        api_endpoint(path: "/locations/#{@loc.id}/address/123"),
        @attrs,
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response.status).to eq(404)
      expect(json['message']).
        to include 'The requested resource could not be found.'
    end

    it 'returns 422 when attribute is invalid' do
      patch(
        api_endpoint(path: "/locations/#{@loc.id}/address/#{@address.id}"),
        @attrs.merge!(street: ''),
        'HTTP_X_API_TOKEN' => @token
      )
      expect(response.status).to eq(422)
      expect(json['message']).to eq('Validation failed for resource.')
      expect(json['errors'].first).
        to eq('street' => ["can't be blank for Address"])
    end

    it "doesn't allow updating a address without a valid token" do
      patch(
        api_endpoint(path: "/locations/#{@loc.id}/address/#{@address.id}"),
        @attrs,
        'HTTP_X_API_TOKEN' => 'invalid_token'
      )
      expect(response.status).to eq(401)
    end
  end
end
