# frozen_string_literal: true

class FakeCustomFieldModel
  include ActiveModel::Validations
  include CustomFields

  custom_fields :settings, spec: [
    {key: "fruit", type: "enum", options: %w[apple banana peach], required: true},
    {key: "info", type: "group", fields: [
      {key: "complete", type: "boolean"},
      {key: "comment", type: "string", validation: {length: {maximum: 5, message: :foo}}}
    ]}
  ]
end
