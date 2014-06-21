class Category < ActiveRecord::Base
  attr_accessible :name, :oe_id

  has_and_belongs_to_many :services, -> { uniq }

  validates :name, :oe_id, presence: { message: "can't be blank for Category" }

  has_ancestry

  extend FriendlyId
  friendly_id :slug_candidates, use: [:history]

  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
      :name,
      [:name, :oe_id]
    ]
  end
end
