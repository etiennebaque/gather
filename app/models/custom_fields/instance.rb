module CustomFields
  # Abstract class. Models a concrete set of chosen config values for a given ConfigSpec.
  class Instance
    include ActiveModel::Model

    attr_accessor :spec, :root

    delegate :fields, to: :spec
    delegate :entries, :update, :[], to: :root

    # def self.model_name
    #   ActiveModel::Name.new(self, nil, name.split("::").last)
    # end
    #

    def initialize(spec_data:, instance_data:)
      raise ArgumentError.new("instance_data is required") if instance_data.nil?
      self.spec = Spec.new(spec_data)
      self.root = Entries::GroupEntry.new(field: spec.root, hash: instance_data)
    end

    # This is so that form point to update instead of create
    def persisted?
      true
    end

    def method_missing(symbol, *args)
      if root.keys.include?(symbol)
        root.send(symbol, *args)
      else
        super
      end
    end
  end
end
