# == Schema Information
# Schema version: 20100127014005
#
# Table name: warehouses
#
#  id                     :integer(4)      not null, primary key
#  administrative_area_id :integer(4)      not null
#  stock_room_id          :integer(4)      not null
#  created_at             :datetime
#  updated_at             :datetime
#

class Warehouse < ActiveRecord::Base
  unloadable

  belongs_to :stock_room
  belongs_to :administrative_area
  has_one :street_address, :as => 'addressed'
  
  def name
    I18n.t("Warehouse.#{code}")
  end
  
  def catchment_population
    administrative_area.population
  end
end


