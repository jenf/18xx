# frozen_string_literal: true

require 'view/actionable'

require 'engine/action/buy_share'

module View
  class Exchange < Snabberb::Component
    include Actionable

    needs :selected_company, default: nil, store: true

    def render
      return h(:div) unless (ability = @selected_company&.abilities(:exchange))

      corporation = @game.corporation_by_id(ability[:corporation])
      share = corporation.shares.find { |s| !s.president }

      return h(:div) unless share

      exchange = lambda do
        process_action(Engine::Action::BuyShare.new(@selected_company, share))
        store(:selected_company, nil, skip: true)
      end

      h(:button, { on: { click: exchange } }, "Exchange for a share of #{corporation.name}")
    end
  end
end
