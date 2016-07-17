class ApplicationController < ActionController::Base
  before_action :set_i18n_locale_from_params
  protect_from_forgery with: :exception
  include SessionsHelper

  private
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t('flash.application_login')
      redirect_to login_url
    end
  end
  
  protected
  def set_i18n_locale_from_params
    I18n.locale = extract_locale_from_tld || I18n.default_locale
  end
  
  def extract_locale_from_tld
    parsed_locale = request.subdomains.first
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end
  
end