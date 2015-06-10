require 'spec_helper'

describe Profiles::PreferencesController do
  let(:user) { create(:user) }

  before do
    sign_in(user)

    allow(subject).to receive(:current_user).and_return(user)
  end

  describe 'GET show' do
    it 'renders' do
      get :show
      expect(response).to render_template :show
    end

    it 'assigns user' do
      get :show
      expect(assigns[:user]).to eq user
    end
  end

  describe 'PATCH update' do
    def go(params: {}, format: :js)
      params.reverse_merge!(
        color_scheme_id: '1',
        dashboard: 'stars',
        theme_id: '1'
      )

      patch :update, user: params, format: format
    end

    context 'on successful update' do
      it 'sets the flash' do
        go
        expect(flash[:notice]).to eq 'Preferences saved.'
      end

      it "changes the user's preferences" do
        prefs = {
          color_scheme_id: '1',
          dashboard: 'stars',
          theme_id: '2'
        }.with_indifferent_access

        expect(user).to receive(:update_attributes).with(prefs)

        go params: prefs
      end
    end

    context 'on unsuccessful update' do
      # TODO (rspeicher): Can this happen?
    end

    context 'as js' do
      it 'renders' do
        go
        expect(response).to render_template :update
      end
    end

    context 'as html' do
      it 'redirects' do
        go format: :html
        expect(response).to redirect_to(profile_preferences_path)
      end
    end
  end
end
