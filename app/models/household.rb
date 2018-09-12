class Household < ApplicationRecord
  include Deactivatable

  acts_as_tenant :cluster

  belongs_to :community
  has_many :accounts, -> { joins(:community).includes(:community).order("LOWER(communities.name)") },
    inverse_of: :household, class_name: "Billing::Account", dependent: :destroy
  has_many :signups, dependent: :destroy
  has_many :users, -> { by_name_adults_first }, inverse_of: :household, dependent: :destroy
  has_many :vehicles, class_name: "People::Vehicle", dependent: :destroy
  has_many :emergency_contacts, class_name: "People::EmergencyContact", dependent: :destroy
  has_many :pets, class_name: "People::Pet", dependent: :destroy

  scope :active, -> { where("deactivated_at IS NULL") }
  scope :by_name, -> { order("LOWER(households.name)") }
  scope :by_unit, -> { order(:unit_num) }
  scope :by_active, -> { order("(CASE WHEN deactivated_at IS NULL THEN 0 ELSE 1 END)") }
  scope :ordered_by, ->(col) { col == "unit" ? by_unit : by_name }
  scope :by_commty_and_name, -> { joins(:community).order("LOWER(communities.abbrv)").by_name }
  scope :in_community, ->(c) { where(community_id: c.id) }
  scope :in_cluster, ->(c) { joins(:community).where("communities.cluster_id": c.id) }
  scope :matching, ->(q) { where("households.name ILIKE ?", "%#{q}%") }

  delegate :name, :abbrv, :cluster, to: :community, prefix: true

  validates :name, presence: true, length: { maximum: 32 },
    uniqueness: { scope: :community_id, message:
      "There is already a household with this name at this community" }
  validates :community_id, presence: true
  validates :unit_num, length: { maximum: 8 }, numericality: { only_integer: true, message: "Nust begin with a number" }, allow_nil: true
  validates :unit_suffix, length: { maximum: 10 }
  accepts_nested_attributes_for :vehicles, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :emergency_contacts, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :pets, reject_if: :all_blank, allow_destroy: true

  normalize_attributes :name, :unit_num, :old_id, :old_name, :garage_nums

  def build_blank_associations
    vehicles.build if vehicles.empty?
    emergency_contacts.build if emergency_contacts.empty?
    pets.build if pets.empty?
  end

  # Returns users (including children) directly in the household PLUS any children associated by parentage,
  # even if they aren't directly in the household via the foreign key.
  def users_and_children
    (users + adults.map(&:children).flatten).uniq
  end

  def other_cluster_communities
    cluster.communities - [community]
  end

  def adults
    users.select(&:adult?)
  end

  def account_for(community)
    @accounts_by_community ||= {}
    @accounts_by_community[community] ||= accounts.find_by(community_id: community.id)
  end

  def credit_exceeded?(community)
    account_for(community).try(:credit_exceeded?) || false
  end

  def no_users?
    users.empty?
  end

  def garage_nums=(str)
    write_attribute(:garage_nums, str.strip.blank? ? nil : str.split(/\s*,\s*/).join(", "))
  end

  def after_deactivate
    users.each(&:deactivate)
  end

  def user_activated
    activate
  end

  def user_deactivated
    deactivate(skip_callback: true) if users.all?(&:inactive?)
  end

  def any_assignments?
    users.any?(&:any_assignments?)
  end

  def any_accounts?
    accounts.any?
  end

  def any_signups?
    signups.any?
  end

  def any_users?
    users.any?
  end

  def any_transactions?
    accounts.any?{ |a| a.transactions.any? }
  end

  def any_accounts?
    accounts.any?
  end

  def any_statements?
    accounts.any?{ |a| a.statements.any? }
  end

#  attr_accessor(:unit_suffix)
  # Return the unit number and the suffix (if any), separated with a dash.
  def unit_num_and_suffix
    if unit_suffix.blank?
      unit_num
    else
      "#{unit_num}-#{unit_suffix}"
    end
  end

  def unit_num_and_suffix=(value)
    # separate unit number and suffix.  Format is either separated with a
    # non-alphanumeric character, or an alpha suffix with no separator.
    unit_data = value.match(/\A(\d+)\W?(\w*)/)
# if we don't match the regex, store it and let the validator do the complaining
    if unit_data.blank?
      self.unit_num = value
    else
      self.unit_num = unit_data[1]
# if we have no suffic, store nil
      if unit_data[2].blank?
        self.unit_suffix = nil
      else
        self.unit_suffix = unit_data[2]
      end
    end
  end
end
