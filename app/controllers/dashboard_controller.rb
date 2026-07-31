class DashboardController < ApplicationController
  def index
    @characters = current_user.characters.recently_updated
    @character_count = @characters.size
    @total_level = @characters.sum(&:total_level)
    @spellcaster_count = @characters.count(&:spellcaster?)
  end
end
