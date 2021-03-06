# == Schema Information
# Schema version: 20100419182754
#
# Table name: equipment_types
#
#  id         :integer(4)      not null, primary key
#  code       :string(255)     not null
#  position   :integer(4)      default(0), not null
#  created_at :datetime
#  updated_at :datetime
#

class EquipmentType < ActiveRecord::Base
  include BasicModelSecurity

  validates_presence_of :code
  validates_uniqueness_of :code
  referenced_by :code
  
  named_scope :active, { :conditions => { 'active' => true } }

  include Comparable
  def <=>(other)
    position <=> other.position
  end
  
  def label
    I18n.t("EquipmentType.#{code}");
  end
end


