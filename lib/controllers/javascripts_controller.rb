class JavascriptsController < ApplicationController
  helper :olmis

  skip_before_filter :check_logged_in
  skip_before_filter :set_locale
end
