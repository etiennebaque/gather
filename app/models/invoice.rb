class Invoice < ActiveRecord::Base
  TERMS = 30 # days

  belongs_to :household, inverse_of: :invoices
  has_many :line_items, dependent: :nullify

  scope :for_community, ->(c){ includes(:household).where("households.community_id = ?", c.id) }

  delegate :community_id, to: :household

  # Populates the invoice with
  def populate
    self.line_items = LineItem.where(household: household).uninvoiced.to_a
    self.due_on = Date.today + TERMS
    self.total_due = prev_balance + line_items.map(&:amount).sum
  end

  # Populates the invoice and saves only if there are any line items.
  # Returns whether the invoice was saved.
  def populate!
    populate
    line_items.any? && save!
  end
end
