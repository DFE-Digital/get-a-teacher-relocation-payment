# == Schema Information
#
# Table name: events
#
#  id           :bigint           not null, primary key
#  action       :string
#  data         :jsonb
#  entity_class :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  entity_id    :integer
#
class Event < ApplicationRecord
  ACTIONS = [
    CREATED = "created".freeze,
    UPDATED = "updated".freeze,
    DELETED = "deleted".freeze,
  ].freeze

  validates(:action, presence: true)
  validates(:action, inclusion: { in: ACTIONS })
  validates(:entity_class, presence: true)
  validates(:entity_id, presence: true)
  validates(:data, presence: true, unless: :deleted?)

  class << self
    def publish(action, model, model_changes = {})
      create!(
        action: action&.to_s,
        entity_class: model&.class,
        entity_id: model&.id,
        data: filtered(model, model_changes),
      )
    end

  private

    def filtered(model, model_changes)
      model_changes.each_with_object({}) do |(attribute, diff), hsh|
        hsh[attribute] = diff
        hsh[attribute] = obfuscate(diff) if filtered_attribute?(model, attribute)

        hsh
      end
    end

    def filtered_attribute?(model, attribute)
      Rails.configuration.x.events.filtered_attributes
        .fetch(model.class.name, [])
        .include?(attribute)
    end

    def obfuscate(diff)
      Array(diff).map { |e| e.blank? ? e : "[FILTERED]" }
    end
  end

  def deleted?
    action == DELETED
  end
end
