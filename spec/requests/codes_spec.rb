require 'rails_helper'

RSpec.describe 'code endpoints', type: :request do
  context 'without authentication' do
    let(:group) { FactoryGirl.create(:group) }

    it 'requires authentication' do
      put "/groups/#{group.id}/code"
      expect(response).to have_http_status :unauthorized
      expect(json_response).not_to have_key :id
    end
  end

  context 'with authentication' do
    describe '#update' do
      let(:current_user) { FactoryGirl.create(:user) }
      let(:group) { FactoryGirl.create(:group, creator: current_user) }
      let(:other_group) { FactoryGirl.create(:group) }

      before :each do
        login_user(current_user)
      end

      it 'updates code for a group current user is member of' do
        old_code = group.code
        put "/groups/#{group.id}/code"
        expect(response).to be_success
        expect(json_response).to have_key :id
        expect(json_response[:code]).not_to eql old_code
      end

      it 'does not update someone elses group' do
        put "/groups/#{other_group.id}/code"
        expect(response).to have_http_status :not_found
        expect(json_response).not_to have_key :id
      end
    end
  end
end
