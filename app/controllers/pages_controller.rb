class PagesController < ApplicationController
  def coming_soon
    redirect_to root_path, flash: { warning: "#{params[:feature]} estará disponível em breve." }
  end
end
